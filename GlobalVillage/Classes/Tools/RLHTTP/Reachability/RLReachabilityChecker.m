//
//  ReachabilityCtrl.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/10.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "RLReachabilityChecker.h"

#define DefaultBannaerHeight 36.0f
#define AnimationDuration 0.5f
#define RBViewShowTime  2.0f

static Reachability *_reachability = nil;
BOOL _reachabilityOn;

static inline Reachability *defaultReachability () {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
        
#if !__has_feature(objc_arc)
        [_reachability retain];
#endif
    });
    
    return _reachability;
}

#pragma makr - Ctrl 开始
@interface RLReachabilityChecker ()
@property (nonatomic, readwrite, assign) BOOL isReachability;
@end

static BOOL _sIsReachablility = NO;
static RLReachabilityChecker *_reachabilityCtrl = nil;
@implementation RLReachabilityChecker


+ (BOOL)isReachability {
    
    NetworkStatus internetStatus = [self networkStatus];
    switch (internetStatus) {
        case NotReachable:
            _sIsReachablility = NO;
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            _sIsReachablility = YES;
            break;
    }

    return _sIsReachablility;
}

+ (NetworkStatus)networkStatus {

    [defaultReachability() startNotifier];

    return [defaultReachability() currentReachabilityStatus];
}

+ (RLReachabilityChecker *)shared {
//    @synchronized (self) {
//        
//    }
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _reachabilityCtrl = [[self alloc] init];
    });
    
    return _reachabilityCtrl;
}

- (void)dealloc {
    [self stopInternetReachability];
    [self cancel];
    [self onDealloc];
}

- (id)init {
    if(self=[super init]) {
        _isReachability = YES;
        
//        [self startInternetReachability];
    }
    
    return self;
}

- (void)startInternetReachability {
    if(!_reachabilityOn) {
        _reachabilityOn = true;
        [defaultReachability() startNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self checkNetworkStatus];
}

- (void)checkNetworkStatus {
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable:
            self.isReachability = NO;
            [self cancel];
//            [self performSelector:@selector(showBannerView) withObject:nil afterDelay:0.1];
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            self.isReachability = YES;
            [self cancel];
//            [self performSelector:@selector(showBannerView) withObject:nil afterDelay:0.1];
            
//            [self performSelector:@selector(hideBannerView) withObject:nil afterDelay:0.1];
            break;
    }
}

- (void)onDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancel];
}

- (void)cancel {

}

- (void)stopInternetReachability {
    _reachabilityOn = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
