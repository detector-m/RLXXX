//
//  Segment.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "Segment.h"

@implementation Segment
- (void)dealloc {
    self.item = nil;
    self.content = nil;
}

- (instancetype)init {
    if(self = [super init]) {
        self.item = [[SegmentItem alloc] init];
        self.content = [[SegmentContent alloc] init];
    }
    
    return self;
}
@end
