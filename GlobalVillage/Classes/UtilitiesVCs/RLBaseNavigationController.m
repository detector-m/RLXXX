//
//  RLBaseNavigationController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseNavigationController.h"

@interface RLBaseNavigationController ()

@end

@implementation RLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)setNavigationBarHeight {
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat height = frame.size.height+30;
    CGFloat heightOld = frame.size.height;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    [self.navigationController.navigationBar setFrame:frame];
    
    UIView* navBarTransitionView = [self.navigationController.view.subviews objectAtIndex:0];
    frame = navBarTransitionView.frame;
    navBarTransitionView.frame = CGRectMake(frame.origin.x, frame.origin.y-(height-heightOld), frame.size.width, frame.size.height+(height-heightOld));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
