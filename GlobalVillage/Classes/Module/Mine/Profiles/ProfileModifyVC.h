//
//  ProfileModifyVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileBaseVC.h"
#import "RLInputView.h"

@interface ProfileModifyVC : ProfileBaseVC
@property (nonatomic, readonly, strong) RLInputView *modifyInputView;
@property (nonatomic, assign) NSInteger type;
- (instancetype)initWithStyle:(RLInputViewStyle)style;
@end
