//
//  RLActivityShare.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLSinaWeiboActivity.h"
#import "RLWeChatSessionActivity.h"
#import "RLWeChatTimeLineActivity.h"

@interface RLActivityShare : NSObject
@property (nonatomic, weak) UIViewController *showVC;
@property (nonatomic, strong) NSArray *showItems;
@property (nonatomic, strong) NSArray *appActivities;

@property (nonatomic, copy) id completionHandler;

- (void)showActivityViewController;
@end
