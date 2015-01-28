//
//  SegmentContentView.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentContentView.h"

@interface SegmentContentView () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@end

@implementation SegmentContentView
@synthesize tableView = _tableView;
@synthesize cellDataSource = _cellDataSource;
@synthesize swipeDelegate = _swipeDelegate;

- (void)dealloc {
    self.cellDataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self == nil)
        return nil;
    
    [self loadTableView];
    
    return self;
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = self.frame.size.width;
    self.tableView.pagingEnabled = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:192/256.0 green:192/256.0 blue:192/256.0 alpha:1.0];
    self.tableView.bounces =YES;
    [self addSubview:self.tableView];
}

- (void)reloadData {
    if(self.tableView == nil) {
        [self loadTableView];
        return;
    }
    
    [self.tableView reloadData];
}

#pragma mark Table view methods

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.frame.size.width;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.cellDataSource.count;
    
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell removeFromSuperview];
    cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        UIView *vw = [self.cellDataSource objectAtIndex:[indexPath row]];
        vw.frame = self.bounds;
        [cell.contentView addSubview:vw];
    }
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.swipeDelegate != nil && [self.swipeDelegate respondsToSelector:@selector(contentSelectedIndexChanged:)])
    {
        int index = self.tableView.contentOffset.y / self.frame.size.width;
        [self.swipeDelegate contentSelectedIndexChanged:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint pt = self.tableView.contentOffset;
    [self.swipeDelegate scrollOffsetChanged:pt];
}

-(void)selectIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

@end
