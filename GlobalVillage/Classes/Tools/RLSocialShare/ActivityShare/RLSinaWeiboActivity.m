//
//  RLSinaWeiboActivity.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLSinaWeiboActivity.h"

@implementation RLSinaWeiboActivity
- (instancetype)init {
    if(self = [super init]) {
        self.icon = [UIImage imageNamed:@"SinaWeibo.png"];
        self.title = NSLocalizedString(@"新浪微博", nil);        
    }
    
    return self;
}
@end
