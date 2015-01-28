//
//  NewsController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"
#import "NewsTypeModel.h"
#import "NewsModel.h"
#import "NewsSegmentModel.h"

@protocol NewsControllerDelegate <ModuleControllerDelegate>
@optional
- (void)newsTypeListResponse:(GVResponse *)response;
- (void)newsListResponse:(GVResponse *)response subtag:(NSInteger)subtag;
@end

@interface NewsController : ModuleController
@property (nonatomic, weak) NSString *accessToken;
- (void)newsTypeListRequest:(NSString *)accessToken;

- (void)newsListRequest:(NSInteger)newsTypeID currentCount:(NSInteger)currentCount pageCount:(NSInteger)pageCount token:(__unused NSString *)accessToken subtag:(NSInteger)subtag;
@end
