//
//  ShareMessageModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLShareMessageModel.h"

@implementation RLShareMessageModel
- (void)dealloc {
    self.title = nil;
    self.abstract = nil;
    self.scheme = nil;
    self.imageData = nil;
    self.thumbData = nil;
    self.url = nil;
}

- (void)fillDefaultData {
    self.title = @"share";
    self.abstract = @"一款免费发送广告的APP！手机号、微信号、地球号一个都不能少！";
    self.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SinaWeibo" ofType:@"png"]];
    self.url = @"http://www.dqcc.com.cn";
}
@end
