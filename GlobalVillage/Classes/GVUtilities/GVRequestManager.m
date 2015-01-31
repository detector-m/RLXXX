//
//  GVRequestManager.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "GVRequestManager.h"
#import "RLReachabilityChecker.h"

static NSString *kDefaultHttpMethod = @"POST";
static NSString *kRestserverBaseURL = @"http://www.dqcc.com.cn/mobile";
//static NSString *kRestserverApiURL = @"http://www.dqcc.com.cn/mobile/api/";
//http://www.dqcc.com.cn/mobile/api/v20/
static NSString *kRestserverApiURL = @"http://www.dqcc.com.cn/mobile/api/v20";


@implementation GVRequestManager

+ (void)removeAllRequestForKey:(NSString *)key {
    if(key == nil || key.length == 0)
        return;
    [[RLRequestMgr shared] removeAllRequestForKey:key];
}
+ (RLRequest *)openUrl:(NSString *)url
            parameters:(NSMutableDictionary *)parameters
            httpMethod:(NSString *)httpMethod
              delegate:(id<RLRequestDelegate>)delegate {
    if(![RLReachabilityChecker isReachability])
        return nil;
    if(url==nil || !url.length)
        return nil;
    if(!httpMethod || httpMethod.length<3)
        httpMethod = @"POST";
    
    RLRequest *request = [RLRequest getReqeustWithParams:parameters
                                              httpMethod:httpMethod
                                                delegate:delegate
                                              requestURL:url];
    if(!request)
        return nil;
    [request connect];
    
    return request;
}

+ (RLRequest *)requestWithPageName:(NSString *)pageName
                        parameters:(NSMutableDictionary *)parameters
                        httpMethod:(NSString *)httpMethod
                          delegate:(id<RLRequestDelegate>)delegate {
    NSString *fullURL = [kRestserverApiURL stringByAppendingString:pageName];
    if(fullURL && fullURL.length == 0) {
        return nil;
    }
    
    return [self openUrl:fullURL parameters:parameters httpMethod:httpMethod delegate:delegate];
}
//手机号码是否使用
+ (RLRequest *)requestVerifyPhoneNum:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"veriftyMobile.jhtml";
    NSString *pageName = @"/verifty/isMobileUse.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//获取手机验证码
+ (RLRequest *)requestMobileAuthCode:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"sendMobileAuthcode.jhtml";
    NSString *pageName = @"/verifty/sendMobileAuthcode.jhtml";
    
    return [self requestWithPageName:pageName
                          parameters:parameters
                          httpMethod:kDefaultHttpMethod
                            delegate:delegate];
}

//验证手机验证码
+ (RLRequest *)requestVerifyMobileAuthCode:(NSMutableDictionary *)parameters
                               andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"verifyMobileAuthcode.jhtml";
    NSString *pageName = @"/verifty/isMobileAuthcodeRight.jhtml";

    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:delegate];
}
//获取可用的地球列表号
+ (RLRequest *)requestGetChikyugos:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"getChikyugos.jhtml";
      NSString *pageName = @"/member/getChikyugos.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//地球号是否使用验证
+ (RLRequest *)requestVerifyChikyugo:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"veriftyChikyugo.jhtml";
    NSString *pageName = @"/verifty/isChikyugoUse.jhtml";

    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//用户注册
+ (RLRequest *)requestRegist:(NSMutableDictionary *)parameters
                 andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"regist.jhtml";
    NSString *pageName = @"/member/regist.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//用户登录
+ (RLRequest *)requestLogin:(NSMutableDictionary *)parameters
                andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"login.jhtml";
    NSString *pageName = @"/member/login.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//获取新闻类型列表
+ (RLRequest *)requestNewsTypeList:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"newsTypeList.jhtml";
    NSString *pageName = @"/news/newsTypeList.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//根据类型获取新闻列表
+ (RLRequest *)requestNewsList:(NSMutableDictionary *)parameters
                   andDelegate:(id<RLRequestDelegate>)delegate {
//    NSString *pageName = @"newsList.jhtml";
    NSString *pageName = @"/news/newsList.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:(id<RLRequestDelegate>)delegate];
}

//获取商家列表
+ (RLRequest *)requestForStoreList:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate {
    NSString *pageName = @"storeList.jhtml";
    
    return [self requestWithPageName:pageName parameters:parameters httpMethod:kDefaultHttpMethod delegate:delegate];
}

+ (RLRequest *)requestWithType:(RequestType)type subTag:(NSInteger)subTag parameters:(NSMutableDictionary *)parameters keyClass:(NSString *)keyClass andDelegate:(id<RLRequestDelegate>)delegate {
    RLRequest *request = nil;
    [[RLRequestMgr shared] removeRequestForKey:keyClass withTag:type andSubTag:subTag];

    request = [self requestWithType:type parameters:parameters andDelegate:delegate];
    
    if(request != nil) {
        request.tag = type;
        request.subTag = subTag;
        
        [[RLRequestMgr shared] addRequestForKey:keyClass request:request];
        [RLRequestMgr showStatusActivityIndicator];
    }
    return request;
}

+ (RLRequest *)requestWithType:(RequestType)type parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    RLRequest *request = nil;
    switch (type) {
        case kRequestTypeVerifyPhoneNum:
            request = [self requestVerifyPhoneNum:parameters andDelegate:delegate];
            break;
        case kRequestTypeMobileAuthCode:
            request = [self requestMobileAuthCode:parameters andDelegate:delegate];
            break;
        case kRequestTypeVerifyMobileAuthCode:
            request = [self requestVerifyMobileAuthCode:parameters andDelegate:delegate];
            break;
        case kRequestTypeFreeDQNumberList:
        case kRequestTypeChargeDQNumberList:
            request = [self requestGetChikyugos:parameters andDelegate:delegate];
            break;
        case kRequestTypeVerifyDQNumber:
            request = [self requestVerifyChikyugo:parameters andDelegate:delegate];
            break;
        case kRequestTypeRegister:
            request = [self requestRegist:parameters andDelegate:delegate];
            break;
        case kRequestTypeLogin:
            request = [self requestLogin:parameters andDelegate:delegate];
            break;
        case kRequestTypeNewsTypeList:
            request = [self requestNewsTypeList:parameters andDelegate:delegate];
            break;
        case kRequestTypeNewsList:
            request = [self requestNewsList:parameters andDelegate:delegate];
            break;
        default:
            break;
    }
    
    return request;
}
@end
