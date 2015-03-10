//
//  GVRequestParameterManager.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVRequestParameterManager : NSObject
//手机号是否可用参数列表
+ (NSMutableDictionary *)verifyPhoneNumParameter:(NSString *)phoneNumValue;
//获取手机验证码参数列表
+ (NSMutableDictionary *)mobileAuthCodeParameter:(NSString *)mobileNumValue
                                           appId:(NSString *)appId;
//手机验证码验证参数列表
+ (NSMutableDictionary *)verifyMobileAuthCodeParameter:(NSString *)mobileNumValue
                                              authCode:(NSString *)authCodeValue;
//获取可用地球号列表参数列表
+ (NSMutableDictionary *)getChikyugosParameter:(NSString *)isChargeValue
                                         count:(NSString *)countValue;
//地球号是否被用验证参数列表
+ (NSMutableDictionary *)verifyChikyugoParameter:(NSString *)chikyugoValue;

//上传图片参数列表
+ (NSMutableDictionary *)uploadImageParameter:(UIImage *)imageDataValue;
//下载图片参数列表
+ (NSMutableDictionary *)downloadImageParameter:(NSString *)imageUrlValue
                                 imageScaleVale:(NSString *)scaleValue
                                    accessToken:(NSString *)accessTokenValue;

//用户注册参数列表
+ (NSMutableDictionary *)registParameter:(NSString *)nicknameValue
                           chikyugoValue:(NSString *)chikyugoValue
                            thirdidValue:(NSString *)thirdidValue
                           passwordValue:(NSString *)passwordValue
                          mobileNumValue:(NSString *)mobileNumValue
                                sexValue:(NSString *)sexValue
                               cityValue:(NSString *)cityValue
                          longitudeValue:(NSString *)longitudeValue
                           latitudeValue:(NSString *)latitudeValue
                       headPortraitValue:(NSString *)headPortraitValue;
//用户登录参数列表
+ (NSMutableDictionary *)loginParameter:(NSString *)userAccountValue
                          passwordValue:(NSString *)passwordValue
                          latitudeValue:(NSString *)latitudeValue
                        longtitudeValue:(NSString *)longitudeValue
                              cityValue:(NSString *)cityValue
                           thirdIdValue:(NSString *)thirdIdValue;

//回密码接口参数
+ (NSMutableDictionary *)findPasswordParameter:(NSString *)mobileNumberValue
                               authcodeValue:(NSString *)authcodeValue
                            newPasswordValue:(NSString *)newPasswordValue;
//密码修改接口参数
+ (NSMutableDictionary *)resetPasswordParameter:(NSString *)oldPasswordValue
                             newPasswordValue:(NSString *)newPasswordValue
                             accessTokenValue:(NSString *)accessTokenValue;

//获取新闻类型列表参数列表
+ (NSMutableDictionary *)newsTypeListParameter:(NSString *)accessTokenValue;

//根据类型获取新闻列表参数列表
+ (NSMutableDictionary *)newsListParameter:(NSString *)idValue
                          currentSizeValue:(NSString *)currSizeValue
                             pageSizeValue:(NSString *)pageSizeValue
                          accessTokenValue:(NSString *)accessTokenValue;

//“订阅/取消订阅”新闻栏目接口
+ (NSMutableDictionary *)subscribeNewsChannelsParameter:(NSString *)subscribeNewsChannelsValue
                           unsubscribeNewsChannelsValue:(NSString *)unsubscribeNewsChannelsValue
                                       accessTokenValue:(NSString *)accessTokenValue;

////////////////////
//获取附近的人接口
+ (NSMutableDictionary *)nearbyPersonParameter:(NSString *)longitudeValue
                                 latitudeValue:(NSString *)latitudeValue
                                   radiusValue:(NSString *)radiusValue
                                 pageSizeValue:(NSString *)pageSizeValue
                              currentPageValue:(NSString *)currentPageValue
                              accessTokenValue:(NSString *)accessTokenValue;
////////////////////

//获取商家列表参数列表
+ (NSMutableDictionary *)storeListParameter:(NSString *)radiusValue
                             longitudeValue:(NSString *)longitudeValue
                              latitudeValue:(NSString *)latitudeValue
                              pageSizeValue:(NSString *)pageSizeValue
                              currPageValue:(NSString *)currPageSizeValue
                           accessTokenValue:(NSString *)accessTokenValue;

////////////////////
//用户资料修改
+ (NSMutableDictionary *)UpdateUserInfoParameter:(NSString *)nicknameValue
                                        sexValue:(NSString *)sexValue
                                       cityValue:(NSString *)cityValue
                               headPortraitValue:(NSString *)headPortraitValue
                                        ageValue:(NSString *)ageValue
                                  signatureValue:(NSString *)signatureValue
                                accessTokenValue:(NSString *)accessTokenValue;

//获取用户资料详情接口
+ (NSMutableDictionary *)FindMemberInfoParameter:(NSString *)gidValue
                                accessTokenValue:(NSString *)accessTokenValue;
@end
