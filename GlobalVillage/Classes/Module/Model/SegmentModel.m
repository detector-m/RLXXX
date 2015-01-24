//
//  SegmentModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentModel.h"

@interface SegmentModel ()
@property (nonatomic, readwrite, strong) NSMutableArray *contents;
@end

@implementation SegmentModel
- (void)dealloc {
    self.title = nil;
    [self.contents removeAllObjects], self.contents = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.contents = [NSMutableArray array];
    }
    
    return self;
}

@end
