//
//  SocialContactVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/3/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableViewController.h"
#import "RLTableModel.h"

NS_ENUM(NSInteger, SocialContactTag) {
    kSocialContactSession = 0x01,
    kSocialContactFriend,
    kSocialContactCircle,
    kSocialContactAddFriend
};

@interface SocialContactVC : RLTableViewController

@end
