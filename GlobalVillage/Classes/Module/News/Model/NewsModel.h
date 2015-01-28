//
//  NewsModel.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/17.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "NewsBaseModel.h"

@interface NewsModel : NewsBaseModel
@property (nonatomic, assign) NSInteger readNum;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *detailUrl;

@property (nonatomic, assign) BOOL hasRead;

- (void)fillDataWithDic:(NSDictionary *)dic;
@end
