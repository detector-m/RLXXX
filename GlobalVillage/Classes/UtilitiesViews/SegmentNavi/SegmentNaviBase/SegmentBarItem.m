//
//  SegmentBarItem.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentBarItem.h"

@interface SegmentBarItem ()
@property (nonatomic, readwrite, strong) UIImageView *itemImageView;
@property (nonatomic, readwrite, strong) UILabel *itemLabel;
@end

@implementation SegmentBarItem
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.itemImageView = [[UIImageView alloc] init];
        [self addSubview:self.itemImageView];
        
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.textColor = [UIColor blackColor];
        self.itemLabel.font = [UIFont systemFontOfSize:12];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        self.itemLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.itemLabel];
        
        CGFloat width = frame.size.height*0.7;
        CGFloat height = width;
        self.itemImageView.frame = CGRectMake((frame.size.width-width)/2, 0, width, height);
        self.itemLabel.frame = CGRectMake(0, height, frame.size.width, frame.size.height-self.itemImageView.frame.size.height);
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat width = frame.size.height*0.7;
    CGFloat height = width;
    self.itemImageView.frame = CGRectMake((frame.size.width-width)/2, 0, width, height);
    self.itemLabel.frame = CGRectMake(0, height, frame.size.width, frame.size.height-self.itemImageView.frame.size.height);
}
@end
