//
//  NewsController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsController.h"
#import "NewsTypeModel.h"
#import "NewsModel.h"

@implementation NewsController
+ (void)requestWithType:(RequestType)type andSubtag:(NSInteger)subtag parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:subtag parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

- (void)newsTypeListRequest:(NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager newsTypeListParameter:accessToken];
    if(!parameters)
    {
        DLog(@"newsTypeListDic error!");
        NSAssert(parameters !=nil, @"newsTypeListDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeNewsTypeList andSubtag:0 parameters:parameters andDelegate:self];
}

- (void)newsListRequest:(NSInteger)newsTypeID currentCount:(NSInteger)currentCount pageCount:(NSInteger)pageCount token:(__unused NSString *)accessToken subtag:(NSInteger)subtag {
    NSMutableDictionary *parameters = [GVRequestParameterManager newsListParameter:[RLTypecast integerToString:newsTypeID] currentSizeValue:[RLTypecast integerToString:currentCount] pageSizeValue:[RLTypecast integerToString:pageCount] accessTokenValue:self.accessToken];
    
    if(!parameters)
    {
        DLog(@"newsListDic error!");
        NSAssert(parameters !=nil, @"newsListDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeNewsList andSubtag:subtag parameters:parameters andDelegate:self];
}

- (void)newsSubscribeNewsChannelsRequest:(NSString *)subscribeNewsChannels unsubscribeNewsChannels:(NSString *)unsubscribeNewsChannels accessToken:(__unused NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager subscribeNewsChannelsParameter:subscribeNewsChannels unsubscribeNewsChannelsValue:unsubscribeNewsChannels accessTokenValue:self.accessToken];
    
    if(!parameters)
    {
        DLog(@"newsSubscribeNewsChannelsRequest error!");
        NSAssert(parameters !=nil, @"newsSubscribeNewsChannelsRequest error!");
    }
    
    [[self class] requestWithType:kRequestTypeSubscribeNewsChannels andSubtag:0 parameters:parameters andDelegate:self];
}

#pragma mark - RLRequestDelegate
- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {
    DLog(@"%@", error);
    [GVPopViewManager removeActivity];
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];

    dispatch_block_t block = NULL;
    block = ^() {
        [GVPopViewManager showDialogWithTitle:@"网络有问题"];
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)request:(RLRequest *)request
        didLoad:(id)result {
    [GVPopViewManager removeActivity];
    
    [self responseWithType:request.tag subtag:request.subTag result:result];
    
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
}

- (void)responseWithType:(RequestType)type subtag:(NSInteger)subtag result:(id)result {
    if(self.delegate == nil)
        return;
    
    /*__unused */
    GVResponse *response = [[self class] responseWithReqeustResponseData:result];
    
    id<NewsControllerDelegate> delegate = (id<NewsControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeNewsTypeList:
            DLog(@"%@", result);
            response.responseData = result;
            response.responseData = [self parseNewsTypeListResponse:response];

            if([delegate respondsToSelector:@selector(newsTypeListResponse:)]) {
                [delegate newsTypeListResponse:response];
            }
            break;
        case kRequestTypeNewsList:
            response.responseData = result;
            response.responseData = [self parseNewsListResponse:response];
            if([delegate respondsToSelector:@selector(newsListResponse:subtag:)]) {
                [delegate newsListResponse:response subtag:subtag];
            }
            break;
        case kRequestTypeSubscribeNewsChannels:
            response.responseData = result;
            
            if([delegate respondsToSelector:@selector(newsSubscribeNewsChannelsResponse:)]) {
                [delegate newsSubscribeNewsChannelsResponse:response];
            }
            break;
        default:
            break;
    }
}

- (NSArray *)parseNewsTypeListResponse:(GVResponse *)response {
    if(response == nil || response.status != 0)
        return nil;
    NSMutableArray *array = nil;
    NSArray *typeList = [response.responseData objectForKey:RespondFieldTypeListKey];
    if(typeList == nil || typeList.count == 0)
        return nil;
    array = [NSMutableArray array];
    NewsTypeModel *newsType = nil;
    for(NSDictionary *dic in typeList) {
        newsType = [[NewsTypeModel alloc] init];
        [newsType fillDataWithDic:dic];
        
        NewsSegmentModel *newsSegment = [[NewsSegmentModel alloc] init];
        newsSegment.title = newsType.title;
        newsSegment.titleItem = newsType;
        newsSegment.operationMode = newsType.operationMode;
        newsSegment.subscribeMode = newsType.subscribeMode;
        if(newsType.operationMode == kOperationModeCompany) {
            newsSegment.segmentMode = kSegmentModeShow;
        }
        else if(newsType.operationMode == kOperationModePerson) {
            if(newsType.subscribeMode == kSubscribeModeYES) {
                newsSegment.segmentMode = kSegmentModeShow;
            }
        }
        
        [array addObject:newsSegment];
    }
    
    return array;
}

- (NSArray *)parseNewsListResponse:(GVResponse *)response {
    if(response == nil || response.status != 0)
        return nil;
    NSMutableArray *array = nil;
    DLog(@"%@", response.responseData);

    NSArray *newsList = [response.responseData objectForKey:RespondFieldNewsListKey];
    if(!newsList || newsList.count == 0)
        return nil;
    array = [NSMutableArray array];

    for(NSDictionary *dic in newsList) {
        NewsModel *newsType = [[NewsModel alloc] init];
        [newsType fillDataWithDic:dic];
        [array addObject:newsType];
    }
    
    return array;
}

@end
