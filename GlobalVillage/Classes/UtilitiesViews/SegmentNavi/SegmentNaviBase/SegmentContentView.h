//
//  SegmentContentView.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentBar.h"

@interface SegmentContentView : UIView
@property (nonatomic, readonly, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cellDataSource;
@property (nonatomic, weak) id<SegmentDelegate> swipeDelegate;

- (void)reloadData;
- (void)selectIndex:(NSInteger)index;
@end
