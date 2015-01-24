//
//  ViewConstructor.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLLabel.h"
#import "RLButton.h"
#import "RLTextField.h"

@interface ViewConstructor : NSObject
+ (UILabel *)constructDefaultLabel:(Class)theClass withFrame:(CGRect)frame;
+ (UIButton *)constructDefaultButton:(Class)theClass withFrame:(CGRect)frame;
+ (UITextField *)constructDefaultTextField:(Class)theClass withFrame:(CGRect)frame;
@end
