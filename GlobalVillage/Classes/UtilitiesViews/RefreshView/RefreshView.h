//
//  RefreshView.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/25.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "RefreshCollectionView.h"

typedef NS_ENUM(NSInteger, RefreshViewStyle) {
    kRefreshViewStyleNone = 0,
    kRefreshViewStyleDefault = 1,
    kRefreshViewStyleTableView = kRefreshViewStyleDefault,
    kRefreshViewStyleCollection
};

@protocol RefreshDelegate <NSObject>
- (void)beginReloadingDataWithRefreshMode:(RefreshMode)refreshMode object:(id)object;
@end

@interface RefreshView : UIView
@property (nonatomic, readonly, strong) UIView *refreshTargetView;
@property (nonatomic, readwrite, assign) RefreshViewStyle style;
@property (nonatomic, readwrite, weak) id<RefreshDelegate>refreshDelegate;

@property (nonatomic, readwrite, weak) UIView *headerView;

- (instancetype)initWithStyle:(RefreshViewStyle)aStyle;
- (instancetype)initWithFrame:(CGRect)frame withStyle:(RefreshViewStyle)aStyle;

- (void)collectionRegisterClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)collectionRegisterClass:(Class)viewClass withReuseIdentifier:(NSString *)identifier;
- (void)collectionRegisterClass:(Class)viewClass withKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)setDelegates:(id)delegate;

- (void)beginReloadingData:(EGORefreshPos)arefreshPos;
- (void)finishedReloadingData;

- (void)reloadTableViewData;
- (void)reloadCollectionViewData;
@end
