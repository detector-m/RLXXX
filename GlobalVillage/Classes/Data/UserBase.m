//
//  UserBase.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "UserBase.h"

@interface UserBase ()
@property (nonatomic, readwrite, strong) UserLocation *location;
@end

@implementation UserBase
- (void)dealloc {
    [self dataClear];
}

- (instancetype)init {
    if(self = [super init]) {
        self.location = [[UserLocation alloc] init];
    }
    
    return self;
}

- (void)dataClear {
    [self.location dataClear];
    
    self.nickname = nil;
    self.phone = nil;
    self.gender = 0;
    self.age = 0;
    self.signature = nil;
    self.registeredCity = nil;
    self.pic = nil;
    
    self.type = 0;
}
@end
