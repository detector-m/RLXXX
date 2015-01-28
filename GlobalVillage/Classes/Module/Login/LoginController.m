//
//  LoginController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController
+ (void)requestWithType:(RequestType)type parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:0 parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

- (void)loginRequest:(NSString *)account password:(NSString *)password location:(UserLocation *)location  thirdOpenKey:(NSString *)openKey loginType:(__unused LoginType)loginType  {
    NSMutableDictionary *parameters = [GVRequestParameterManager loginParameter:account passwordValue:password latitudeValue:[RLTypecast doubleToString:location.latitude] longtitudeValue:[RLTypecast doubleToString:location.longitude] cityValue:location.city thirdIdValue:openKey];
    if(!parameters) {
        DLog(@"login error!");
        NSAssert(parameters !=nil, @"login error!");
    }
    
    [[self class] requestWithType:kRequestTypeLogin parameters:parameters andDelegate:self];
}

#pragma mark - RLRequestDelegate
- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {
    DLog(@"%@", error);
    [GVPopViewManager removeActivity];
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
    
    //    id<RegisterControllerDelegate> delegate = (id<RegisterControllerDelegate>)self.delegate;
    //    if([delegate respondsToSelector:@selector(request:didLoadFailed:)]) {
    //        [delegate request:request didLoadFailed:error];
    //
    //        return;
    //    }
    
    dispatch_block_t block = NULL;
    block = ^() {
        [GVPopViewManager showDialogWithTitle:@"网络有问题"];
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)request:(RLRequest *)request
        didLoad:(id)result {
    [GVPopViewManager removeActivity];
    
    [self responseWithType:request.tag result:result];
    
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
}

- (void)responseWithType:(RequestType)type result:(id)result {
    if(self.delegate == nil)
        return;
    
    GVResponse *response = [[self class] responseWithReqeustResponseData:result];
    
    id<LoginControllerDelegate> delegate = (id<LoginControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeLogin: {
//            response.responseData = result;
            if([delegate respondsToSelector:@selector(loginResponse:)]) {
                [delegate loginResponse:response];
            }
        }
            break;
        default:
            break;
    }
}

@end
