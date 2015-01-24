//
//  ChangeVCController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChangeVCController.h"

@implementation ChangeVCController
+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc animated:(BOOL)animated {
    [nav pushViewController:vc animated:animated];
}

+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc {
    [nav pushViewController:vc animated:YES];
}

+ (void)popViewControllerByNavigationController:(UINavigationController *)nav animated:(BOOL)animated {
    [nav popViewControllerAnimated:animated];
}
+ (void)popViewControllerByNavigationController:(UINavigationController *)nav {
    [nav popViewControllerAnimated:YES];
}
@end
