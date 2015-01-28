//
//  RLRequest.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    kRLRequestStateReady,
    kRLRequestStateLoading,
    kRLRequestStateComplete,
    kRLRequestStateError
}RLRequestState;

@protocol RLRequestDelegate;

@interface RLRequest : NSObject
@property (nonatomic, weak) id<RLRequestDelegate> delegate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, readonly) RLRequestState state;
//@property (nonatomic, readonly) BOOL sessionDidExpire;

@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, assign) UInt8 subTag;

@property (nonatomic, strong) NSError *error;

+ (RLRequest *)openUrl:(NSString *)url
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod
              delegate:(id<RLRequestDelegate>)delegate;

+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params;

+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params
                httpMethod:(NSString *)httpMethod;

+ (RLRequest *)getReqeustWithParams:(NSMutableDictionary *)params
                         httpMethod:(NSString *)httpMethod
                           delegate:(id<RLRequestDelegate>)delegate
                         requestURL:(NSString *)url;

- (BOOL)loading;
- (void)connect;
@end

@protocol RLRequestDelegate <NSObject>

@optional
- (void)requestLoading:(RLRequest *)reqeust;

- (void)request:(RLRequest *)request
didReceiveResponse:(NSURLResponse *)response;

- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error;

- (void)request:(RLRequest *)request
        didLoad:(id)result;

- (void)request:(RLRequest *)request
didLoadRawResponse:(NSData *)data;

@end
