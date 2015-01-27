//
//  RLSocialShareKit.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/24.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLSocialShareKit.h"

#define kRLSocialShareKitConfigFile @"RLSocialShareConfig.plist"

#define AccessTokenKey          @"ShareAccessToken"
#define ExpirationDateKey       @"ShareExpirationDate"
#define ExpireTimeKey           @"ShareExpireTime"
#define UserIDKey               @"ShareUserID"
#define OpenIdKey               @"ShareOpenId"
#define OpenKeyKey              @"ShareOpenKey"
#define RefreshTokenKey         @"ShareRefreshToken"
#define NameKey                 @"ShareName"
#define SSOAuthKey              @"ShareIsSSOAuth"

static NSDictionary* RLSocialShareKitConfigInfo();

@interface RLSocialShareKit () <WXApiDelegate, WeiboSDKDelegate>
@property (nonatomic, readwrite, assign) RLSocialShareKitType type;
@property (nonatomic, readwrite, strong) id shareTarget;

@property (nonatomic, strong) RLShareAppModel *shareAppInfo;
@end
@implementation RLSocialShareKit

static RLSocialShareKit *_shareKit = nil;
+ (RLSocialShareKit *)sharedShareKit {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareKit = [[self alloc] init];
    });
    return _shareKit;
}

- (instancetype)init {
    if(self = [super init]) {
        self.shareAppInfo = [[RLShareAppModel alloc] init];
    }
    
    return self;
}

- (void)fillShareAppInfoWityType:(RLSocialShareKitType)type {
    NSDictionary *configInfo = RLSocialShareKitConfigInfo();
    switch (type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline:
            self.shareAppInfo.appKey = [configInfo objectForKey:@"WeChatAppId"];
            self.shareAppInfo.appSecret = [configInfo objectForKey:@"WeChatAppKey"];
            self.shareAppInfo.appRedirectURI = [configInfo objectForKey:@"WeChatRedirectURI"];
            break;
        case kRLSocialShareKitTypeSinaWebo:
            self.shareAppInfo.appKey = [configInfo objectForKey:@"SinaWeiboAppKey"];
            self.shareAppInfo.appSecret = [configInfo objectForKey:@"SinaWeiboSecret"];
            self.shareAppInfo.appRedirectURI = [configInfo objectForKey:@"SinaWeiboRedirectURI"];
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }
    
}
- (BOOL)handleOpenURL:(NSURL *)url {
    if(url == nil)
        return NO;
    DLog(@"%@", url.absoluteString);
    
    switch (self.type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline:
            [WXApi handleOpenURL:url delegate:self];
            break;
        case kRLSocialShareKitTypeSinaWebo:
            [WeiboSDK handleOpenURL:url delegate:self];
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }
    
    return YES;
}

- (void)registerAppWithType:(RLSocialShareKitType)appType {
    if(appType == self.type) {
        return;
    }
    
    self.type = appType;
    [self.shareAppInfo clearDatas];
    [self fillShareAppInfoWityType:appType];
    switch (appType) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline:
            [WXApi registerApp:self.shareAppInfo.appKey withDescription:@"demo 2.0"];
            break;
        case kRLSocialShareKitTypeSinaWebo:
            [WeiboSDK enableDebugMode:YES];
            [WeiboSDK registerApp:self.shareAppInfo.appKey];
//            [self targetAppSSOLogin:kRLSocialShareKitTypeSinaWebo];
//            [self sendMessageToTargetApp:kRLSocialShareKitTypeSinaWebo andMessage:nil];
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }
}

- (BOOL)targetAppIsInstalled:(RLSocialShareKitType)type {
    switch (type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline:
            return [WXApi isWXAppInstalled];
            break;
        case kRLSocialShareKitTypeSinaWebo:
            return [WeiboSDK isWeiboAppInstalled];
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }
    
    return NO;
}

- (void)targetAppAuthLogin:(RLSocialShareKitType)type {
    switch (type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline: {
            SendAuthReq* req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
            req.state = @"xxx";
            req.openID = @"0c806938e2413ce73eef92cc3";
            
            [WXApi sendAuthReq:req viewController:self.weChatAuthVC delegate:self];
        }
            break;
        case kRLSocialShareKitTypeSinaWebo: {
            if(![WeiboSDK isCanSSOInWeiboApp]) {
                DLog(@"WeiboSDK can not SSO in weibo app!!!");
                return;
            }
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = self.shareAppInfo.appRedirectURI;
            request.scope = @"all";
            request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
        }
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }

}

- (BOOL)isLogined:(RLSocialShareKitType)type {
    switch (type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline:
            return YES;
            break;
        case kRLSocialShareKitTypeSinaWebo:
           return [WeiboSDK isCanShareInWeiboAPP];
            break;
            
        default:
            DLog(@"app type error!");
            break;
    }

    
    return NO;
}

- (void)sendMessageToTargetApp:(RLShareMessageModel *)messageToShare {
    RLSocialShareKitType type = messageToShare.appType;
    [self registerAppWithType:type];
    
    switch (type) {
        case kRLSocialShareKitTypeWeChatSession:
        case kRLSocialShareKitTypeWeChatTimeline: {
            
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = [self weChatMessageToShare:messageToShare];
            if(type == kRLSocialShareKitTypeWeChatSession) {
                req.scene = WXSceneSession;
            }
            else if(type == kRLSocialShareKitTypeWeChatTimeline) {
                req.scene = WXSceneTimeline;
            }
            [WXApi sendReq:req];
        }
            break;
        case kRLSocialShareKitTypeSinaWebo: {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = self.shareAppInfo.appRedirectURI;
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self sinaWeiboMessageToShare:messageToShare] authInfo:authRequest access_token:self.shareAppInfo.appAccessToken];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];
        }

            break;
            
        default:
            DLog(@"app type error!");
            break;
    }

}

#pragma mark weChat 
- (WXMediaMessage *)weChatMessageToShare:(RLShareMessageModel *)messageToShare {
    if(messageToShare == nil) {
        return nil;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = messageToShare.title;
    message.description = messageToShare.abstract;
    [message setThumbImage:[UIImage imageWithData:messageToShare.imageData]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = messageToShare.url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WeChat_ShareLink";
    
    return message;
}
#pragma mark weibo - sina
- (WBMessageObject *)sinaWeiboMessageToShare:(RLShareMessageModel *)messageToShare {
    if(messageToShare == nil)
        return nil;
#if 0 //demo
    WBMessageObject *message = [WBMessageObject message];

    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(@"分享网页标题", nil);
    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qq_icon" ofType:@"png"]];
    webpage.webpageUrl = @"http://sina.cn?a=1";
    message.mediaObject = webpage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.shareAppInfo.appRedirectURI;
    authRequest.scope = @"all";
#endif
    
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"SinaWeibo_ShareLink";
    webpage.title = messageToShare.title;
    webpage.description = messageToShare.abstract;
    webpage.thumbnailData = messageToShare.thumbData;
    webpage.webpageUrl = messageToShare.url;
    message.mediaObject = webpage;

    return message;
}

#pragma mark - WeChatDelegates 
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
        NSMutableString* cardStr = [[NSMutableString alloc] init];
        for (WXCardItem* cardItem in temp.cardAry) {
            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - SinaWeiboDelegates
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
 {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//            self.wbtoken = accessToken;
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        
        self.shareAppInfo.appAccessToken = [(WBAuthorizeResponse *)response accessToken];
        self.shareAppInfo.appUserId = [(WBAuthorizeResponse *)response userID];
        [alert show];

    }
}

@end
__unused static NSDictionary* RLSocialShareKitConfigInfo() {
    NSString *path = [[NSBundle mainBundle] pathForResource:kRLSocialShareKitConfigFile ofType:nil];
    if(path == nil) {
//        NSAssert(false, @"No %@ file!!!!", kRLSocialShareKitConfigFile);
        [NSException raise:@"RLSocialShareKitConfigFile" format:@"No %@ file!!!!", kRLSocialShareKitConfigFile];
    }
    DLog(@"path = %@", path);
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];

    DLog(@"%@", dictionary);
    return dictionary;
}

NSString* RLEncode(NSString * value) {
    if (value == nil)
        return @"";
    
    NSString *string = value;
    
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    string = [string stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    string = [string stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    
    return string;
}

NSString* RLEncodeURL(NSURL * value) {
    if (value == nil)
        return @"";
    
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value.absoluteString, NULL,                                          CFSTR("!*'();:@&=+$,/?%#[]"),                                    kCFStringEncodingUTF8);
    return result;
}

NSString* RLFlattenHTML(NSString * value, BOOL preserveLineBreaks) {
    // Modified from http://rudis.net/content/2009/01/21/flatten-html-content-ie-strip-tags-cocoaobjective-c
    NSScanner *scanner;
    NSString *text = nil;
    
    scanner = [NSScanner scannerWithString:value];
    
    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    
    if (preserveLineBreaks == NO) {
        value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

NSString* RLLocalizedStringFormat(NSString* key) {
#if 0
    static NSBundle* bundle = nil;
    if (nil == bundle) {
        
        NSString *path = [RL shareKitLibraryBundlePath];
        bundle = [NSBundle bundleWithPath:path];
        NSCAssert(bundle != nil,@"ShareKit has been refactored to be used as Xcode subproject. Please follow the updated installation wiki and re-add it to the project. Please do not forget to clean project and clean build folder afterwards. In case you use CocoaPods override - (NSNumber *)isUsingCocoaPods; method in your configurator subclass and return [NSNumber numberWithBool:YES]");
    }
    NSString *result = [bundle localizedStringForKey:key value:nil table:nil];
    return result;
#endif
    
    return NSLocalizedString(key, nil);
}

NSString* RLLocalizedString(NSString* key, ...) {
    // Localize the format
    NSString *localizedStringFormat = RLLocalizedStringFormat(key);
    
    va_list args;
    va_start(args, key);
    NSString *string = [[NSString alloc] initWithFormat:localizedStringFormat arguments:args];
    va_end(args);
    
    return string;
}