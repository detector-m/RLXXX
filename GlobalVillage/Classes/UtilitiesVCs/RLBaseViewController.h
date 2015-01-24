//
//  RLBaseViewController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Expand.h"
#import "UIView+Regulator.h"
#import "GVPopViewManager.h"

@class ModuleController;
@interface RLBaseViewController : UIViewController
//@property (nonatomic, readonly, strong) ModuleController *controller;
- (void)mainThreadAsync:(dispatch_block_t)dispatchBlock;
- (void)endEditing;

- (BOOL)navigationShouldPopOnBackButton;
@end
