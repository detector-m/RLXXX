//
//  RLActivityShare.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLActivityShare.h"

@implementation RLActivityShare
- (void)dealloc {
    self.showItems = nil;
    self.appActivities = nil;
    
    self.completionHandler = nil;
}

- (void)showActivityViewController {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:self.showItems applicationActivities:self.appActivities];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAirDrop];
    
    // 写一个bolck，用于completionHandler的初始化
    //    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType, BOOL completed) {
    //        NSLog(@"%@", activityType);
    //        if (completed) {
    //            NSLog(@"completed");
    //        } else
    //        {
    //            NSLog(@"cancled");
    //        }
    //        [activityVC dismissViewControllerAnimated:YES completion:Nil];
    //    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    if([activityVC respondsToSelector:@selector(completionWithItemsHandler)]) {
//        activityVC.completionWithItemsHandler = self.completionHandler;
        activityVC.completionHandler = self.completionHandler;
    }
    else {
        activityVC.completionHandler = self.completionHandler;
    }
    
    // 以模态方式展现出UIActivityViewController
    [self.showVC presentViewController:activityVC animated:YES completion:Nil];
}

@end
