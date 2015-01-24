//
//  RLRadioButton.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLRadioButton.h"
@interface RLRadioButton ()
@property (nonatomic, readwrite, strong) UIButton *button;
@property (nonatomic, readwrite, strong) UILabel *label;

@property (nonatomic, readwrite, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation RLRadioButton
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat widthOffset = 5;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.style = kRLRadioButtonStyleLabelRight;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(widthOffset, 0, frame.size.height, frame.size.height);
        [self addSubview:self.button];
        
        widthOffset += self.button.frame.size.width+5;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(widthOffset, 0, frame.size.width-widthOffset, frame.size.height)];
        self.label.font = [UIFont systemFontOfSize:16];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.shadowColor = [UIColor grayColor];
//        self.label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:self.label];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        self.tapGesture.numberOfTapsRequired = 1;
        self.tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:self.tapGesture];
    }
    
    return self;
}

- (void)setStyle:(RLRadioButtonStyle)style {
    if(_style == style)
        return;
    _style = style;
    
    CGFloat widthOffset = 5;
    CGRect frame = self.frame;
    if(style == kRLRadioButtonStyleLabelLeft) {
        self.button.frame = CGRectMake(widthOffset, 0, frame.size.height, frame.size.height);
        
        widthOffset += self.button.frame.size.width+5;
        self.label.frame = CGRectMake(widthOffset, 0, frame.size.height-10-frame.size.width-self.button.frame.size.width, frame.size.height);
    }
    else if(style == kRLRadioButtonStyleLabelRight) {
        widthOffset = frame.size.height-5-frame.size.height;
        self.button.frame = CGRectMake(widthOffset, 0, frame.size.height, frame.size.height);

        widthOffset = 5;
        self.label.frame = CGRectMake(widthOffset, 0, frame.size.height-10-frame.size.width-self.button.frame.size.width, frame.size.height);
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    if(target == nil || action == NULL)
        return;
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.tapGesture addTarget:target action:action];
}
@end
