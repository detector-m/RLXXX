//
//  MineController.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MineController.h"

@implementation MineController
+ (void)requestWithType:(RequestType)type parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:0 parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

//设置密码
- (void)resetPasswordRequest:(NSString *)oldPassword newPassword:(NSString *)newPassword accessToken:(NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager resetPasswordParameter:oldPassword newPasswordValue:newPassword accessTokenValue:accessToken];
    if(parameters == nil)
        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
    
    [[self class] requestWithType:kRequestTypeResetPassword parameters:parameters andDelegate:self];
}

//更新资料
- (void)updateUserInfoRequest:(NSString *)nickname sex:(NSString *)sex city:(NSString *)city headPortrait:(NSString *)headPortrait age:(NSString *)age signature:(NSString *)signature accessToken:(NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager UpdateUserInfoParameter:nickname sexValue:sex cityValue:city headPortraitValue:headPortrait ageValue:age signatureValue:signature  accessTokenValue:accessToken];
    if(parameters == nil)
        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
    
    [[self class] requestWithType:kRequestTypeUpdateUserInfo parameters:parameters andDelegate:self];
}

#pragma mark - RLRequestDelegate
- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {
    DLog(@"%@", error);
    [GVPopViewManager removeActivity];
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
    
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
    
    id<MineControllerDelegate> delegate = (id<MineControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeResetPassword:
            if([delegate respondsToSelector:@selector(resetPasswordResponse:)]) {
                [delegate resetPasswordResponse:response];
            }
            break;
        case kRequestTypeUpdateUserInfo:
            if([delegate respondsToSelector:@selector(updateUserInfoResponse:)]) {
                [delegate updateUserInfoResponse:response];
            }
            break;
            
        default:
            break;
    }
}
@end
