//
//  ModuleController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVResponseManager.h"

#import "GVPopViewManager.h"

#import "NSString+Regex.h"
#import "RLTypecast.h"

@protocol ModuleControllerDelegate <NSObject>
@optional
//- (void)request:(RLRequest *)request
// didLoadSuccess:(id)result;

//- (void)request:(RLRequest *)request
//  didLoadFailed:(id)result;
@end

@interface ModuleController : NSObject <RLRequestDelegate>
@property (nonatomic, readwrite, weak) id<ModuleControllerDelegate>delegate;

+ (GVResponse *)responseWithReqeustResponseData:(id)responseData;

- (NSDictionary *)constructResponseErrorWithResponse:(GVResponse *)response;
- (void)removeAllRequest;

@end
