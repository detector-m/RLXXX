//
//  GVRequestManager.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLRequestMgr.h"
#import "GVRequestParameterManager.h"

typedef NS_ENUM(NSInteger, RequestType) {
    kRequestTypeNone = 0,
    
    kRequestTypeVerifyPhoneNum = 1,
    
    kRequestTypeMobileAuthCode,
    kRequestTypeVerifyMobileAuthCode,
    
    kRequestTypeFreeDQNumberList,
    kRequestTypeChargeDQNumberList,
    kRequestTypeVerifyDQNumber,
    
    kRequestTypeUploadImage,
    kRequestTypeDownloadImage,
    
    kRequestTypeRegister,
    
    kRequestTypeLogin,
    
    kRequestTypeNewsTypeList,
    kRequestTypeNewsList,
    
    kRequestTypeSubscribeNewsChannels,
    
    kRequestTypeStoreList,
};

@interface GVRequestManager : NSObject

+ (void)removeAllRequestForKey:(NSString *)key;

//验证手机号码
+ (RLRequest *)requestVerifyPhoneNum:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate;
//获取手机验证码
+ (RLRequest *)requestMobileAuthCode:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate;
//验证手机验证码
+ (RLRequest *)requestVerifyMobileAuthCode:(NSMutableDictionary *)parameters
                               andDelegate:(id<RLRequestDelegate>)delegate;
//获取可用的地球列表号
+ (RLRequest *)requestGetChikyugos:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate;
//地球号是否使用验证
+ (RLRequest *)requestVerifyChikyugo:(NSMutableDictionary *)parameters
                         andDelegate:(id<RLRequestDelegate>)delegate;

//上传图片
+ (RLRequest *)requestUploadImage:(NSMutableDictionary *)parameters
                      andDelegate:(id<RLRequestDelegate>)delegate;
//下载图片
+ (RLRequest *)requestDownloadImage:(NSMutableDictionary *)parameters
                        andDelegate:(id<RLRequestDelegate>)delegate;

//用户注册
+ (RLRequest *)requestRegist:(NSMutableDictionary *)parameters
                 andDelegate:(id<RLRequestDelegate>)delegate;

//用户登录
+ (RLRequest *)requestLogin:(NSMutableDictionary *)parameters
                andDelegate:(id<RLRequestDelegate>)delegate;

//获取新闻类型列表
+ (RLRequest *)requestNewsTypeList:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate;

//根据类型获取新闻列表
+ (RLRequest *)requestNewsList:(NSMutableDictionary *)parameters
                   andDelegate:(id<RLRequestDelegate>)delegate;

//订阅/取消订阅新闻栏目接口
+ (RLRequest *)requestSubscribeNewsChannels:(NSMutableDictionary *)parameters
                                andDelegate:(id<RLRequestDelegate>)delegate;

//获取商家列表
+ (RLRequest *)requestForStoreList:(NSMutableDictionary *)parameters
                       andDelegate:(id<RLRequestDelegate>)delegate;

+ (RLRequest *)requestWithType:(RequestType)type subTag:(NSInteger)subTag parameters:(NSMutableDictionary *)parameters keyClass:(NSString *)keyClass andDelegate:(id<RLRequestDelegate>)delegate;
@end
