//
//  RefreshCollectionView.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/30.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "RefreshTableView.h"

@interface RefreshCollectionView : UICollectionView
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
