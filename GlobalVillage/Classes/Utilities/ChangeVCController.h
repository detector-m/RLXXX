//
//  ChangeVCController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeVCController : NSObject
+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc animated:(BOOL)animated;
+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc;

+ (void)popViewControllerByNavigationController:(UINavigationController *)nav animated:(BOOL)animated;
+ (void)popViewControllerByNavigationController:(UINavigationController *)nav;
@end
