//
//  NewsSegmentModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsSegmentModel.h"

@implementation NewsSegmentModel

- (instancetype)init {
    if(self = [super init]) {
        self.needRefresh = NO;
    }
    
    return self;
}
@end
