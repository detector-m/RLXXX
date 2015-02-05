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
    
//    [self.navigationBar setBarStyle:UIBarStyleBlack];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:47/255.0 green:125/255.0 blue:176/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:194/255.0 green:18/255.0 blue:40/255.0 alpha:0.9]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // set title color and font
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,
        [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
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

//Getting interactivePopGestureRecognizer dismiss callback/event
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"7: %i", [context isCancelled]);
    }];
}

@end
