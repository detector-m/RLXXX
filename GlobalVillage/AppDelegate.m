//
//  AppDelegate.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/16.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "AppDelegate.h"
#import "RLBaseNavigationController.h"
#import "NormalLoginVC.h"
#import "NewsVC.h"

#import "RLLocationManager.h"
#import "RLSocialShareKit.h"

#import "TestViewController.h"

@interface AppDelegate ()
@property (nonatomic, readwrite, strong) RLLocationManager *locationManager;

@end

@implementation AppDelegate

- (void)setupWindow {
    [UIViewController setupFix];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)setupRootViewController {
    if(self.window == nil) {
        NSAssert(self.window == nil, @"window 未初始化");
        return;
    }
//    NormalLoginVC *vc = [[NormalLoginVC alloc] init];
    NewsVC *vc = [[NewsVC alloc] init];
//    TestViewController *vc = [[TestViewController alloc] init];
    RLBaseNavigationController *nav = [[RLBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)startLocationManager {
    if(self.locationManager == nil) {
        self.locationManager = [[RLLocationManager alloc] init];
        self.locationManager.location = [User sharedUser].location;
    }
}

//- (void)test {
//    self.shareKit = [[RLSocialShareKit alloc] init];
//    [self.shareKit registerAppWithType:2];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self startLocationManager];
    
    [self setupWindow];
    [self setupRootViewController];
    
//    [self test];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[RLSocialShareKit sharedShareKit] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[RLSocialShareKit sharedShareKit] handleOpenURL:url];
}

+ (void)changeRootViewController:(UIViewController *)vc {
    UIWindow *windown = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    if(vc == nil || windown.rootViewController == vc)
        return;
    
//    [[ReachabilityCtrl shared] removeAll];
    
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
@end
