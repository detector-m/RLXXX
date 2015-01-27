//
//  ChannelsTitleView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChannelsTitleView.h"

@interface ChannelsTitleView ()
@property (nonatomic, readwrite, strong) UILabel *title;
@property (nonatomic, readwrite, strong) UILabel *subtitle;
@property (nonatomic, readwrite, strong) UIButton *editButton;
@end
@implementation ChannelsTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat widthOffset = 10;
        self.title = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(widthOffset, 0, frame.size.width/4, frame.size.height)];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.text = NSLocalizedString(@"我的频道", nil);
        [self addSubview:self.title];
        
        self.subtitle = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(self.title.frame.size.width+1+widthOffset, 5, self.title.frame.size.width, frame.size.height-6)];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont systemFontOfSize:12];
        self.subtitle.textColor = [UIColor lightGrayColor];
        [self addSubview:self.subtitle];
        
        self.editButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(frame.size.width-95, 5, 80, frame.size.height-10)];
        [self.editButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
        [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self addSubview:self.editButton];
        
    }
    
    return self;
}
@end
