//
//  SegmentPageTableView.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/24.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@protocol EGORefreshTableDelegate;

@interface SegmentPageTableView : UITableView
@property (nonatomic, readonly, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, readonly, strong) EGORefreshTableFooterView *refreshFooterView;
@property (atomic, readwrite, assign) BOOL reloading;

@property (nonatomic, readwrite, assign) BOOL refresh;

- (void)setRefreshViewDelegate:(id<EGORefreshTableDelegate>)aDelegate;
- (void)beginReloadingData:(UIScrollView *)targetView;
- (void)finishReloadingData:(UIScrollView *)targetView;
- (void)finishedLoadData:(UIScrollView *)targetView;
@end
