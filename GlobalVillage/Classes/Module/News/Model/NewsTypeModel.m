//
//  NewsTypeModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsTypeModel.h"

@implementation NewsTypeModel
- (void)fillDataWithDic:(NSDictionary *)dic {
    self.ID = [[dic objectForKey:RespondFieldIDKey] integerValue];
    self.title = [dic objectForKey:RespondFieldNameKey];
    self.orderId = [[dic objectForKey:RespondFieldOrderIdKey] integerValue];
    self.selected = [[dic objectForKey:RespondFieldSelectedKey] integerValue];
}
@end
