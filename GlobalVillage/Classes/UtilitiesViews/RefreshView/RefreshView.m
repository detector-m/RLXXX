//
//  RefreshView.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/25.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "RefreshView.h"

@interface RefreshView () <EGORefreshTableDelegate>
@property (nonatomic, readwrite, strong) UIView *refreshTargetView;
@end

@implementation RefreshView
@synthesize refreshTargetView = _refreshTargetView;
@synthesize style = _style;
@synthesize refreshDelegate = _refreshDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame]) {
        self.refreshTargetView = [[RefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self addSubview:self.refreshTargetView];
        self.style = kRefreshViewStyleTableView;
    }

    return self;
}

- (instancetype)initWithStyle:(RefreshViewStyle)aStyle {
    if(self=[super init]) {
        self.style = aStyle;
        if(aStyle == kRefreshViewStyleCollection) {
            self.refreshTargetView = [self defaultCollectionView];
        }
        else {
            self.refreshTargetView = [[RefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        }
        
        [self addSubview:self.refreshTargetView];

    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withStyle:(RefreshViewStyle)aStyle {
    if(self=[super initWithFrame:frame]) {
        self.style = aStyle;
        
        if(aStyle == kRefreshViewStyleCollection) {
            self.refreshTargetView = [self defaultCollectionView];
            self.refreshTargetView.frame = frame;
        }
        else {
            self.refreshTargetView = [[RefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        }
        
        [self addSubview:self.refreshTargetView];
    }
    
    return self;
}

- (RefreshCollectionView *)defaultCollectionView {
    RefreshCollectionView *aCollectionView = nil;
    UICollectionViewFlowLayout *aCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    aCollectionView = [[RefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aCollectionViewFlowLayout];
    
    aCollectionView.backgroundColor = [UIColor whiteColor];
    
    return aCollectionView;
}

- (void)collectionRegisterClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    if(self.style != kRefreshViewStyleCollection)
        return;
    
    RefreshCollectionView *tmpView = (RefreshCollectionView *)self.refreshTargetView;
    [tmpView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)collectionRegisterClass:(Class)viewClass withReuseIdentifier:(NSString *)identifier {
    if(self.style != kRefreshViewStyleCollection)
        return;
    
    RefreshCollectionView *tmpView = (RefreshCollectionView *)self.refreshTargetView;
    [tmpView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)collectionRegisterClass:(Class)viewClass withKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    if(self.style != kRefreshViewStyleCollection)
        return;
    
    RefreshCollectionView *tmpView = (RefreshCollectionView *)self.refreshTargetView;
    [tmpView registerClass:viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.refreshTargetView.frame = frame;
}

- (void)setDelegates:(id)delegate {
    if(self.style == kRefreshViewStyleCollection) {
        RefreshCollectionView *temp = (RefreshCollectionView *)self.refreshTargetView;
        temp.delegate = delegate;
        temp.dataSource = delegate;
        temp.refreshDelegate = (id)self;
    }
    else {
        RefreshTableView *temp = (RefreshTableView *)self.refreshTargetView;
        temp.delegate = delegate;
        temp.dataSource = delegate;
        temp.refreshDelegate = (id)self;
    }
    
    _refreshDelegate = (id)delegate;
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos view:(UIView *)targetView {
    if(self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginReloadingDataWithRefreshMode:object:)]) {
        RefreshMode mode = aRefreshPos ? kRefreshModeLoadMore : kRefreshModeRefresh;
        
        if(self.style == kRefreshViewStyleCollection) {
            [(RefreshCollectionView *)self.refreshTargetView setRefreshMode:mode];
        }
        else {
            [(RefreshTableView *)self.refreshTargetView setRefreshMode:mode];
        }
        
        [self.refreshDelegate beginReloadingDataWithRefreshMode:mode object:self.refreshTargetView];
    }
    [self beginReloadingData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    if(self.style == kRefreshViewStyleCollection) {
        return ((RefreshCollectionView *)self.refreshTargetView).reloading;
    }
    else {
        return ((RefreshTableView *)self.refreshTargetView).reloading;
    }
}

- (void)beginReloadingData:(EGORefreshPos)arefreshPos {
    
    if(self.style == kRefreshViewStyleCollection) {
        [(RefreshCollectionView *)self.refreshTargetView beginReloadingData:self.refreshTargetView];
    }
    else {
        [(RefreshTableView *)self.refreshTargetView beginReloadingData:self.refreshTargetView];
    }
}

- (void)finishedReloadingData {
    if(self.style == kRefreshViewStyleCollection) {
        [(RefreshCollectionView *)self.refreshTargetView finishedReloadingData:self.refreshTargetView];
    }
    else {
        [(RefreshTableView *)self.refreshTargetView finishedReloadingData:self.refreshTargetView];
    }
}

- (void)reloadTableViewData {
    if(self.style == kRefreshViewStyleTableView) {
        [(RefreshTableView *)self.refreshTargetView reloadData];
    }
}

- (void)reloadCollectionViewData {
    if(self.style == kRefreshViewStyleCollection) {
        [(RefreshCollectionView *)self.refreshTargetView reloadData];
    }
}
@end
