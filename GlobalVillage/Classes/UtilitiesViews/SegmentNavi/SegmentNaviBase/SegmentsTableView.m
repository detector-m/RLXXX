//
//  SegmentsTableView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/29.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentsTableView.h"

@implementation SegmentsTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.scrollsToTop = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.frame = frame;
        self.showsVerticalScrollIndicator = NO;
        self.rowHeight = frame.size.width;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:192/256.0 green:192/256.0 blue:192/256.0 alpha:1.0];
        self.bounces =YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]) {
        self.scrollsToTop = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.showsVerticalScrollIndicator = NO;
        self.rowHeight = frame.size.width;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:192/256.0 green:192/256.0 blue:192/256.0 alpha:1.0];
        self.bounces =YES;
    }
    
    return self;
}


@end
