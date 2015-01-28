//
//  GVPopViewManager.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVPopViewManager : NSObject
+ (void)showDialogWithTitle:(NSString *)title subtitle:(NSString *)subtitle andButtonTitle:(NSString *)btnTitle;
+ (void)showDialogWithTitle:(NSString *)title;

+ (void)showActivityWithTitle:(NSString *)title;
+ (void)showActivity;
+ (void)removeActivity;
@end
