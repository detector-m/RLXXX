//
//  MainVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MainVC.h"

#import "NewsVC.h"
#import "MineVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subVCsDoLoad];
}

- (void)subVCsDoLoad {
    NewsVC *newsVC = [[NewsVC alloc] init];
    newsVC.tabBarItem.title = NSLocalizedString(@"地球村新闻", nil);
    [newsVC.tabBarItem setImage:[UIImage imageNamed:@"News.png"]];
    
    MineVC *mineVC = [[MineVC alloc] init];
    mineVC.tabBarItem.title = NSLocalizedString(@"我的", nil);
    [mineVC.tabBarItem setImage:[UIImage imageNamed:@"Mine.png"]];
    
    self.viewControllers = [NSArray arrayWithObjects:newsVC, mineVC, nil];
}
@end
