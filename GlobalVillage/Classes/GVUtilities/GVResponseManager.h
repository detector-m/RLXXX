//
//  GVResponseManager.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVRequestManager.h"
#import "GVResponse.h"

@interface GVResponseManager : NSObject
+ (RLResponse *)responseWithReqeustResponseData:(id)responseData withContentKey:(NSString *)contentKey;
@end
