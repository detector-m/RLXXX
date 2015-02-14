//
//  RegisterController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RegisterController.h"

@implementation RegisterController
+ (void)requestWithType:(RequestType)type parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:0 parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

- (void)verifyPhoneNumberRequest:(NSString *)phoneNumber {
    NSMutableDictionary *parameters = [GVRequestParameterManager verifyPhoneNumParameter:phoneNumber];
    if(!parameters) {
        DLog(@"veriftyPhoneNumDic error!");
        NSAssert(parameters !=nil, @"veriftyPhoneNumDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeVerifyPhoneNum parameters:parameters andDelegate:self];
}

//获取手机验证码
- (void)mobileAuthCodeRequest:(NSString *)phoneNumber appId:(NSString *)appId {
    NSMutableDictionary *parameters = [GVRequestParameterManager mobileAuthCodeParameter:phoneNumber appId:appId];
    if(!parameters) {
        DLog(@"mobileAuthCodeDic error!");
        NSAssert(parameters !=nil, @"mobileAuthCodeDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeMobileAuthCode parameters:parameters andDelegate:self];
}

//手机验证码验证
- (void)verifyMobileAuthCodeRequest:(NSString *)authCode withPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *parameters = [GVRequestParameterManager verifyMobileAuthCodeParameter:phoneNumber authCode:authCode];
    if(parameters == nil)
        NSAssert(parameters !=nil, @"verifyMobileAuthCodeDic error!");
    
    [[self class] requestWithType:kRequestTypeVerifyMobileAuthCode parameters:parameters andDelegate:self];
}

//获取地球号 chargeType-> 1 收费  0免费
- (void)dqNumberList:(NSInteger)chargeType andCount:(NSInteger)count {
    NSMutableDictionary *parameters = [GVRequestParameterManager getChikyugosParameter:[RLTypecast integerToString:chargeType] count:[RLTypecast integerToString:count]];
    if(!parameters) {
        DLog(@"mobileAuthCodeDic error!");
        NSAssert(parameters !=nil, @"mobileAuthCodeDic error!");
    }
    
    RequestType requestType = chargeType ? kRequestTypeChargeDQNumberList : kRequestTypeFreeDQNumberList;
    [[self class] requestWithType:requestType parameters:parameters andDelegate:self];
}

//地球号是否使用
- (void)verifyDQNumber:(NSString *)dqNumber {
    NSMutableDictionary *parameters= [GVRequestParameterManager verifyChikyugoParameter:dqNumber];
    if(parameters == nil) {
        DLog(@"verifyChikyugoDic error!");
        NSAssert(parameters !=nil, @"verifyChikyugoDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeVerifyDQNumber parameters:parameters andDelegate:self];
}

//用户注册功能
- (void)requestRegist:(NSString *)dqNumber phoneNumber:(NSString *)phoneNumber password:(NSString *)password gender:(NSInteger)gender nickname:(NSString *)nickname location:(UserLocation *)location headPortrait:(NSString *)headPortrait {
    
    NSMutableDictionary *parameters = [GVRequestParameterManager registParameter:nickname chikyugoValue:dqNumber thirdidValue:nil passwordValue:password mobileNumValue:phoneNumber sexValue:[RLTypecast integerToString:gender] cityValue:location.city longitudeValue:[RLTypecast doubleToString:location.longitude] latitudeValue:[RLTypecast doubleToString:location.latitude] headPortraitValue:headPortrait];
    
    if(!parameters) {
        DLog(@"mobileAuthCodeDic error!");
        NSAssert(parameters !=nil, @"mobileAuthCodeDic error!");
    }

    [[self class] requestWithType:kRequestTypeRegister parameters:parameters andDelegate:self];
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
    [self responseWithType:request.tag result:result];
    
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
}

- (void)responseWithType:(RequestType)type result:(id)result {
    if(self.delegate == nil)
        return;
    
    GVResponse *response = [[self class] responseWithReqeustResponseData:result];

    id<RegisterControllerDelegate> delegate = (id<RegisterControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeVerifyPhoneNum: {
            response.responseData = result;
            if([delegate respondsToSelector:@selector(verifyPhoneNumberResponse:)]) {
                [delegate verifyPhoneNumberResponse:response];
            }
        }
            break;
        case kRequestTypeMobileAuthCode:
            break;
        case kRequestTypeVerifyMobileAuthCode:
            if([delegate respondsToSelector:@selector(verifyMobileAuthCodeResponse:)]) {
                [delegate verifyMobileAuthCodeResponse:response];
            }
            break;
            
        case kRequestTypeFreeDQNumberList:
            
            response.responseData = [self parseDQNumberListResponseData:result];
            if([delegate respondsToSelector:@selector(freeDQNumberListResponse:)]) {
                [delegate freeDQNumberListResponse:response];
            }
            break;
        case kRequestTypeChargeDQNumberList:
            if([delegate respondsToSelector:@selector(chargeDQNumberListResponse:)]) {
                [delegate chargeDQNumberListResponse:response];
            }
            break;
        case kRequestTypeVerifyDQNumber:
            if([delegate respondsToSelector:@selector(verifyDQNumberResponse:)]) {
                [delegate verifyDQNumberResponse:response];
            }
            break;
        case kRequestTypeRegister:
            response.responseData = result;
            response.responseData = [self parseRegisterResponseData:result];
            if([delegate respondsToSelector:@selector(registerResponse:)]) {
                [delegate registerResponse:response];
            }
            break;
            
        default:
            break;
    }
}

- (id)responseDataForKey:(NSString *)key result:(id)result {
    if(result == nil || ![result isKindOfClass:[NSDictionary class]])
        return nil;
    
    if(key == nil || key.length == 0) {
        NSAssert(key != nil, @"responseDataForKey key is nil");
    }
    
    NSDictionary *dicResult = (NSDictionary *)result;
    
    return [dicResult objectForKey:key];
}

- (NSArray *)parseDQNumberListResponseData:(id)result {
    if(result == nil || ![result isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSDictionary *dicResult = (NSDictionary *)result;
    NSArray *arrayResult = [dicResult objectForKey:RespondFieldListKey] ;
//    NSLog(@"%@", arrayResult);
    
    if(arrayResult == nil || arrayResult.count == 0)
        return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *valueDic in arrayResult) {
        [array addObject:[valueDic objectForKey:RespondFieldChikyugoKey]];
    }
    
    return array;
}

- (NSString *)parseRegisterResponseData:(id)result {
    if(result == nil || ![result isKindOfClass:[NSDictionary class]])
        return nil;
    NSDictionary *dic = (NSDictionary *)result;
    DLog(@"%@", result);
    [[User sharedUser] fillLoginData:[dic objectForKey:RespondFieldMemberKey] andToken:[dic objectForKey:RespondFieldTokenKey]];
    return @"OK";
}
@end
