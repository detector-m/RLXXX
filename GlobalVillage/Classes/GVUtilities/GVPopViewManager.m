//
//  GVPopViewManager.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "GVPopViewManager.h"
#import "URBAlertView.h"
#import "DejalActivityView.h"

@implementation GVPopViewManager
+ (void)showDialogWithTitle:(NSString *)title subtitle:(NSString *)subtitle andButtonTitle:(NSString *)btnTitle {
    dispatch_block_t block = ^(){
        URBAlertView *alertView = [URBAlertView dialogWithTitle:title subtitle:subtitle];
        alertView.blurBackground = NO;
        [alertView addButtonWithTitle:btnTitle];
        [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *theAlertView) {
            [theAlertView hideWithCompletionBlock:^{
            }];
        }];
        
        [alertView showWithAnimation:URBAlertAnimationDefault];
    };
    
    dispatch_async(dispatch_get_main_queue(), block);


}
+ (void)showDialogWithTitle:(NSString *)title {
    [self showDialogWithTitle:title subtitle:nil andButtonTitle:NSLocalizedString(@"确定", nil)];
}

static DejalActivityView *activityView = nil;
+ (void)showActivityWithTitle:(NSString *)title {
    dispatch_block_t block = ^(){
        [DejalBezelActivityView removeView];
        activityView = nil;

//        activityView = [DejalActivityView activityViewForView:[UIApplication sharedApplication].keyWindow withLabel:title];
        UIView *view = ((UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers.lastObject).view;
        activityView = [DejalBezelActivityView activityViewForView:view withLabel:title];
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
//    activityView.showNetworkActivityIndicator = YES;
}
+ (void)showActivity {
    dispatch_block_t block = ^(){
        [DejalBezelActivityView removeView];
        activityView = nil;

//        activityView = [DejalActivityView activityViewForView:[UIApplication sharedApplication].keyWindow];
        UIView *view = ((UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers.lastObject).view;
        activityView = [DejalBezelActivityView activityViewForView:view];

        //    activityView.showNetworkActivityIndicator = YES;
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)showActivityWithTitle:(NSString *)title forView:(UIView *)view {
    dispatch_block_t block = ^(){
        [DejalBezelActivityView removeView];
        activityView = nil;
        activityView = [DejalBezelActivityView activityViewForView:view withLabel:title];
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
}
+ (void)showActivityForView:(UIView *)view {
    dispatch_block_t block = ^(){
        [DejalBezelActivityView removeView];
        activityView = nil;
        
        activityView = [DejalBezelActivityView activityViewForView:view];
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)removeActivity {
    dispatch_block_t block = ^(){
        [DejalActivityView removeView];
        activityView = nil;
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
}
@end
