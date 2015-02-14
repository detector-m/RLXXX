//
//  MineController.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"

@protocol MineControllerDelegate <ModuleControllerDelegate>
@optional
- (void)resetPasswordResponse:(GVResponse *)response;

- (void)updateUserInfoResponse:(GVResponse *)response;
@end
@interface MineController : ModuleController
- (void)resetPasswordRequest:(NSString *)oldPassword newPassword:(NSString *)newPassword accessToken:(NSString *)accessToken;

- (void)updateUserInfoRequest:(NSString *)nickname sex:(NSString *)sex city:(NSString *)city headPortrait:(NSString *)headPortrait age:(NSString *)age signature:(NSString *)signature accessToken:(NSString *)accessToken;
@end
