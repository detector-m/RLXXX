//
//  ForgetPasswordController.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ForgetPasswordController.h"

@implementation ForgetPasswordController
+ (void)requestWithType:(RequestType)type parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:0 parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

//获取手机验证码
- (void)mobileAuthCodeRequest:(NSString *)phoneNumber appId:(NSString *)appId {
    NSMutableDictionary *parameters = [GVRequestParameterManager mobileAuthCodeParameter:phoneNumber appId:appId];
    if(!parameters) {
        DLog(@"mobileAuthCodeDic error!");
        NSAssert(parameters !=nil, @"mobileAuthCodeDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeMobileAuthCode parameters:parameters andDelegate:self];
}

//手机验证码验证
- (void)verifyMobileAuthCodeRequest:(NSString *)authCode withPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *parameters = [GVRequestParameterManager verifyMobileAuthCodeParameter:phoneNumber authCode:authCode];
    if(parameters == nil)
        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
    
    [[self class] requestWithType:kRequestTypeVerifyMobileAuthCode parameters:parameters andDelegate:self];
}

//找回密码接口
- (void)findPasswordRequest:(NSString *)mobileNumber authcode:(NSString *)authcode newPassword:(NSString *)newPassword {
    NSMutableDictionary *parameters = [GVRequestParameterManager findPasswordParameter:mobileNumber authcodeValue:authcode newPasswordValue:newPassword];
    if(parameters == nil)
        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
    
    [[self class] requestWithType:kRequestTypeFindPassword parameters:parameters andDelegate:self];
}

////设置密码
//- (void)resetPasswordRequest:(NSString *)oldPassword newPassword:(NSString *)newPassword accessToken:(NSString *)accessToken {
//    NSMutableDictionary *parameters = [GVRequestParameterManager resetPasswordParameter:oldPassword newPasswordValue:newPassword accessTokenValue:accessToken];
//    if(parameters == nil)
//        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
//    
//    [[self class] requestWithType:kRequestTypeResetPassword parameters:parameters andDelegate:self];
//}

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
    
    id<ForgetPasswordControllerDelegate> delegate = (id<ForgetPasswordControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeMobileAuthCode:
            if([delegate respondsToSelector:@selector(mobileAuthCodeResponse:)]) {
                [delegate mobileAuthCodeResponse:response];
            }
            break;
        case kRequestTypeVerifyMobileAuthCode:
            if([delegate respondsToSelector:@selector(verifyMobileAuthCodeResponse:)]) {
                [delegate verifyMobileAuthCodeResponse:response];
            }
            break;
            
        case kRequestTypeFindPassword:
            if([delegate respondsToSelector:@selector(findPasswordResponse:)]) {
                [delegate findPasswordResponse:response];
            }
            break;
            
        default:
            break;
    }
}
@end
