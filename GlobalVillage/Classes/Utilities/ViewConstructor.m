//
//  ViewConstructor.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ViewConstructor.h"

@interface ViewConstructor ()
+ (UIView *)constructViewWithClass:(Class)theClass withFrame:(CGRect)frame;
@end

@implementation ViewConstructor
+ (UIView *)constructViewWithClass:(Class)theClass withFrame:(CGRect)frame {
    if(theClass == nil)
        theClass = [UIView class];
    
    UIView *v = [[theClass alloc] initWithFrame:frame];
    
    return v;
}

+ (UILabel *)constructDefaultLabel:(Class)theClass withFrame:(CGRect)frame {
    if(theClass == nil)
        theClass = [UILabel class];
    
    UILabel *label = (UILabel *)[[self class] constructViewWithClass:theClass withFrame:frame];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    return label;
}
+ (UIButton *)constructDefaultButton:(Class)theClass withFrame:(CGRect)frame {
    if(theClass == nil)
        theClass = [UILabel class];
    
    UIButton *button = (UIButton *)[[self class] constructViewWithClass:theClass withFrame:frame];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.cornerRadius = 6.0f;
    button.layer.borderWidth = 0.5f;
    button.layer.masksToBounds = YES;
    
    return button;
}
+ (UITextField *)constructDefaultTextField:(Class)theClass withFrame:(CGRect)frame {
    if(theClass == nil)
        theClass = [UITextField class];
    
    UITextField *textField = (UITextField *)[[self class] constructViewWithClass:theClass withFrame:frame];
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    return textField;
}
@end
