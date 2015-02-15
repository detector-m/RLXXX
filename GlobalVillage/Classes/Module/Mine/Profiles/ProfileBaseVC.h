//
//  ProfileBaseVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import "ProfileVC.h"

@interface ProfileBaseVC : RLBaseViewController
@property (nonatomic, weak) ProfileVC *superVC;
- (void)clickCommitBtn:(UIBarButtonItem *)item;
@end
