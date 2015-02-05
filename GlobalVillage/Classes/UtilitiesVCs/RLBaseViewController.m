//
//  RLBaseViewController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import "ModuleController.h"
#import <objc/runtime.h>

@interface RLBaseViewController ()

@end

@implementation RLBaseViewController

- (BOOL)navigationShouldPopOnBackButton {
//    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (void)navigationDidPopOnBackButton {
//    [ModuleController removeAllRequest];

    [GVPopViewManager removeActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UINavigationBar *navigationBar = [[self navigationController] navigationBar];
//    CGRect frame = [navigationBar frame];
//    frame.size.height = 82.0f;
//    [navigationBar setFrame:frame];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    BOOL isInteractivePop = self.navigationController.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan;
    if(isInteractivePop) {
        [GVPopViewManager removeActivity];
        [self navigationShouldPopOnBackButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self screenFixView];
    [self setBarBackItem];
    [self setupForDismissKeyboard];
}

- (void)mainThreadAsync:(dispatch_block_t)dispatchBlock {
    if(dispatchBlock == NULL) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), dispatchBlock);
}

- (void)endEditing {
    [self.view endEditing:YES];
}

//- (void)test {
//    //    id d = [self valueForKey:@"controller"];
//    unsigned int numIvars; //成员变量个数
//    Ivar *vars = class_copyIvarList(self.class, &numIvars);
//    //Ivar *vars = class_copyIvarList([UIView class], &numIvars);
//    
//    NSString *key=nil;
//    for(int i = 0; i < numIvars; i++) {
//        
//        Ivar thisIvar = vars[i];
//        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
//        NSLog(@"variable name :%@", key);
//        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
//        NSLog(@"variable type :%@", key);
//    }
//    free(vars);
//    
//    if([self respondsToSelector:@selector(controller)]) {
//        
//    }
//
//}

@end
