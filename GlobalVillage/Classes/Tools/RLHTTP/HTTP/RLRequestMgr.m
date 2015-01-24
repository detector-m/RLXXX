//
//  RLRequestMgr.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRequestMgr.h"

static RLRequestMgr *_requestMgr = nil;

@interface RLRequestMgr ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *requestDictionary;
@end

@implementation RLRequestMgr

- (void)dealloc {
    //    [self cancelAllRequest];
    [self removeEveryRequest];
    [_requestDictionary removeAllObjects];
    //    [_requestArray removeAllObjects], _requestArray = nil;
}

+ (RLRequestMgr *)shared {
    @synchronized(self) {
        if(_requestMgr == nil) {
            _requestMgr = [[RLRequestMgr alloc] init];
        }
        
        return _requestMgr;
    }
}

+ (void)showStatusActivityIndicator {
    [self cancelPreviousPerformRequestsWithTarget:[RLRequestMgr shared] selector:@selector(hideStatusActivityIndicatorInstance) object:nil];
    [[RLRequestMgr shared] performSelector:@selector(hideStatusActivityIndicatorInstance) withObject:nil afterDelay:120.0f];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)hideStatusActivityIndicator {
    [self cancelPreviousPerformRequestsWithTarget:[RLRequestMgr shared] selector:@selector(hideStatusActivityIndicatorInstance) object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)hideStatusActivityIndicatorInstance {
    [self.class hideStatusActivityIndicator];
}

- (void)addRequestForKey:(NSString *)key request:(RLRequest *)request {
    if(request == nil || key == nil)
        return;
    if(_requestDictionary == nil) {
        _requestDictionary = [NSMutableDictionary dictionary];
    }
    
    if([[_requestDictionary allKeys] containsObject:key]) {
        [[_requestDictionary objectForKey:key] addObject:request];
    }
    else {
        NSMutableArray *tempA = [NSMutableArray arrayWithObject:request];
        [_requestDictionary setObject:tempA forKey:key];
    }
}

- (void)hideStatusActivityIndicatorInstanceByReqeustCount {
    if(_requestDictionary.count == 0) {
        [self hideStatusActivityIndicatorInstance];
        return;
    }
    
    BOOL isHide = YES;

    for(NSString *key in [_requestDictionary allKeys]) {
        NSArray *array = [_requestDictionary objectForKey:key];
        if(array.count) {
            isHide = NO;
            return;
        }
    }
    
    if(isHide) {
        [self hideStatusActivityIndicatorInstance];
    }
}

- (void)cancelRequest:(RLRequest *)request {
    [request.connection cancel];
    request.delegate = nil;
}

- (void)removeRequestForKey:(NSString *)key request:(RLRequest *)request {
    if(request == nil || key == nil)
        return;
    if([[_requestDictionary allKeys] containsObject:key]) {
        [self cancelRequest:request];
        [[_requestDictionary objectForKey:key] removeObject:request];
    }
    
    [self hideStatusActivityIndicatorInstanceByReqeustCount];
}

- (void)removeRequestForKey:(NSString *)key withTag:(NSInteger)tag {
    if(key == nil)
        return;
    
    NSArray *array = [_requestDictionary objectForKey:key];
    NSMutableArray *subArray = [NSMutableArray array];
    for(RLRequest *request in array) {
        if(request.tag == tag) {
            [subArray addObject:request];
        }
    }
    
    for(RLRequest *request in subArray) {
        [self removeRequestForKey:key request:request];
    }
    
    subArray = nil;
}

- (void)removeRequestForKey:(NSString *)key withTag:(NSInteger)tag andSubTag:(UInt8)subTag {
    if(key == nil)
        return;
    
    NSArray *array = [_requestDictionary objectForKey:key];
    for(RLRequest *request in array) {
        if(request.tag == tag && request.subTag == subTag) {
            [self removeRequestForKey:key request:request];
            return;
        }
    }
}

- (void)removeAllRequestForKey:(NSString *)key {
    if(key == nil)
        return;
    
    if([[_requestDictionary allKeys] containsObject:key]) {
        NSMutableArray *array = [_requestDictionary objectForKey:key];
        for(RLRequest *request in array) {
            [self cancelRequest:request];
        }
        
        [array removeAllObjects];
        [_requestDictionary removeObjectForKey:key];
    }
    
    [self hideStatusActivityIndicatorInstanceByReqeustCount];
}

- (void)removeEveryRequest {
    [self.class hideStatusActivityIndicator];
    
    for(NSString *key in [_requestDictionary allKeys]) {
        NSMutableArray *array = [_requestDictionary objectForKey:key];
        for(RLRequest *request in array) {
            [self cancelRequest:request];
        }
        
        [array removeAllObjects];
    }
    
    [_requestDictionary removeAllObjects];
    [self hideStatusActivityIndicatorInstanceByReqeustCount];
}

- (RLRequest *)requestForKey:(NSString *)key withTag:(NSInteger)tag andSubTag:(UInt8)subTag {
    if(key == nil || key.length == 0 || tag < 0 || subTag < 0)
        return nil;
    NSArray *array = [_requestDictionary objectForKey:key];
    if(array == nil)
        return nil;
    
    for(RLRequest *temp in array) {
        if(temp.tag == tag && temp.subTag == subTag)
            return temp;
    }
    
    return nil;
}
@end