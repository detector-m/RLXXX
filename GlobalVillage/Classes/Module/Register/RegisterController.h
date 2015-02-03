//
//  RegisterController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"

@protocol RegisterControllerDelegate <ModuleControllerDelegate>
@optional
- (void)verifyPhoneNumberResponse:(GVResponse *)response;

- (void)verifyMobileAuthCodeResponse:(GVResponse *)response;

- (void)freeDQNumberListResponse:(GVResponse *)response;
- (void)chargeDQNumberListResponse:(GVResponse *)response;
- (void)verifyDQNumberResponse:(GVResponse *)response;

- (void)registerResponse:(GVResponse *)response;
@end

@interface RegisterController : ModuleController
//@property (nonatomic, readwrite, weak) id<ModuleControllerDelegate>delegate;
@property (nonatomic, readwrite, strong) id responseContent;

- (void)verifyPhoneNumberRequest:(NSString *)phoneNumber;

- (void)mobileAuthCodeRequest:(NSString *)phoneNumber appId:(NSString *)appId;
//手机验证码验证
- (void)verifyMobileAuthCodeRequest:(NSString *)authCode withPhoneNumber:(NSString *)phoneNumber;

- (void)dqNumberList:(NSInteger)chargeType andCount:(NSInteger)count;
- (void)verifyDQNumber:(NSString *)dqNumber;

- (void)requestRegist:(NSString *)dqNumber phoneNumber:(NSString *)phoneNumber password:(NSString *)password gender:(NSInteger)gender nickname:(NSString *)nickname location:(UserLocation *)location /*pic:(NSData *)pic*/;
@end
