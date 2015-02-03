//
//  ChannelsView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChannelsView.h"

@interface ChannelsView ()
@property (nonatomic, readwrite, strong) NSMutableArray *channels;
@end
@implementation ChannelsView

- (void)dealloc {
    [self.channels removeAllObjects], self.channels = nil;
}

- (void)dataDoLoad {
    if(self.channels) {
        return;
    }
    
    self.channels = [NSMutableArray array];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self dataDoLoad];
    }
    
    return self;
}

- (CGFloat)reloadData {
    if(self.channels.count == 0)
        return 0.0f;
    CGFloat padding = 15;
    CGFloat height = 30;
    CGFloat width = (self.frame.size.width-15*5)/4;
    CGFloat x = 0;
    CGFloat y = 0;
    CGRect frame;
    
    NewsChannelMode *channel = nil;
    for(NSInteger i=0; i<self.channels.count; i++) {
        x = padding*((i%4)+1) + (i%4)*width;
        y = padding*((i/4)+1) + (i/4)*height;
        frame = CGRectMake(x, y, width, height);
        channel = [self.channels objectAtIndex:i];
        ChannelsButton *button = channel.channelView;
        button.deleteImageView.hidden = YES;
        button.frame = frame;
    }
    
    y += padding+height;
    
    return y;
}

@end
