//
//  SegmentBarItem.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentItemView.h"
#import "SegmentBar.h"

@interface SegmentItemView ()

@end

@implementation SegmentItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)click:(SegmentItemView *)item {
    if(self.delegate) {
        DLog(@"%ld", (long)item.tag);
        [self.delegate selectIndex:item.tag - kSegmentStartTag];
    }
}
@end
