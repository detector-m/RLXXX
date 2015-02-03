//
//  ChannelsView.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsChannelMode.h"
#import "ChannelsButton.h"

@interface ChannelsView : UIView
@property (nonatomic, readonly, strong) NSMutableArray *channels;

- (CGFloat)reloadData;
@end
