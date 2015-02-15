//
//  User.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "UserBase.h"

@class EasemobUser;
@interface User : UserBase
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL logined;
@property (nonatomic, readwrite, assign) LoginType loginType;
//@property (nonatomic, copy) NSString *openKey;
@property (nonatomic, readonly, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *easemobUserAccount;
@property (nonatomic, copy) NSString *easemobUserPassword;

+ (User *)sharedUser;

- (void)setAccount:(NSString *)account andPassword:(NSString *)password;
- (void)getAccountInfo;
- (void)fillLoginData:(NSDictionary *)loginData andToken:(NSString *)accessToken;
@end

//#pragma mark - 环信
//@interface EasemobUser : NSObject
//@property (nonatomic, copy) NSString *easemobUserAccount;
//@property (nonatomic, copy) NSString *easemobUserPassword;
//@end
