//
//  DQNumberCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DQNumberCell.h"

@interface DQNumberCell ()
@property (nonatomic, readwrite, strong) UILabel *textLabel;
@property (nonatomic, readwrite, strong) UILabel *subTextLabel;
@end

@implementation DQNumberCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self textLabelDoLoad];
        [self subTextLabelDoLoad];
        [self selectedBgView];
    }
    
    return self;
}

- (void)selectedBgView {
    UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBGView.backgroundColor = [UIColor brownColor];
    self.selectedBackgroundView = selectedBGView;
}

- (void)textLabelDoLoad {
    CGRect frame = self.frame;
    frame.origin.x = 2.0f;
    frame.origin.y = 0.0f;
    frame.size.width = frame.size.width*0.7-2.0f;
    
    self.textLabel = [self constructLabelWithFrame:frame];
    
    [self addSubview:self.textLabel];
}

- (void)subTextLabelDoLoad {
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width*0.7;
    frame.origin.y = 0;
    frame.size.width = frame.size.width*3;
    
    self.subTextLabel = [self constructLabelWithFrame:frame];
    
    [self addSubview:self.subTextLabel];
}

- (UILabel *)constructLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}
@end
