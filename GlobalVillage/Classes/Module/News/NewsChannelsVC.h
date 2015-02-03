//
//  NewsChannelsVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import "NewsChannelsView.h"

@class NewsVC;
@interface NewsChannelsVC : RLBaseViewController
@property (nonatomic, readonly, strong) NewsChannelsView *channelsView;

@property (nonatomic, weak) NewsVC *newsVC;
@end
