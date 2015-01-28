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
#import "UnsubscribChannelsView.h"

#define kChannelsViewTitleViewHeight 40.0f

@interface NewsChannelsView : UIView
@property (nonatomic, readonly, strong) ChannelsTitleView *titleView;
@property (nonatomic, readonly, strong) UIScrollView *channelsView;

@property (nonatomic, readonly, strong) SubscribeChannelsView *subscribeChannelsView;
@property (nonatomic, readonly, strong) UnsubscribChannelsView *unsubscribeChannelsView;
@end
