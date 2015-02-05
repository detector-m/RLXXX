//
//  NewsChannelsView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsChannelsView.h"
#import "NewsSegmentModel.h"
#import "NewsChannelMode.h"
#import "ChannelsButton.h"

#import "SingleChannelNewsVC.h"
#import "NewsChannelsVC.h"

#define kDefaultColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]

@interface NewsChannelsView ()
@property (nonatomic, readwrite, strong) ChannelsTitleView *titleView;
@property (nonatomic, readwrite, strong) UIScrollView *channelsView;

@property (nonatomic, readwrite, strong) SubscribeChannelsView *subscribeChannelsView;
@property (nonatomic, readwrite, strong) UILabel *unsubscribChannelWarnLabel;
@property (nonatomic, readwrite, strong) UnsubscribeChannelsView *unsubscribeChannelsView;

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, weak) NewsVC *newsVC;
@property (nonatomic, weak) NSArray *segments;
@end

@implementation NewsChannelsView
- (void)dealloc {
    self.titleView = nil;
    self.channelsView = nil;
    self.subscribeChannelsView = nil;
    self.unsubscribeChannelsView = nil;

    self.newsVC = nil;
    self.segments = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.titleView = [[ChannelsTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kChannelsViewTitleViewHeight)];
        self.titleView.backgroundColor = kDefaultColor;//[UIColor colorWithRed:174/255.0 green:221/255.0 blue:227/255.0 alpha:0.75];//[UIColor grayColor];
        [self addSubview:self.titleView];
        
        [self.titleView.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self channelsViewDoLoadWithFrame:frame];
        
        self.editable = NO;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andVC:(NewsVC *)newsVC {
    self.newsVC = newsVC;
    self = [self initWithFrame:frame];
    
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
    self.unsubscribChannelWarnLabel.backgroundColor = kDefaultColor;
    self.unsubscribChannelWarnLabel.text = NSLocalizedString(@"点击添加频道", nil);
    [self.channelsView addSubview:self.unsubscribChannelWarnLabel];
    
    heightOffset += self.unsubscribChannelWarnLabel.frame.size.height;
    self.unsubscribeChannelsView = [[UnsubscribeChannelsView alloc] initWithFrame:CGRectMake(0, heightOffset, frame.size.width, kChannelsViewTitleViewHeight)];
    [self constructUnsubscribeChannels];
    [self.channelsView addSubview:self.unsubscribeChannelsView];
    
    self.channelsView.contentSize = CGSizeMake(frame.size.width, self.subscribeChannelsView.frame.size.height+kChannelsViewTitleViewHeight + self.unsubscribeChannelsView.frame.size.height);
}

- (ChannelsButton *)constructChannelButtonWithTitle:(NSString *)text frame:(CGRect)frame {
    ChannelsButton *button = (ChannelsButton *)[ViewConstructor constructDefaultButton:[ChannelsButton class] withFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
//    button.imageView.layer.borderColor
    button.imageView.layer.borderWidth = 1.0f;
    button.clipsToBounds = NO;
    
    return button;
}

- (void)constructSubscribeChannels {
    CGFloat padding = 15;
    CGFloat height = 30;
    CGFloat width = (self.frame.size.width-15*5)/4;
    CGFloat x = padding;
    CGFloat y = padding;
    CGRect frame;
    
    NSArray *subscribeSegments = [self.newsVC subscribeNewsSegments];
    NewsSegmentModel *segment = nil;
    for(NSInteger i=0; i<subscribeSegments.count; i++) {
        x = padding*((i%4)+1) + (i%4)*width;
        y = padding*((i/4)+1) + (i/4)*height;
        frame = CGRectMake(x, y, width, height);
        segment = [subscribeSegments objectAtIndex:i];
        
        NewsChannelMode *channel = [[NewsChannelMode alloc] init];
        channel.title = segment.title;
        channel.segment = segment;
        ChannelsButton *button = [self constructChannelButtonWithTitle:segment.title frame:frame];
        [button addTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeChannelsView addSubview:button];
        channel.channelView = button;
        [self.subscribeChannelsView.channels addObject:channel];
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
    
    NSArray *unsubscribeSegments = [self.newsVC unsubscribeNewsSegments];
    NewsSegmentModel *segment = nil;
    for(NSInteger i=0; i<unsubscribeSegments.count; i++) {
        x = padding*((i%4)+1) + (i%4)*width;
        y = padding*((i/4)+1) + (i/4)*height;
        frame = CGRectMake(x, y, width, height);
        
        segment = [unsubscribeSegments objectAtIndex:i];
        NewsChannelMode *channel = [[NewsChannelMode alloc] init];
        channel.title = segment.title;
        channel.segment = segment;
        UIButton *button = [self constructChannelButtonWithTitle:segment.title frame:frame];
        [button addTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.unsubscribeChannelsView addSubview:button];
        channel.channelView = button;

        [self.unsubscribeChannelsView.channels addObject:channel];
    }
    
    frame = self.unsubscribeChannelsView.frame;
    frame.origin.y = self.subscribeChannelsView.frame.size.height + kChannelsViewTitleViewHeight;
    frame.size.height = y+padding+width;
    self.unsubscribeChannelsView.frame = frame;
}

- (void)clickEditButton:(UIButton *)button {
    self.editable = !self.editable;
    if(self.editable/*[button.titleLabel.text isEqualToString:NSLocalizedString(@"编辑", nil)]*/) {
        [button setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        self.subscribeChannelsView.hideDeleteView = NO;
        [self.subscribeChannelsView reloadData];
    }
    else {
        [button setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
        [self.newsVC commitChennelsForSubscribeAndUnSubscribe];
//        self.subscribeChannelsView.hideDeleteView = YES;
//        [self.subscribeChannelsView reloadData];
        [ChangeVCController popViewControllerByNavigationController:self.belongVC.navigationController];
    }
}

- (void)clickUnsubscribeChannel:(UIButton *)button {
    if(!self.editable) {
        NewsChannelMode *channel = [self channelForChannelView:button withChannels:self.subscribeChannelsView.channels];
        [self.newsVC selected:channel.segment];
        [ChangeVCController popViewControllerByNavigationController:self.belongVC.navigationController];
        return;
    }
    NewsChannelMode *channel = [self channelForChannelView:button withChannels:self.subscribeChannelsView.channels];
    channel.segment.newsSubscribeMode = kNewsSegmentSubscribeModeUnSubscribe;
    [button removeTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [button removeFromSuperview];
    [self.subscribeChannelsView.channels removeObject:channel];
    
    [button addTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.unsubscribeChannelsView addSubview:button];
    [self.unsubscribeChannelsView.channels insertObject:channel atIndex:0];
    [self reloadData];
}

- (void)clickSubscribeChannel:(UIButton *)button {
    NewsChannelMode *channel = [self channelForChannelView:button withChannels:self.unsubscribeChannelsView.channels];

    if(!self.editable) {
        SingleChannelNewsVC *vc = [[SingleChannelNewsVC alloc] init];
        vc.newsType = channel.segment.titleItem;
        [ChangeVCController pushViewControllerByNavigationController:self.belongVC.navigationController pushVC:vc];
        return;
    }
    channel.segment.newsSubscribeMode = kNewsSegmentSubscribeModeSubscribe;

    [button removeTarget:self action:@selector(clickSubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [button removeFromSuperview];
    [self.unsubscribeChannelsView.channels removeObject:channel];
    
    [button addTarget:self action:@selector(clickUnsubscribeChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.subscribeChannelsView addSubview:channel.channelView];
    [self.subscribeChannelsView.channels addObject:channel];
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

- (NewsChannelMode *)channelForChannelView:(id)channelView withChannels:(NSArray *)channels {
    for(NewsChannelMode *channel in channels) {
        if(channel.channelView == channelView)
            return channel;
    }
    
    return nil;
}
@end
