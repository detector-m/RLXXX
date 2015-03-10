//
//  RLTabBarController.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTabBarController.h"

@interface RLTabBarController ()

@end

@implementation RLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self screenFixView];
    [self setBarBackItem];
    [self setupForDismissKeyboard];
}

@end
