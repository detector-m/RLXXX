//
//  NewsModel.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/17.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)fillDataWithDic:(NSDictionary *)dic {
    self.ID = [[dic objectForKey:RespondFieldIDKey] integerValue];
    self.title = [dic objectForKey:RespondFieldTitleKey];
    self.abstract = [dic objectForKey:RespondFieldNewsAbstractKey];
    self.readNum = [[dic objectForKey:RespondFieldReadNumKey] integerValue];
    self.picUrl = [(NSArray *)[dic objectForKey:RespondFieldPicListStringKey] objectAtIndex:0];
    self.detailUrl = [dic objectForKey:RespondFieldNewsURLKey];
}
@end
