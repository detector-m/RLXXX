//
//  NewsChannelsView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsChannelsView.h"

@interface NewsChannelsView ()
@property (nonatomic, readwrite, strong) ChannelsTitleView *titleView;
@property (nonatomic, readwrite, strong) UIScrollView *channelsView;

@property (nonatomic, readwrite, strong) SubscribeChannelsView *subscribeChannelsView;
@property (nonatomic, readwrite, strong) UnsubscribChannelsView *unsubscribeChannelsView;
@end

@implementation NewsChannelsView
- (void)dealloc {
    self.titleView = nil;
    self.channelsView = nil;
    self.subscribeChannelsView = nil;
    self.unsubscribeChannelsView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
//        CGFloat widthOffset = 0;
//        CGFloat heightOffset = 0;
        self.titleView = [[ChannelsTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kChannelsViewTitleViewHeight)];
        self.titleView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.titleView];
        
        [self channelsViewDoLoadWithFrame:frame];
    }

    return self;
}

- (void)channelsViewDoLoadWithFrame:(CGRect)frame {
    CGFloat heightOffset = self.titleView.frame.size.height;
    self.channelsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, frame.size.height-kChannelsViewTitleViewHeight)];
    self.channelsView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.channelsView];
    
    self.subscribeChannelsView = [[SubscribeChannelsView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kChannelsViewTitleViewHeight)];
    [self constructSubscribe];
    [self.channelsView addSubview:self.subscribeChannelsView];
    
    heightOffset = self.subscribeChannelsView.frame.size.height;
    UILabel *label = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(0, heightOffset, frame.size.width, kChannelsViewTitleViewHeight)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"点击添加频道", nil);
    [self.channelsView addSubview:label];
    
    heightOffset += label.frame.size.height;
    self.unsubscribeChannelsView = [[UnsubscribChannelsView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, kChannelsViewTitleViewHeight)];
    [self constructUnsubscribe];
    [self.channelsView addSubview:self.unsubscribeChannelsView];
    
    self.channelsView.contentSize = CGSizeMake(frame.size.width, self.subscribeChannelsView.frame.size.height+kChannelsViewTitleViewHeight + self.unsubscribeChannelsView.frame.size.height);
}

- (UIButton *)constructChannelButtonWithTitle:(NSString *)text frame:(CGRect)frame {
    UIButton *button = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    
    return button;
}

- (void)constructSubscribe {
    CGFloat padding = 15;
    CGFloat height = 30;
    CGFloat width = (self.frame.size.width-15*5)/4;
    CGFloat x = padding;
    CGFloat y = padding;
    CGRect frame;
    
    for(NSInteger i=0; i<10; i++) {
        x = padding*((i%4)+1) + (i%4)*width;
        y = padding*((i/4)+1) + (i/4)*height;
        frame = CGRectMake(x, y, width, height);
        UIButton *button = [self constructChannelButtonWithTitle:@"test" frame:frame];
//        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 5, 5);
        button.backgroundColor = [UIColor redColor];
        [self.subscribeChannelsView addSubview:button];
        [self.subscribeChannelsView.channels addObject:button];
    }
    
    frame = self.subscribeChannelsView.frame;
    self.subscribeChannelsView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, y+padding+width);
}

- (void)constructUnsubscribe {
    CGFloat padding = 15;
    CGFloat height = 30;
    CGFloat width = (self.frame.size.width-15*5)/4;
    CGFloat x = padding;
    CGFloat y = padding;
    CGRect frame;
    
    for(NSInteger i=0; i<10; i++) {
        x = padding*((i%4)+1) + (i%4)*width;
        y = padding*((i/4)+1) + (i/4)*height;
        frame = CGRectMake(x, y, width, height);
        UIButton *button = [self constructChannelButtonWithTitle:@"test" frame:frame];
        [self.unsubscribeChannelsView addSubview:button];
        [self.unsubscribeChannelsView.channels addObject:button];
    }
    
    frame = self.unsubscribeChannelsView.frame;
//    frame.origin.x = self.subscribeChannelsView.frame.size.height + kChannelsViewTitleViewHeight;
    frame.origin.y = self.subscribeChannelsView.frame.size.height + kChannelsViewTitleViewHeight;
    frame.size.height = y+padding+width;
    self.unsubscribeChannelsView.frame = frame;
}
@end
