//
//  NewsTypeModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsBaseModel.h"
#import "NewsMacros.h"

@interface NewsTypeModel : NewsBaseModel
@property (nonatomic, assign) OperationMode operationMode;
@property (nonatomic, assign) SubscribeMode subscribeMode;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) BOOL selected;

- (void)fillDataWithDic:(NSDictionary *)dic;
@end
