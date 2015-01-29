//
//  NewsDetailVC.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/17.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "NewsDetailVC.h"

#import "GVPopViewManager.h"

#import "RLSocialShareKit.h"
#import "RLActivityShare.h"

@interface NewsDetailVC () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *newsDatailView;

//@property (nonatomic, strong) UIActivityViewController *activityController;

@property (nonatomic, strong) RLSocialShareKit *shareKit;
@end

@implementation NewsDetailVC
@synthesize newsUrl = _newsUrl;
@synthesize newsDatailView = _newsDatailView;

- (void)dealloc {
    _newsUrl = nil;
    _newsDatailView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.newsDatailView stopLoading];
    self.newsDatailView.delegate = nil;
    
}

//- (void)test {
//    if(self.shareKit) {
//        return;
//    }
//    self.shareKit = [RLSocialShareKit sharedShareKit];
//    [self.shareKit registerAppWithType:2];
//}

- (void)dataDoLoad {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"新闻详情", nil);
//    [self dataDoLoad];
    
    [self newsDatailViewDoLoad];
    [self setNavigationBarRightItem];
}

- (void)newsDatailViewDoLoad {
    if(self.newsDatailView == nil) {
        self.newsDatailView = [[UIWebView alloc] init];
        self.newsDatailView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.newsDatailView.delegate = self;
        [self.view addSubview:self.newsDatailView];
        [self loadRequest];
    }
}

- (void)loadRequest {
    [self.newsDatailView loadRequest:[self requestForNews:self.newsUrl]];
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"正在加载。。。", nil)];
}

- (NSURLRequest *)requestForNews:(NSString *)aUrl {
    NSURL *newsUrl = [NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:newsUrl];
    return request;
}

- (void)setNavigationBarRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"分享", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickRightItem:(UIBarButtonItem *)item {
    item.enabled = NO;
    __block UIBarButtonItem *blockItem = item;
    id block;/* = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
              blockItem.enabled = YES;
              };*/
    
    RLSinaWeiboActivity *sinaWeiboActivity = [[RLSinaWeiboActivity alloc] init];
    sinaWeiboActivity.callback = @selector(sendMessageToTargetApp:);
    sinaWeiboActivity.delegate = self;
    RLShareMessageModel *message = sinaWeiboActivity.message;
    message.appType = kRLSocialShareKitTypeSinaWebo;
    message.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SinaWeibo" ofType:@"png"]];
    
    RLWeChatSessionActivity *weChatSessionActivity = [[RLWeChatSessionActivity alloc] init];
    weChatSessionActivity.callback = @selector(sendMessageToTargetApp:);
    weChatSessionActivity.delegate = self;
    weChatSessionActivity.message.appType = kRLSocialShareKitTypeWeChatSession;
    weChatSessionActivity.message.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SinaWeibo" ofType:@"png"]];
    
    RLWeChatTimeLineActivity *weChatTimelineActivity = [[RLWeChatTimeLineActivity alloc] init];
    weChatTimelineActivity.callback = @selector(sendMessageToTargetApp:);
    weChatTimelineActivity.delegate = self;
    weChatTimelineActivity.message.appType = kRLSocialShareKitTypeWeChatTimeline;
    weChatTimelineActivity.message.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SinaWeibo" ofType:@"png"]];
    
    block = ^(NSString *  activityType, BOOL completed) {
        blockItem.enabled = YES;
    };
    
    RLActivityShare *activityShare = [[RLActivityShare alloc] init];
    //    NSArray *activityItems = [[NSArray alloc]initWithObjects:NSLocalizedString(@"一款免费发送广告的APP！手机号、微信号、地球号一个都不能少！", nil), @"http://www.dqcc.com.cn", [UIImage imageNamed:@"qq_icon.png"], nil];
    activityShare.showVC = self;
    //    activityShare.showItems = nil;//activityItems;
    activityShare.completionHandler = block;
    activityShare.appActivities = @[weChatSessionActivity, weChatTimelineActivity, sinaWeiboActivity];
    
    [activityShare showActivityViewController];
}

- (void)sendMessageToTargetApp:(RLShareMessageModel *)message {
    [[RLSocialShareKit sharedShareKit] sendMessageToTargetApp:message];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GVPopViewManager removeActivity];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"error=%@", error);
    [GVPopViewManager removeActivity];

    [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"加载出错！", nil)];
}

@end
