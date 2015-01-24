//
//  RLButton.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLButton.h"

@implementation RLButton

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 6.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)clearBorder {
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.f;
}
@end
