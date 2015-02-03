//
//  NewsMacros.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#ifndef GlobalVillage_NewsMacros_h
#define GlobalVillage_NewsMacros_h

//运营方式，0 公司运营 1 自媒体运营
typedef NS_ENUM(UInt8, OperationMode) {
    kOperationModeCompany,
    kOperationModePerson,
};

//用户是否订阅该栏目，1为订阅 0没订阅
typedef NS_ENUM(UInt8, SubscribeMode) {
    kSubscribeModeNO,
    kSubscribeModeYES,
};
#endif
