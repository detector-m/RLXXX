//
//  NearbyPersonCell.h
//  GlobalVillage
//
//  Created by RivenL on 15/3/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface NearbyPersonCell : UITableViewCell
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIButton *add;
@end
