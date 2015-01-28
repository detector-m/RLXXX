//
//  RLShareKitDefines.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#ifndef GlobalVillage_RLShareKitDefines_h
#define GlobalVillage_RLShareKitDefines_h

#ifdef DEBUG
#ifndef DLog//(format, ...)
#define DLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif
#else
#ifndef DLog
#define DLog(...)
#endif
#endif

typedef NS_ENUM(UInt8, RLSocialShareKitType) {
    kRLSocialShareKitTypeWeChatSession = 1,
    kRLSocialShareKitTypeWeChatTimeline,
    kRLSocialShareKitTypeSinaWebo,
};

#endif
