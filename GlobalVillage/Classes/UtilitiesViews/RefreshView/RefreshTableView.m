//
//  RefreshTableView.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/25.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "RefreshTableView.h"

@interface RefreshTableView ()
@property (nonatomic, readwrite, strong) EGORefreshTableHeaderView *refreshHeader;
@property (nonatomic, readwrite, strong) EGORefreshTableFooterView *refreshFooter;

@property (nonatomic, readwrite, assign) BOOL reloading;

//@property (nonatomic, readwrite, assign) RefreshMode refreshMode;
@end

@implementation RefreshTableView
@synthesize refreshHeader = _refreshHeader;
@synthesize refreshFooter = _refreshFooter;
@synthesize reloading = _reloading;
@synthesize refreshMode = _refreshMode;

@synthesize refreshDelegate = _refreshDelegate;

//haderView
@synthesize headerView = _headerView;


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]) {
    }
    self.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
    return self;
}

- (void)setFrame:(CGRect)frame {
    if(CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    [super setFrame:frame];
//    if(CGRectEqualToRect(frame, CGRectZero)) {
//        return;
//    }
    if(!self.refreshHeader) {
        [self createRefreshHeader];
    }
}

- (void)reloadData {
    [super reloadData];
    
    if(self.contentSize.height > self.frame.size.height) {
        [self moveAndCreateRefreshFooter];
    }
}

- (void)createRefreshHeader {
    if(self.refreshHeader && [self.refreshHeader superview]) {
        [self.refreshHeader removeFromSuperview];
    }

    self.refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                0.0f - self.bounds.size.height,
                self.frame.size.width,
                self.bounds.size.height)];
    self.refreshHeader.delegate = self.refreshDelegate;
    [self addSubview:self.refreshHeader];
    [self.refreshHeader refreshLastUpdatedDate];
}

- (void)removeRefreshHeader {
    if(self.refreshHeader && self.refreshHeader.superview)
        [self.refreshHeader removeFromSuperview];
    
    self.refreshHeader = nil;
}

- (void)createRefreshFooter {
    if(self.frame.size.height == 0 ||
       self.contentSize.height == 0 ||
       self.contentSize.height < self.frame.size.height)
        return;
    
    if(self.refreshFooter)
        return;
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    
    self.refreshFooter = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height)];

    self.refreshFooter.delegate = self.refreshDelegate;
    [self addSubview:self.refreshFooter];
    if (self.refreshFooter) {
        [self.refreshFooter refreshLastUpdatedDate];
    }
}

- (void)removeRefreshFooter {
    if(self.refreshFooter && [self.refreshFooter superview]) {
        [self.refreshFooter removeFromSuperview];
    }
    
    self.refreshFooter = nil;
}

- (void)moveAndCreateRefreshFooter {
    if(self.frame.size.height == 0 || self.contentSize.height == 0 ||
       self.contentSize.height < self.frame.size.height)
        return;
    
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (self.refreshFooter && [self.refreshFooter superview]) {
        // reset position
        self.refreshFooter.frame = CGRectMake(0.0f,
                                                  height,
                                                  self.frame.size.width,
                                                  self.bounds.size.height);
        self.refreshFooter.hidden = NO;
    }
    else {
        [self createRefreshFooter];
    }
}

- (void)setRefreshDelegate:(id<EGORefreshTableDelegate>)refreshDelegate {
    _refreshDelegate = refreshDelegate;
    self.refreshHeader.delegate = refreshDelegate;
    self.refreshFooter.delegate = refreshDelegate;
}

- (void)beginReloadingData:(UIView *)targetView {
    self.reloading = YES;
    [self performSelector:@selector(finishedReloadingData:) withObject:targetView afterDelay:kDefaultDismissRefreshViewTime];
}

- (void)finishReloadingData:(UIView *)targetView{
    self.reloading = NO;
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedReloadingData:) object:targetView];
    
    if(self.refreshHeader)
        [self.refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)targetView];
    if(self.refreshFooter) {
        [self.refreshFooter egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)targetView];
        [self moveAndCreateRefreshFooter];
    }
}

- (void)finishedReloadingData:(UIView *)targetView {
    [self finishReloadingData:targetView];
    [self moveAndCreateRefreshFooter];
}

- (void)setHeaderView:(UIView *)headerView {
    if(_headerView == headerView) {
        return;
    }
    [_headerView removeFromSuperview];
    _headerView = nil;
    _headerView = headerView;
    self.tableHeaderView = _headerView;
}
@end
