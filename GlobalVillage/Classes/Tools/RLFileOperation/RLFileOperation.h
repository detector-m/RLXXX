//
//  FileOperation.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/19.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLFileOperation : NSObject
+ (NSDictionary *)constructUserLoginInfo:(NSString *)name pwd:(NSString *)pwd date:(NSDate *)date plateforme:(NSString *)plateforme openKey:(NSString *)openKey;
+ (void)setUserLoginInfo:(NSDictionary *)dic;
+ (void)removeUserLoginInfo;
+ (NSDictionary *)userLoginInfo;

+ (BOOL)isLogined;

+ (BOOL)storeLoginInfo:(NSString *)name pwd:(NSString *)pwd date:(NSDate *)date plateforme:(NSString *)plateforme openKey:(NSString *)openKey;

@end
