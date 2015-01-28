//
//  RLRequestMgr.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLRequest.h"

@interface RLRequestMgr : NSObject
+ (RLRequestMgr *)shared;
+ (void)showStatusActivityIndicator;
+ (void)hideStatusActivityIndicator;

- (void)addRequestForKey:(NSString *)key request:(RLRequest *)request;
- (void)removeRequestForKey:(NSString *)key request:(RLRequest *)request;
- (void)removeRequestForKey:(NSString *)key withTag:(NSInteger)tag;
- (void)removeRequestForKey:(NSString *)key withTag:(NSInteger)tag andSubTag:(UInt8)subTag;
- (void)removeAllRequestForKey:(NSString *)key;
- (void)removeEveryRequest;

- (RLRequest *)requestForKey:(NSString *)key withTag:(NSInteger)tag andSubTag:(UInt8)subTag;
@end
