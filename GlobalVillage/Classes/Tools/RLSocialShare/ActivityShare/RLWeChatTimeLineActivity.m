//
//  RLWeChatTimeLineActivity.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLWeChatTimeLineActivity.h"

@implementation RLWeChatTimeLineActivity
- (instancetype)init {
    if(self = [super init]) {
        self.icon = [UIImage imageNamed:@"WeChatTimeLine.png"];
        self.title = NSLocalizedString(@"微信朋友圈", nil);
        
//        self.message = [[RLShareMessageModel alloc] init];
    }
    
    return self;
}
@end
