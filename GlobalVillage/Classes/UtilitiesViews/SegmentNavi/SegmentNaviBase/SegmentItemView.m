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
    if(self.delegate && item.tag != self.delegate.selectedIndex) {
        DLog(@"%ld", (long)item.tag);
        [self.delegate selectIndex:item.tag - kSegmentStartTag];
    }
}

//- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
//    [super setTitleColor:color forState:state];
//    DLog(@"%@", color);
//    DLog(@"%@", [self titleLabel].text);
//}
@end
