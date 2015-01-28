//
//  LoginController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"

@protocol LoginControllerDelegate <ModuleControllerDelegate>
@optional
- (void)loginResponse:(GVResponse *)response;
@end

@interface LoginController : ModuleController
- (void)loginRequest:(NSString *)account password:(NSString *)password location:(UserLocation *)location  thirdOpenKey:(NSString *)openKey loginType:(__unused LoginType)loginType;

@end
