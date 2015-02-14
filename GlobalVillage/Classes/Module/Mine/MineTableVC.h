//
//  MineTableVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableViewController.h"
#import "RLTableModel.h"

@interface MineTableVC : RLTableViewController
@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) RLTableModel *tableModel;

- (void)dataDoLoad;
- (void)dataDoClean;
@end
