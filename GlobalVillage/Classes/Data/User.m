//
//  User.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "User.h"

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
    self.chikyugo = nil;
    self.password = nil;
    
    self.accessToken = nil;
    
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
    
    _accessToken = [accessToken copy];
}
@end
