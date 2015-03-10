//
//  AddFriendController.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "AddFriendController.h"

@implementation AddFriendController
+ (void)requestWithType:(RequestType)type andSubtag:(NSInteger)subtag parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:subtag parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

- (void)nearbyPersonRequest:(NSString *)accessToken longitude:(double)longitude latitude:(double)latitude radius:(NSInteger)radius pageCount:(NSInteger)pageCount currentCount:(NSInteger)currentCount {
    NSMutableDictionary *parameters = [GVRequestParameterManager nearbyPersonParameter:[RLTypecast doubleToString:longitude] latitudeValue:[RLTypecast doubleToString:latitude] radiusValue:[RLTypecast integerToString:radius] pageSizeValue:[RLTypecast integerToString:pageCount] currentPageValue:[RLTypecast integerToString:currentCount] accessTokenValue:accessToken];
    if(!parameters)
    {
        DLog(@"nearbyPersonDic error!");
        NSAssert(parameters !=nil, @"nearbyPersonDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeNearbyPerson andSubtag:0 parameters:parameters andDelegate:self];
}


#pragma mark - RLRequestDelegate
- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {
    DLog(@"%@", error);
    [GVPopViewManager removeActivity];
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
    
    dispatch_block_t block = NULL;
    block = ^() {
        [GVPopViewManager showDialogWithTitle:@"网络有问题"];
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)request:(RLRequest *)request
        didLoad:(id)result {
    [GVPopViewManager removeActivity];
    
    [self responseWithType:request.tag subtag:request.subTag result:result];
    
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
}

- (void)responseWithType:(RequestType)type subtag:(NSInteger)subtag result:(id)result {
    if(self.delegate == nil)
        return;
    
    /*__unused */
    GVResponse *response = [[self class] responseWithReqeustResponseData:result];
    
    id<AddFriendControllerDelegate> delegate = (id<AddFriendControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeNearbyPerson:
            DLog(@"%@", result);
            response.responseData = result;
//            response.responseData = [self parseNewsTypeListResponse:response];
//            
            if([delegate respondsToSelector:@selector(nearbyPersonResponse:)]) {
                [delegate nearbyPersonResponse:response];
            }
            break;
        default:
            break;
    }
}

@end
