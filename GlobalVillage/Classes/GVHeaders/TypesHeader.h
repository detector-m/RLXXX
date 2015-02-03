//
//  TypesHeader.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#ifndef GlobalVillage_TypesHeader_h
#define GlobalVillage_TypesHeader_h

#ifndef Description//(x)
#define Description(x)
#endif

typedef NS_ENUM(NSInteger, LoginType) {
    kLoginTypeLocal = 0, //本地登录
    kLoginTypeThird = 1, //第三方登录
};

//性别 1为男，2为女
typedef NS_ENUM(NSInteger, GenderType) {
    kGenderTypeNon = 0,
    kGenderTypeMan = 1,
    kGenderTypeWom = 2,
};

////性别 0->女 , 1->男
//typedef NS_ENUM(NSUInteger, GenderType) {
//    kGenderTypeWom = 0,
//    kGenderTypeMan = 1,
//};

//用户是否为商家，1，普通用户，2商家
typedef NS_ENUM(NSInteger, UserType) {
    kUserTypeNone = 0,
    kUserTypeNormal,
    kUserTypeVendor,
};
#endif
