//
//  NewsChannelsView.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelsTitleView.h"
#import "SubscribeChannelsView.h"
#import "UnsubscribeChannelsView.h"

#import "NewsVC.h"

#define kChannelsViewTitleViewHeight 40.0f

@class NewsChannelsVC;
@interface NewsChannelsView : UIView
@property (nonatomic, readonly, strong) ChannelsTitleView *titleView;
@property (nonatomic, readonly, strong) UIScrollView *channelsView;

@property (nonatomic, readonly, strong) SubscribeChannelsView *subscribeChannelsView;
@property (nonatomic, readonly, strong) UnsubscribeChannelsView *unsubscribeChannelsView;

@property (nonatomic, weak) NewsChannelsVC *belongVC;

- (instancetype)initWithFrame:(CGRect)frame andVC:(NewsVC *)newsVC;
@end
