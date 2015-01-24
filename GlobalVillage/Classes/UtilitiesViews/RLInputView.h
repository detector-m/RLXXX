//
//  RLInputView.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RLInputViewStyle) {
    kRLInputViewStyleTextField,
    kRLInputViewStyleTextView,
};

@interface RLInputView : UIView
@property (nonatomic, readonly, strong) UILabel *title;
@property (nonatomic, readonly, assign) RLInputViewStyle inputViewStyle;

@property (nonatomic, readonly, strong) UIView *textInputView;

- (instancetype)initWithInputViewStyle:(RLInputViewStyle)style andFrame:(CGRect)frame;
@end
