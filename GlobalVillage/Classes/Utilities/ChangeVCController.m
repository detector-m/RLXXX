//
//  ChangeVCController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChangeVCController.h"
#import "RLBaseNavigationController.h"

@implementation ChangeVCController
+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc animated:(BOOL)animated {
    [nav pushViewController:vc animated:animated];
}

+ (void)pushViewControllerByNavigationController:(UINavigationController *)nav pushVC:(UIViewController *)vc {
    [nav pushViewController:vc animated:YES];
}

+ (void)pushViewControllerByNavigationControllerFromRootViewController:(UINavigationController *)nav pushVC:(UIViewController *)vc animated:(BOOL)animated {
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:animated];
}
+ (void)pushViewControllerByNavigationControllerFromRootViewController:(UINavigationController *)nav pushVC:(UIViewController *)vc {
    [self pushViewControllerByNavigationControllerFromRootViewController:nav pushVC:vc animated:YES];
}

+ (void)popViewControllerByNavigationController:(UINavigationController *)nav animated:(BOOL)animated {
    [nav popViewControllerAnimated:animated];
}
+ (void)popViewControllerByNavigationController:(UINavigationController *)nav {
    [nav popViewControllerAnimated:YES];
}

+ (void)changeRootViewController:(UIViewController *)vc {
//    UIWindow *windown = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    UIWindow *windown = [UIApplication sharedApplication].keyWindow;
    if(vc == nil || windown.rootViewController == vc)
        return;
    
    CGPoint currentCenter;
    UIViewController *currentVC = windown.rootViewController;
    currentCenter = currentVC.view.center;
    
    vc.view.center = CGPointMake(currentCenter.x, currentCenter.y-vc.view.frame.size.height);
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        currentVC.view.center = CGPointMake(currentCenter.x, currentCenter.y+vc.view.frame.size.height);
        vc.view.center = currentCenter;
        
    } completion:^(BOOL finished) {
//        for(UIViewController *vc in windown.rootViewController.childViewControllers) {
//            [vc removeFromParentViewController];
//        }
        [windown setRootViewController:vc];
    }];
}

+ (void)changeNavigationRootViewController:(UIViewController *)vc {
    RLBaseNavigationController *nav = [[RLBaseNavigationController alloc] initWithRootViewController:vc];
    
    [ChangeVCController changeRootViewController:nav];
}

+ (void)changeMainRootViewController:(Class)vcClass {
    UIViewController *vc = [[vcClass alloc] init];
    [self changeNavigationRootViewController:vc];
}
@end
