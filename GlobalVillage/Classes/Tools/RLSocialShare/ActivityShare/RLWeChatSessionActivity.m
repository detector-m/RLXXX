//
//  RLWeChatActivity.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLWeChatSessionActivity.h"

@implementation RLWeChatSessionActivity
- (instancetype)init {
    if(self = [super init]) {
        self.icon = [UIImage imageNamed:@"WeChat.png"];
        self.title = NSLocalizedString(@"微信", nil);
        
//        self.message = [[RLShareMessageModel alloc] init];
    }
    
    return self;
}
@end
