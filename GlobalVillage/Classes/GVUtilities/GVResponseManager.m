//
//  GVResponseManager.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "GVResponseManager.h"
#import "RespondFieldMacro.h"

@implementation GVResponseManager
+ (RLResponse *)responseWithReqeustResponseData:(id)responseData withContentKey:(NSString *)contentKey {
    if(responseData == nil)
        return nil;
    
    RLResponse *response = [[RLResponse alloc] init];
    if([responseData isKindOfClass:[NSString class]]) {
//        response.responseObject = responseData;
    }
    else if([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = responseData;
        response.status = [[dic objectForKey:RespondFieldStatusKey] integerValue];
        response.message = [dic objectForKey:RespondFieldMessageKey];
//        response.responseObject = [dic objectForKey:contentKey];
    }
    else {
//        response.responseObject = responseData;
    }
    
    return response;
}

@end
