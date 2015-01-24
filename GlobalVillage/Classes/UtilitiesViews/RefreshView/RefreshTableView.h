//
//  RefreshTableView.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/25.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#define kDefaultDismissRefreshViewTime 10.0f

@protocol EGORefreshTableDelegate;
typedef NS_ENUM(UInt8, RefreshMode) {
    kRefreshModeNone = 0,
    kRefreshModeRefresh = 1,
    kRefreshModeLoadMore = 2,
};

@interface RefreshTableView : UITableView
@property (nonatomic, readonly, strong) EGORefreshTableHeaderView *refreshHeader;
@property (nonatomic, readonly, strong) EGORefreshTableFooterView *refreshFooter;

@property (nonatomic, readonly, assign) BOOL reloading;

@property (nonatomic, readwrite, assign) RefreshMode refreshMode;

@property (nonatomic, readwrite, weak) id<EGORefreshTableDelegate> refreshDelegate;

- (void)beginReloadingData:(UIView *)targetView;
- (void)finishReloadingData:(UIView *)targetView;
- (void)finishedReloadingData:(UIView *)targetView;

@property (nonatomic, readwrite, strong) UIView *headerView;

@end
