//
//  RLRequest.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRequest.h"
#import "JSON.h"
#import "RLReachabilityChecker.h"

static NSString *kUserAgent = @"RLRequestConnect";
static const NSString *kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";
static const NSTimeInterval kTimeoutInterval = 180.0;

@interface RLRequest ()

@property (nonatomic, readwrite) RLRequestState state;
//@property (nonatomic, readwrite) BOOL sessionDidExpire;
@end

@implementation RLRequest

+ (RLRequest *)openUrl:(NSString *)url
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod
              delegate:(id<RLRequestDelegate>)delegate
{
    RLRequest *_request = [RLRequest getReqeustWithParams:params httpMethod:httpMethod delegate:delegate requestURL:url];
    [_request connect];
    
    return _request;
}

+ (RLRequest *)getReqeustWithParams:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod
                           delegate:(id<RLRequestDelegate>)delegate
                         requestURL:(NSString *)url
{
    RLRequest *request = [[RLRequest alloc] init];
    
    request.delegate = delegate;
    //    request.delegate = nil;
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.connection = nil;
    request.responseData = nil;
    
    return request;
}

+ (NSString *)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params
{
    return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}

+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params
                httpMethod:(NSString *)httpMethod {
    NSURL *parsedURL = [[NSURL URLWithString:baseUrl] absoluteURL];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray *pairs = [NSMutableArray array];
    for(NSString *key in [params keyEnumerator]){
        if([[params objectForKey:key] isKindOfClass:[UIImage class]] || [[params objectForKey:key] isKindOfClass:[NSData class]]){
            if([httpMethod isEqualToString:@"GET"]){
                NSLog(@"不能使用 GET 上传文件");
            }
            continue;
        }
        
        id object = [params objectForKey:key];
        if([object isKindOfClass:[NSString class]]){
            
        }
        else if([object isKindOfClass:[NSNumber class]])
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            object = [numberFormatter stringFromNumber:object];
            numberFormatter = nil;
        }
        NSString *escaped_value = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)object, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

/**
 body 增加 －－》 POST 方法
 */
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

/*构建POST方法的 body*/
- (NSMutableData *)generatePostBody {
    NSMutableData *body = [NSMutableData data];
    NSString  *endLine = [NSString stringWithFormat:@"\r\n--%@]r]n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    [self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
    for(id key in [_params keyEnumerator]){
        if([[_params objectForKey:key] isKindOfClass:[UIImage class]] || [[_params objectForKey:key] isKindOfClass:[NSData class]]){
            [dataDictionary setObject:[_params objectForKey:key] forKey:key];
            continue;
        }
        [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"%@\"\r\n\r\n", key]];
        [self utfAppendBody:body data:[_params objectForKey:key]];
        [self utfAppendBody:body data:endLine];
    }
    
    if([dataDictionary count] > 0) {
        for(id key in dataDictionary){
            NSObject *dataParam = [dataDictionary objectForKey:key];
            if([dataParam isKindOfClass:[UIImage class]]){
                NSData *imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition:form-data;filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Type:image/png\r\n\r\n"]];
                [body appendData:imageData];
            }
            else {
                NSAssert([dataParam isKindOfClass:[NSData class]], @"dataParam must be a UIImage or NSData");
                [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition:form-data;filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Type:content/unknown\r\n\r\n"]];
                [body appendData:(NSData *)dataParam];
            }
            [self utfAppendBody:body data:endLine];
        }
    }
    
    return body;
}

/*
 错误信息处理
 */
- (id)formError:(NSInteger)code userInfo:(NSDictionary *)errorData{
    return [NSError errorWithDomain:@"GlobalVillageErrDomain" code:code userInfo:errorData];
}

/*解析响应数据*/
#define GeneralErrorCode 10000
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([responseString isEqualToString:@"true"]){
        return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
    }
    else if([responseString isEqualToString:@"false"]){
        if(error != nil){
            *error = [self formError:GeneralErrorCode userInfo:[NSDictionary dictionaryWithObject:@"这个操作不能完成" forKey:@"error_msg"]];
        }
        return nil;
    }
    SBJSON *jsonParser = [[SBJSON alloc] init];
    id result = [jsonParser objectWithString:responseString];
    jsonParser = nil;
    
    if(result == nil){
        return responseString;
    }
    
    if([result isKindOfClass:[NSDictionary class]]){
        if([result objectForKey:@"error"] != nil){
            if(error != nil){
                *error = [self formError:GeneralErrorCode userInfo:result];
            }
            return nil;
        }
        if([result objectForKey:@"error_code"] != nil){
            if(error != nil){
                *error = [self formError:[[result objectForKey:@"error_code"] integerValue] userInfo:result];
            }
            return nil;
        }
        
        if([result objectForKey:@"error_msg"] != nil){
            if(error != nil){
                *error = [self formError:GeneralErrorCode userInfo:result];
            }
        }
    }
    
    return result;
}

/*
 request 错误处理函数，调用代理函数
 */
- (void)failWithError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(request:didFailWithError:)]){
        [_delegate request:self didFailWithError:error];
    }
}

/*响应处理函数*/
- (void)handleResponseData:(NSData *)data {
    if([_delegate respondsToSelector:@selector(request:didLoadRawResponse:)]){
        [_delegate request:self didLoadRawResponse:data];
    }
    
    NSError *error = nil;
    id result = [self parseJsonResponse:data error:&error];
    self.error = error;
    
    if([_delegate respondsToSelector:@selector(request:didLoad:)] || [_delegate respondsToSelector:@selector(request:didFailWithError:)]){
        if(error) {
            [self failWithError:error];
        }
        else if([_delegate respondsToSelector:@selector(request:didLoad:)]){
            [_delegate request:self didLoad:result];
        }
    }
}

/*
 这个请求是否正在进行
 */
- (BOOL)loading{
    return !!_connection;
}

/*request*/
- (void)connect{
    if(![RLReachabilityChecker isReachability]) {
        DLog(@"没有网络");
        return;
    }
    
    if([_delegate respondsToSelector:@selector(requestLoading:)]){
        [_delegate requestLoading:self];
    }
    
    NSString *url = [[self class] serializeURL:_url params:_params httpMethod:_httpMethod];
    DLog(@"request url = %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kTimeoutInterval];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPMethod:self.httpMethod];
    if([self.httpMethod isEqualToString:@"POST"]){
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[self generatePostBody]];
    }
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.state = kRLRequestStateLoading;
//    self.sessionDidExpire = NO;
}

- (void)dealloc{
    [_connection cancel];
    _connection = nil;
    _responseData = nil;
    _url = nil;
    _httpMethod = nil;
    _params = nil;
}
//NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _responseData = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if([_delegate respondsToSelector:@selector(request:didReceiveResponse:)]){
        [_delegate request:self didReceiveResponse:httpResponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self handleResponseData:_responseData];
    
    self.responseData = nil;
    self.connection = nil;
    self.state = kRLRequestStateComplete;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self failWithError:error];
    
    self.responseData = nil;
    self.connection = nil;
    self.state = kRLRequestStateComplete;
}
@end
