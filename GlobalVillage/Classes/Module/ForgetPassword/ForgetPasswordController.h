//
//  ForgetPasswordController.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"
@protocol ForgetPasswordControllerDelegate <ModuleControllerDelegate>
@optional
- (void)mobileAuthCodeResponse:(GVResponse *)response;
- (void)verifyMobileAuthCodeResponse:(GVResponse *)response;
- (void)findPasswordResponse:(GVResponse *)response;
@end

@interface ForgetPasswordController : ModuleController
- (void)mobileAuthCodeRequest:(NSString *)phoneNumber appId:(NSString *)appId;
//手机验证码验证
- (void)verifyMobileAuthCodeRequest:(NSString *)authCode withPhoneNumber:(NSString *)phoneNumber;

//找回密码接口
- (void)findPasswordRequest:(NSString *)mobileNumber authcode:(NSString *)authcode newPassword:(NSString *)newPassword;
@end
