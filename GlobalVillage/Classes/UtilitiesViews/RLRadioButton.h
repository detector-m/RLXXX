//
//  RLRadioButton.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RLRadioButtonStyle) {
    kRLRadioButtonStyleLabelRight,
    kRLRadioButtonStyleLabelLeft,
};

@interface RLRadioButton : UIView
@property (nonatomic, readonly, strong) UIButton *button;
@property (nonatomic, readonly, strong) UILabel *label;

@property (nonatomic, readwrite, assign) RLRadioButtonStyle style;

- (void)addTarget:(id)target action:(SEL)action;
@end
