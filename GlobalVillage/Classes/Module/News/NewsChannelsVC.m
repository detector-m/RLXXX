//
//  NewsChannelsVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsChannelsVC.h"

@interface NewsChannelsVC ()
@property (nonatomic, readwrite, strong) NewsChannelsView *channelsView;
@end

@implementation NewsChannelsVC

- (BOOL)navigationShouldPopOnBackButton {
    return [super navigationShouldPopOnBackButton];
}
- (void)navigationDidPopOnBackButton {
    [super navigationDidPopOnBackButton];
}

- (void)dealloc {
    self.channelsView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我的频道", nil);
    
    [self channelsViewDoLoad];
}

- (void)channelsViewDoLoad {
    if(self.channelsView) {
        return;
    }
    CGRect frame = self.view.frame;
    self.channelsView = [[NewsChannelsView alloc] initWithFrame:frame andVC:self.newsVC];
    self.channelsView.belongVC = self;
    [self.view addSubview:self.channelsView];
}

@end
