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
        self.subtitle.text = NSLocalizedString(@"点击取消订阅", nil);
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont systemFontOfSize:12];
        self.subtitle.textColor = [UIColor lightGrayColor];
        [self addSubview:self.subtitle];
        
        self.editButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(frame.size.width-95, 5, 80, frame.size.height-10)];
        [self.editButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
        [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.editButton.layer.borderColor = [UIColor colorWithRed:51/255.0 green:136/255.0 blue:255/255.0 alpha:1].CGColor;
//        self.editButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:204/255.0 alpha:1];
        [self.editButton setTintColor:[UIColor colorWithRed:204/255.0 green:195/255.0 blue:48/255.0 alpha:1]];
        [self.editButton setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        
        [self addSubview:self.editButton];
        
    }
    
    return self;
}
@end
