//
//  SegmentPageTableView.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/24.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentPageTableView.h"

@interface SegmentPageTableView ()
@property (nonatomic, readwrite, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, readwrite, strong) EGORefreshTableFooterView *refreshFooterView;
//@property (nonatomic, readwrite, assign) BOOL refresh;
@end

@implementation SegmentPageTableView
@synthesize refreshHeaderView;
@synthesize refreshFooterView;
@synthesize reloading;
@synthesize refresh;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]) {
        [self createRefreshHeaderView];
        [self setTheRefreshFooterView];
        
        self.refresh = YES;
    }
    
    return self;
}

- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
    [self setTheRefreshFooterView];
}

- (void)reloadData {
    [super reloadData];
    [self setTheRefreshFooterView];
}

- (void)setRefreshViewDelegate:(id<EGORefreshTableDelegate>)aDelegate {
    self.refreshHeaderView.delegate = aDelegate;
    self.refreshFooterView.delegate = aDelegate;
}

- (void)createRefreshHeaderView{
    if(self.refreshHeaderView && [self.refreshHeaderView superview]) {
        [self.refreshHeaderView removeFromSuperview];
    }
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] init];
    self.refreshHeaderView.frame = CGRectMake(0.0f,
                                              0.0f - self.bounds.size.height,
                                              self.frame.size.width,
                                              self.bounds.size.height);
    self.refreshHeaderView.delegate = (id)self.delegate;
    [self addSubview:self.refreshHeaderView];
    
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)removeRefreshHeaderView {
    if(self.refreshHeaderView && self.refreshHeaderView.superview)
        [self.refreshHeaderView removeFromSuperview];
    
    self.refreshHeaderView = nil;
}

- (void)createRefreshFooterView {
    //    UIEdgeInsets test = superView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    
    self.refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height)];
    self.refreshFooterView.delegate = (id)self.delegate;
    [self addSubview:self.refreshFooterView];
    if (self.refreshFooterView) {
        [self.refreshFooterView refreshLastUpdatedDate];
    }
}

- (void)removeTheRefreshFooter {
    if(self.refreshFooterView && [self.refreshFooterView superview]) {
        [self.refreshFooterView removeFromSuperview];
    }
    
    self.refreshFooterView = nil;
}

- (void)setTheRefreshFooterView {
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (self.refreshFooterView && [self.refreshFooterView superview]) {
        // reset position
        self.refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self.frame.size.width,
                                                  self.bounds.size.height);
    }
    else {
        // create the footerView
        [self createRefreshFooterView];
    }
}

- (void)beginReloadingData:(UIScrollView *)targetView {
    self.reloading = YES;
    
    [self performSelector:@selector(finishedLoadData:) withObject:targetView afterDelay:10.0f];
}

- (void)finishReloadingData:(UIScrollView *)targetView{
    self.reloading = NO;
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedLoadData:) object:targetView];
    
    if(self.refreshHeaderView)
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:targetView];
    if(self.refreshFooterView) {
        [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:targetView];
        [self setTheRefreshFooterView];
    }
}

- (void)finishedLoadData:(UIScrollView *)targetView {
    [self finishReloadingData:targetView];
    [self setTheRefreshFooterView];
}
@end
