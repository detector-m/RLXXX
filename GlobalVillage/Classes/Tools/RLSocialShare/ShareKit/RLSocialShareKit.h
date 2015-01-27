//
//  RLSocialShareKit.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/24.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLSocialShareKitDefines.h"
#import "RLShareAppModel.h"
#import "RLShareMessageModel.h"

#import "WeiboSDK.h"
#import "WXApi.h"

//$(PRODUCT_NAME:rfc1034identifier) dqcc.com.cn.

@interface RLSocialShareKit : NSObject
@property (nonatomic, readonly, assign) RLSocialShareKitType type;
@property (nonatomic, readonly, strong) id shareTarget;

@property (nonatomic, readonly, strong) RLShareAppModel *shareAppInfo;

@property (nonatomic, readwrite, weak) UIViewController *weChatAuthVC;

+ (RLSocialShareKit *)sharedShareKit;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)registerAppWithType:(RLSocialShareKitType)appType;

- (void)targetAppAuthLogin:(RLSocialShareKitType)type;

- (void)sendMessageToTargetApp:(RLShareMessageModel *)messageToShare;
@end

NSString* RLEncode(NSString * value);
NSString* RLEncodeURL(NSURL * value);
NSString* RLFlattenHTML(NSString * value, BOOL preserveLineBreaks);
NSString* RLLocalizedStringFormat(NSString* key);
NSString* RLLocalizedString(NSString* key, ...);