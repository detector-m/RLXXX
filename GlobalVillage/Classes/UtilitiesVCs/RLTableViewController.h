//
//  RLTableViewController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import "RLConstVariable.h"

@interface RLTableViewController : RLBaseViewController <UITableViewDataSource, UITableViewDelegate>

- (void)deselectRow:(UITableView *)tableView;
@end
