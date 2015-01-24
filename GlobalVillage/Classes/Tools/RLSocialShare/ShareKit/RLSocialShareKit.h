//
//  RLSocialShareKit.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/24.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    kRLSocialShareKitTypeWeChat,
    kRLSocialShareKitTypeWeChatTimeline,
};

@interface RLSocialShareKit : NSObject

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)registerAppWithType:(RLSocialShareKitType)appType;
@end

NSString* RLEncode(NSString * value);
NSString* RLEncodeURL(NSURL * value);
NSString* RLFlattenHTML(NSString * value, BOOL preserveLineBreaks);
NSString* RLLocalizedStringFormat(NSString* key);
NSString* RLLocalizedString(NSString* key, ...);