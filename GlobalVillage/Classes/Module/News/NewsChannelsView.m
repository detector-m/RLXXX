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
@property (nonatomic, readwrite, strong) UILabel *unsubscribChannelWarnLabel;
@property (nonatomic, readwrite, strong) UnsubscribChannelsView *unsubscribeChannelsView;

@property (nonatomic, assign) BOOL editAble;
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
        self.titleView = [[ChannelsTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kChannelsViewTitleViewHeight)];
        self.titleView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.titleView];
        
        [self.titleView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self channelsViewDoLoadWithFrame:frame];
        
        self.editAble = NO;
    }

    return self;
}

- (void)channelsViewDoLoadWithFrame:(CGRect)frame {
    CGFloat heightOffset = self.titleView.frame.size.height;
    self.channelsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, frame.size.height-kChannelsViewTitleViewHeight)];
    self.channelsView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.channelsView];
    
    self.subscribeChannelsView = [[SubscribeChannelsView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kChannelsViewTitleViewHeight)];
    [self constructSubscribeChannels];
    [self.channelsView addSubview:self.subscribeChannelsView];
    
    heightOffset = self.subscribeChannelsView.frame.size.height;
    self.unsubscribChannelWarnLabel = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(0, heightOffset, frame.size.width, kChannelsViewTitleViewHeight)];
    self.unsubscribChannelWarnLabel.backgroundColor = [UIColor lightGrayColor];
    self.unsubscribChannelWarnLabel.text = NSLocalizedString(@"点击添加频道", nil);
    [self.channelsView addSubview:self.unsubscribChannelWarnLabel];
    
    heightOffset += self.unsubscribChannelWarnLabel.frame.size.height;
    self.unsubscribeChannelsView = [[UnsubscribChannelsView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, kChannelsViewTitleViewHeight)];
    [self constructUnsubscribeChannels];
    [self.channelsView addSubview:self.unsubscribeChannelsView];
    
    self.channelsView.contentSize = CGSizeMake(frame.size.width, self.subscribeChannelsView.frame.size.height+kChannelsViewTitleViewHeight + self.unsubscribeChannelsView.frame.size.height);
}

- (UIButton *)constructChannelButtonWithTitle:(NSString *)text frame:(CGRect)frame {
    UIButton *button = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    
    return button;
}

- (void)constructSubscribeChannels {
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
        [button addTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeChannelsView addSubview:button];
        [self.subscribeChannelsView.channels addObject:button];
    }
    
    frame = self.subscribeChannelsView.frame;
    frame.size.height = y+padding+height;
    self.subscribeChannelsView.frame = frame;
}

- (void)constructUnsubscribeChannels {
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
        [button addTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.unsubscribeChannelsView addSubview:button];
        [self.unsubscribeChannelsView.channels addObject:button];
    }
    
    frame = self.unsubscribeChannelsView.frame;
    frame.origin.y = self.subscribeChannelsView.frame.size.height + kChannelsViewTitleViewHeight;
    frame.size.height = y+padding+width;
    self.unsubscribeChannelsView.frame = frame;
}

- (void)clickEditButton:(UIButton *)button {
    self.editAble = !self.editAble;
    if([button.titleLabel.text isEqualToString:NSLocalizedString(@"编辑", nil)]) {
        [button setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    }
    else {
        [button setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    }
}

- (void)clickUnsubscribeChannel:(UIButton *)button {
    if(!self.editAble) {
        return;
    }
    [button removeTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [button removeFromSuperview];
    [self.subscribeChannelsView.channels removeObject:button];
    
    [button addTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.unsubscribeChannelsView addSubview:button];
    [self.unsubscribeChannelsView.channels insertObject:button atIndex:0];
    
    [self reloadData];
}

- (void)clickSubscribeChannel:(UIButton *)button {
    if(!self.editAble) {
        return;
    }
    [button removeTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [button removeFromSuperview];
    [self.unsubscribeChannelsView.channels removeObject:button];
    
    [button addTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.subscribeChannelsView addSubview:button];
    [self.subscribeChannelsView.channels addObject:button];
    [self reloadData];
}

- (void)reloadData {
    CGRect frame = self.subscribeChannelsView.frame;
    CGFloat height = [self.subscribeChannelsView reloadData];
    frame.size.height = height;
    self.subscribeChannelsView.frame = frame;
    
    frame = self.unsubscribChannelWarnLabel.frame;
    frame.origin.y = height;
    self.unsubscribChannelWarnLabel.frame = frame;
    
    height += frame.size.height;
    
    frame = self.unsubscribeChannelsView.frame;
    frame.origin.y = height;
    height = [self.unsubscribeChannelsView reloadData];
    frame.size.height = height;
    
    self.unsubscribeChannelsView.frame = frame;
}
@end
