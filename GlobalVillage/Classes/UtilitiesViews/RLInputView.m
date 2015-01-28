//
//  RLInputView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLInputView.h"

@interface RLInputView ()
@property (nonatomic, readwrite, strong) UILabel *title;
@property (nonatomic, readwrite, assign) RLInputViewStyle inputViewStyle;
@property (nonatomic, readwrite, strong) UIView *textInputView;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation RLInputView
- (instancetype)initWithInputViewStyle:(RLInputViewStyle)style andFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.inputViewStyle = style;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, frame.size.width*0.3-2, frame.size.height-2)];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];
        
        CGFloat widthOffset = self.title.frame.origin.x + self.title.frame.size.width + 1;
        if(style == kRLInputViewStyleTextField) {
            UITextField *tmp ;
            self.textInputView = [[UITextField alloc] initWithFrame:CGRectMake(widthOffset, 1, frame.size.width*0.7-2, frame.size.height-2)];
            tmp = (UITextField *)self.textInputView;
            tmp.clearButtonMode = UITextFieldViewModeAlways;
            
            tmp.font = [UIFont systemFontOfSize:16];
        }
        else {
            self.textInputView = [[UITextView alloc] initWithFrame:CGRectMake(widthOffset, 1, frame.size.width*0.7-2, frame.size.height-2)];
        }
        [self addSubview:self.textInputView];
        self.textInputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textInputView.layer.cornerRadius = 6.0f;
        self.textInputView.layer.borderWidth = 0.5f;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self addGestureRecognizer:self.tapGesture];
    }
    
    return self;
}

- (void)tapGestureAction {
    [self.superview endEditing:YES];
}
@end
