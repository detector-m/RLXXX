//
//  User.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "UserBase.h"
#import "TypesHeader.h"

@interface User : UserBase
@property (nonatomic, copy) NSString *chikyugo;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, readwrite, assign) LoginType loginType;
//@property (nonatomic, copy) NSString *openKey;

@property (nonatomic, readonly, copy) NSString *accessToken;

+ (User *)sharedUser;
@end
