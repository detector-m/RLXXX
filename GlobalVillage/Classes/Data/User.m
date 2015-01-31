//
//  User.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "User.h"
#import "RLTypecast.h"

static User *_userInstance = nil;

@interface User ()
@property (nonatomic, readwrite, copy) NSString *accessToken;
@end

@implementation User
+ (User *)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInstance = [[User alloc] init];
    });
    
    return _userInstance;
}

- (void)dealloc {
    [self dataClear];
}

- (void)dataClear {
    self.account = nil;
    self.password = nil;
    self.accessToken = nil;
    
    self.easemobUserAccount = nil;
    self.easemobUserPassword = nil;
    
    [super dataClear];
}

- (void)testData {
    self.accessToken = @"OWI3ZjgwZjJmNzlhODQyZTAxOWZiMjVh";
}

- (instancetype)init {
    if(self = [super init]) {
        [self testData];
    }
    
    return self;
}

- (void)setAccessToken:(NSString *)accessToken {
    if(accessToken == nil || accessToken.length == 0)
        return;
    
    _accessToken = accessToken;
}

- (void)setAccount:(NSString *)account andPassword:(NSString *)password {
    self.account = account;
    self.password = password;
}

- (void)fillLoginData:(NSArray *)loginData andToken:(NSString *)accessToken {
    if(loginData == nil)
        return;
    
    DLog(@"%@", loginData);
    NSDictionary *loginDic = [loginData firstObject];
    
    self.nickname = [loginDic objectForKey:RespondFieldMemberNameKey];
    self.dqNumber = [loginDic objectForKey:RespondFieldGuestChikyugoKey];
    self.phone = [loginDic objectForKey:RespondFieldPhoneKey];
    self.gender = (GenderType)[RLTypecast stringToInteger:[loginDic objectForKey:RespondFieldSexKey]];
    self.age = [RLTypecast stringToInteger:[loginDic objectForKey:RespondFieldAgeKey]];
    self.signature = [loginDic objectForKey:RespondFieldSignatureKey];
    self.registeredCity = [loginDic objectForKey:RespondFieldRegisteredCityKey];
    self.pic = [loginDic objectForKey:RespondFieldPicKey];
    self.type =  (UserType)[RLTypecast stringToInteger:[loginDic objectForKey:RespondFieldMemberTypeKey]];
    
    self.easemobUserAccount = [loginDic objectForKey:RespondFieldEasemobUserIdKey];
    self.easemobUserPassword = [loginDic objectForKey:RespondFieldEasemobUserPwdKey];
    
    self.accessToken = accessToken;
}
@end

//#pragma mark - 环信
//@implementation EasemobUser
//- (void)dealloc {
//    self.easemobUserAccount = nil;
//    self.easemobUserPassword = nil;
//}
//@end
