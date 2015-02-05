//
//  SingleChannelNewsVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableViewController.h"
#import "NewsTypeModel.h"
#import "NewsCell.h"

@interface SingleChannelNewsVC : RLTableViewController
@property (nonatomic, weak) NewsTypeModel *newsType;
@end
