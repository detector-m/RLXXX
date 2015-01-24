//
//  ReachabilityCtrl.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/10.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface RLReachabilityChecker : NSObject
//是否联网
@property (nonatomic, readonly, assign) BOOL isReachability;

+ (BOOL)isReachability;
+ (NetworkStatus)networkStatus;
+ (RLReachabilityChecker *)shared;

- (void)startInternetReachability;
@end
