//
//  ShareAppModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLShareAppModel.h"

@implementation RLShareAppModel
- (void)dealloc {
    [self clearDatas];
}

- (void)clearDatas {
    self.appKey = nil;
    self.appSecret = nil;
    self.appRedirectURI = nil;
    
    self.appAccessToken = nil;
    self.appUserId = nil;

}
@end
