//
//  MainVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MainVC.h"

#import "NewsVC.h"
#import "SocialContactVC.h"
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
    newsVC.tabBarItem.title = NSLocalizedString(@"玩转地球", nil);
    [newsVC.tabBarItem setImage:[UIImage imageNamed:@"News.png"]];
    
    SocialContactVC *socialContactVC = [[SocialContactVC alloc] init];
    socialContactVC.tabBarItem.title = NSLocalizedString(@"社交", nil);
    [socialContactVC.tabBarItem setImage:[UIImage imageNamed:@"Mine.png"]];
    
    MineVC *mineVC = [[MineVC alloc] init];
    mineVC.tabBarItem.title = NSLocalizedString(@"我的", nil);
    [mineVC.tabBarItem setImage:[UIImage imageNamed:@"Mine.png"]];
    
    self.viewControllers = [NSArray arrayWithObjects:newsVC, socialContactVC, mineVC, nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    tabBarController.navigationItem.title = viewController.tabBarItem.title;
}
@end
