//
//  ModuleController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"

@interface ModuleController ()
@end
@implementation ModuleController
+ (GVResponse *)responseWithReqeustResponseData:(id)responseData {
    if(responseData == nil)
        return nil;
    
    GVResponse *response = [[GVResponse alloc] init];
    
    if([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = responseData;
        response.status = [[dic objectForKey:RespondFieldStatusKey] integerValue];
        response.message = [dic objectForKey:RespondFieldMessageKey];
    }
    
    return response;
}

- (NSDictionary *)constructResponseErrorWithResponse:(GVResponse *)response {
    NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu", (unsigned long)response.status], @"status", response.message, @"message", nil];
    
    return error;
}

- (void)removeAllRequest {
    [GVRequestManager removeAllRequestForKey:NSStringFromClass([self class])];
}


#pragma mark - RLRequestDelegate
- (void)requestLoading:(RLRequest *)reqeust {
    
}

- (void)request:(RLRequest *)request
didReceiveResponse:(NSURLResponse *)response {

}

- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {

}

- (void)request:(RLRequest *)request
        didLoad:(id)result {
}

- (void)request:(RLRequest *)request
didLoadRawResponse:(NSData *)data {

}
@end
