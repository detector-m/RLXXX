//
//  GVRequestParameterManager.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "GVRequestParameterManager.h"

#define dPhoneNumField @"number"

#define dMobileNumField @"mobile"
#define dMobileAppIdField @"mobileAppId"

#define dMobileAuthCodeField @"authcode"

#define dAvailableDQNumIsChargeField @"isCharge"
#define dAvailableDQNumCountField @"size"

#define dVerifyChikyugoChikyugoField    @"chikyugo"

#define dUploadImageField @"files"
#define dDownloadImageNameField @"name"
#define dDownloadImageScaleField @"scale"

#define dUsernameField  @"userName"
#define dMemberNameField @"memberName"
#define dPasswordField  @"password"
#define dPassword2Field @"passward"
#define dLatitudeField  @"latitude"
#define dLongitudeField @"longitude"
#define dCityField      @"city"
#define dRegisteredCityField @"registeredCity"
#define dGuestChikyugoField @"guestChikyugo"
#define dSexField       @"sex"
#define dHeadPortraitField  @"headPortrait"

#define dThirdIdField   @"thirdId"

#define dAccessTokenField @"accessToken"

#define dIDField    @"id"
#define dCurrSizeField @"currSize"
#define dPageSizeField @"pageSize"

#define dSubscribesField @"subscibedes"
#define dUnsubscribesField @"unsubscibedes"

//商家
#define dRadiusField    @"radius"
#define dCurrPageField  @"currPage"

@implementation GVRequestParameterManager

+ (NSMutableDictionary *)verifyPhoneNumParameter:(NSString *)phoneNumValue
{
    NSMutableDictionary *retDic = nil;
    if(phoneNumValue == nil || phoneNumValue.length ==0)
        return nil;
    
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:phoneNumValue forKey:dPhoneNumField];
    return retDic;
}

+ (NSMutableDictionary *)mobileAuthCodeParameter:(NSString *)mobileNumValue appId:(NSString *)appId
{
    NSMutableDictionary *retDic = nil;
    
    if(mobileNumValue == nil || mobileNumValue.length == 0)
        return nil;
    if(appId == nil || appId.length == 0)
        return nil;
    
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:mobileNumValue forKey:dMobileNumField];
    [retDic setObject:appId forKey:dMobileAppIdField];
    
    return  retDic;
}

//手机验证码验证参数列表
+ (NSMutableDictionary *)verifyMobileAuthCodeParameter:(NSString *)mobileNumValue
                                              authCode:(NSString *)authCodeValue {
    NSMutableDictionary *retDic = nil;
    
    if(mobileNumValue == nil || mobileNumValue.length == 0) {
        return nil;
    }
    if(authCodeValue == nil || authCodeValue.length == 0)
        return nil;
    retDic = [NSMutableDictionary dictionary];
    
    [retDic setObject:mobileNumValue forKey:dMobileNumField];
    [retDic setObject:authCodeValue forKey:dMobileAuthCodeField];
    
    return retDic;
}

//获取可用地球号列表参数列表-> isCharge 1 收费  0免费
+ (NSMutableDictionary *)getChikyugosParameter:(NSString *)isChargeValue
                                         count:(NSString *)countValue {
    NSMutableDictionary *retDic = nil;
    if (isChargeValue == nil || isChargeValue.length==0) {
        return nil;
    }
    if(countValue == nil || countValue.length == 0) {
        return nil;
    }
    
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:isChargeValue forKey:dAvailableDQNumIsChargeField];
    [retDic setObject:countValue forKey:dAvailableDQNumCountField];
    
    return retDic;
}

//地球号是否被用验证参数列表
+ (NSMutableDictionary *)verifyChikyugoParameter:(NSString *)chikyugoValue {
    NSMutableDictionary *retDic = nil;
    
    if(chikyugoValue == nil || chikyugoValue.length == 0)
        return nil;
    
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:chikyugoValue forKey:dVerifyChikyugoChikyugoField];
    
    return  retDic;
}

//上传图片参数列表
+ (NSMutableDictionary *)uploadImageParameter:(UIImage *)imageDataValue {
    if(imageDataValue == nil)
        return nil;
    
    NSMutableDictionary *retDic = nil;
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:imageDataValue forKey:dUploadImageField];
    
    return retDic;
}
//下载图片参数列表
+ (NSMutableDictionary *)downloadImageParameter:(NSString *)imageUrlValue
                                 imageScaleVale:(NSString *)scaleValue
                                    accessToken:(NSString *)accessTokenValue {
    if(imageUrlValue.length == 0 || accessTokenValue.length == 0) {
        return nil;
    }
    NSMutableDictionary *retDic = nil;
    retDic = [NSMutableDictionary dictionary];
    
    [retDic setObject:imageUrlValue forKey:dDownloadImageNameField];
    [retDic setObject:scaleValue forKey:dDownloadImageScaleField];
    [retDic setObject:accessTokenValue forKey:dAccessTokenField];
    
    return retDic;
}

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
                       headPortraitValue:(NSString *)headPortraitValue {
    NSMutableDictionary *retDic = nil;
    
    if(nicknameValue==nil ||
       passwordValue == nil ||
       mobileNumValue == nil ||
       chikyugoValue  == nil ||
       sexValue == nil /*||
       cityValue == nil ||
       longitudeValue == nil ||
       latitudeValue == nil*/) {
        
        return nil;
    }
    
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:nicknameValue forKey:dMemberNameField];
    [retDic setObject:chikyugoValue forKey:dGuestChikyugoField];
    [retDic setObject:passwordValue forKey:dPassword2Field];
    [retDic setObject:mobileNumValue forKey:dMobileNumField];
    [retDic setObject:sexValue forKey:dSexField];
    [retDic setObject:cityValue forKey:dRegisteredCityField];
    [retDic setObject:longitudeValue forKey:dLongitudeField];
    [retDic setObject:latitudeValue forKey:dLatitudeField];
    if(headPortraitValue != nil) {
        [retDic setObject:headPortraitValue forKey:dHeadPortraitField];
    }
    
    if(thirdidValue != nil) {
        [retDic setObject:thirdidValue forKey:dThirdIdField];
    }
    
    return retDic;
}

//用户登录参数列表
+ (NSMutableDictionary *)loginParameter:(NSString *)userAccountValue
                          passwordValue:(NSString *)passwordValue
                          latitudeValue:(NSString *)latitudeValue
                        longtitudeValue:(NSString *)longitudeValue
                              cityValue:(NSString *)cityValue
                           thirdIdValue:(NSString *)thirdIdValue {
    NSMutableDictionary *retDic = nil;
//    if(latitudeValue == nil || latitudeValue.length == 0 ||
//       longitudeValue == nil || longitudeValue.length == 0 ||
//       cityValue == nil || cityValue.length == 0)
//        return nil;
    if((userAccountValue == nil || userAccountValue.length == 0 ||
        passwordValue == nil || passwordValue.length == 0) &&
       (thirdIdValue == nil || thirdIdValue.length == 0))
        return nil;
    
    retDic = [NSMutableDictionary dictionary];
    if(userAccountValue) {
        [retDic setObject:userAccountValue forKey:dUsernameField];
        [retDic setObject:passwordValue forKey:dPasswordField];
    }
    else {
        [retDic setObject:thirdIdValue forKey:dThirdIdField];
    }
    
    if(latitudeValue && longitudeValue) {
        [retDic setObject:latitudeValue forKey:dLatitudeField];
        [retDic setObject:longitudeValue forKey:dLongitudeField];
    }
    if(cityValue) {
        [retDic setObject:cityValue forKey:dRegisteredCityField];
    }
    
    return retDic;
}

+ (NSMutableDictionary *)newsTypeListParameter:(NSString *)accessTokenValue {
    NSMutableDictionary *retDic = nil;
    
    if(!accessTokenValue || accessTokenValue.length == 0)
        return nil;
    retDic = [NSMutableDictionary dictionary];
    
    [retDic setObject:accessTokenValue forKey:dAccessTokenField];
    
    return retDic;
}

//根据类型获取新闻列表参数列表
+ (NSMutableDictionary *)newsListParameter:(NSString *)idValue
                          currentSizeValue:(NSString *)currSizeValue
                             pageSizeValue:(NSString *)pageSizeValue
                          accessTokenValue:(NSString *)accessTokenValue {
    NSMutableDictionary *retDic = nil;
    
    if(idValue == nil || idValue.length == 0 || accessTokenValue == nil || accessTokenValue.length == 0)
        return nil;
    retDic = [NSMutableDictionary dictionary];
    [retDic setObject:idValue forKey:dIDField];
    [retDic setObject:currSizeValue forKey:dCurrSizeField];
    [retDic setObject:pageSizeValue forKey:dPageSizeField];
    [retDic setObject:accessTokenValue forKey:dAccessTokenField];
    
    return retDic;
}

//“订阅/取消订阅”新闻栏目接口
+ (NSMutableDictionary *)subscribeNewsChannelsParameter:(NSString *)subscribeNewsChannelsValue
                           unsubscribeNewsChannelsValue:(NSString *)unsubscribeNewsChannelsValue
                                       accessTokenValue:(NSString *)accessTokenValue {
    if(accessTokenValue.length == 0)
        return nil;
    
    if(subscribeNewsChannelsValue.length == 0)
        subscribeNewsChannelsValue = @"";
    
    NSMutableDictionary *retDic = [NSMutableDictionary dictionary];
    if(subscribeNewsChannelsValue.length) {
        [retDic setObject:subscribeNewsChannelsValue forKey:dSubscribesField];
    }
    
    if(unsubscribeNewsChannelsValue.length) {
        [retDic setObject:unsubscribeNewsChannelsValue forKey:dUnsubscribesField];
    }
    
    [retDic setObject:accessTokenValue forKey:dAccessTokenField];
    return retDic;
}

//获取商家列表参数列表
+ (NSMutableDictionary *)storeListParameter:(NSString *)radiusValue
                             longitudeValue:(NSString *)longitudeValue
                              latitudeValue:(NSString *)latitudeValue
                              pageSizeValue:(NSString *)pageSizeValue
                              currPageValue:(NSString *)currPageSizeValue
                           accessTokenValue:(NSString *)accessTokenValue {
    NSMutableDictionary *retDic = nil;
    if(longitudeValue == nil || latitudeValue == nil ||
       pageSizeValue == nil || currPageSizeValue == nil ||
       accessTokenValue == nil)
        return nil;
    
    retDic = [NSMutableDictionary dictionary];
    if(radiusValue != nil) {
        [retDic setObject:radiusValue forKey:dRadiusField];
    }
    [retDic setObject:longitudeValue forKey:dLongitudeField];
    [retDic setObject:latitudeValue forKey:dLatitudeField];
    [retDic setObject:pageSizeValue forKey:dPageSizeField];
    [retDic setObject:currPageSizeValue forKey:dCurrPageField];
    [retDic setObject:accessTokenValue forKey:dAccessTokenField];
    
    return  retDic;
}

@end
