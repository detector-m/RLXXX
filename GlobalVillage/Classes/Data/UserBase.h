//
//  UserBase.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocation.h"

@interface UserBase : NSObject
@property (nonatomic, readonly, strong) UserLocation *location;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger gender; //性别
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *registeredCity;
@property (nonatomic, strong) NSData *pic;

@property (nonatomic, assign) NSInteger type; //用户是否为商家，1，普通用户，2商家

- (void)dataClear;
@end
