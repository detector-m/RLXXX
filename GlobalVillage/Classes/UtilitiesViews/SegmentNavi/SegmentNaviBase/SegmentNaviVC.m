//
//  SegmentNaviVC.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentNaviVC.h"
#import "SegmentBar.h"
#import "SegmentContentsView.h"
#import "UIViewController+Expand.h"

@interface SegmentNaviVC () <SegmentBarDelegate>
//@property (nonatomic, strong) SegmentContentsView *contentTable;
// --------
@property (nonatomic, readwrite, assign) NSInteger currentIndex;

@property (nonatomic, strong) SegmentBar *segmentBar;
@property (nonatomic, strong) SegmentsTableView *segmentsTableView;
@end

@implementation SegmentNaviVC
@synthesize currentIndex = _currentIndex;
@synthesize segmentBar = _segmentBar;
@synthesize barViewWidth = _barViewWidth;
@synthesize segmentNaviDelegate = _segmentNaviDelegate;

- (void)dealloc {
    [self.segments removeAllObjects], self.segments = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)resizeFrame {
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect frame = self.view.frame;
    
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navigationFrame = self.navigationController.navigationBarHidden ? CGRectZero : self.navigationController.navigationBar.bounds;
    CGRect tabBarFrame = self.tabBarController.tabBar.hidden ? CGRectZero : self.tabBarController.tabBar.frame;
    
//    CGRect frame = self.view.frame;
    CGFloat height = frame.size.height - (navigationFrame.size.height +
                                          statusFrame.size.height +
                                          tabBarFrame.size.height);
    CGFloat originY = self.navigationController.navigationBarHidden ? statusFrame.size.height : 0;
    if(self.navigationController == nil)
        originY = statusFrame.size.height;
//    else if(!self.navigationController.navigationBarHidden) {
//        height += navigationFrame.size.height + statusFrame.size.height;
//    }
    frame = CGRectMake(frame.origin.x, frame.origin.y + originY, frame.size.width, height);
    self.view.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resizeFrame];
    
    if(self.barViewWidth == 0) {
        self.barViewWidth = self.view.frame.size.width;
    }
    [self performSelectorOnMainThread:@selector(subviewsDoLoad) withObject:nil waitUntilDone: YES];
}

- (void)subviewsDoLoad {
//    if(self.segmentBar == nil) {
//        self.segmentBar = [[SegmentBar alloc] initWithFrame:CGRectMake(0, 0, self.barViewWidth, kBarHeight)];
////        self.segmentBar.frame = CGRectMake(0, 0, self.barViewWidth, kBarHeight);
//        self.segmentBar.titleArray = self.titleArray;
//        [self.view addSubview:self.segmentBar];
//        self.segmentBar.segmentDelegate = self;
//        [self.segmentBar reloadSubViews];
//    }
    
//    if(self.contentTable == nil) {
//        self.contentTable = [[SegmentContentsView alloc] initWithFrame:CGRectMake(0,  kBarHeight, self.view.frame.size.width, self.view.frame.size.height - kBarHeight)];
//        self.contentTable.cellDataSource = self.contentArray;
//        self.contentTable.swipeDelegate = self;
//        [self.view addSubview:self.contentTable];
//        self.currentIndex = 0;
//    }
    
    //-----------------
    if(self.segmentBar == nil) {
        self.segmentBar = [[SegmentBar alloc] initWithFrame:CGRectMake(0, 1, self.barViewWidth, kBarHeight)];
        self.segmentBar.dataSource = self;
        self.segmentBar.segmentDelegate = self;
        [self.view addSubview:self.segmentBar];
    }
    
    if(self.segmentsTableView == nil) {
        self.segmentsTableView = [[SegmentsTableView alloc] initWithFrame:CGRectMake(0,  kBarHeight+1, self.view.frame.size.width, self.view.frame.size.height - kBarHeight-1)];
        self.segmentsTableView.dataSource = self;
        self.segmentsTableView.delegate = self;
        [self.view addSubview:self.segmentsTableView];
    }
    
//    [self reloadData];
    self.currentIndex = 0;
}


//------------------
- (void)setBarViewWidth:(CGFloat)barViewWidth {
    if(barViewWidth == 0.0f || self.segmentBar.frame.size.width == barViewWidth)
        return;
    _barViewWidth = barViewWidth;
    if(self.segmentBar == nil)
        return;
    self.segmentBar.frame = CGRectMake(0, 0, _barViewWidth, self.segmentBar.frame.size.height);
//    [self.segmentBar reloadSubViews];
}

- (NSInteger)segmentsShowCount:(NSArray *)segments {
    NSInteger count = 0;
    for(Segment *segment in self.segments) {
        if(segment.segmentMode == kSegmentModeShow) {
            count++;
        }
    }

    return count;
}

- (Segment *)segmentShow:(NSArray *)segments index:(NSInteger)index {
    NSInteger count = 0;
    for(Segment *inSegment in self.segments) {
        if(inSegment.segmentMode == kSegmentModeShow) {
            if(count == index) {
                return inSegment;
                
            }
            count++;
        }
    }
    
    return nil;
}

#pragma mark SegmentBarDelegate datasource
- (NSInteger)itemViewsNumberOfSegmentBar:(SegmentBar *)segmentBar {

    return [self segmentsShowCount:self.segments];
//    return self.segments.count;
}

- (CGFloat)itemWidthOfSegmentBar:(SegmentBar *)segmentBar forIndex:(NSInteger)index {
    NSInteger count = [self segmentsShowCount:self.segments];
    CGFloat contentWidth = count *  80.0;
    if(contentWidth > segmentBar.frame.size.width)
        return 80;
    else {
        return segmentBar.frame.size.width/count;
    }
}

- (SegmentItemView *)itemView:(SegmentBar *)sgementBar forIndex:(NSInteger)index {
    SegmentItemView *item = nil;
    if((item = [sgementBar dequeueReusableItemView]) == nil) {
        item = (SegmentItemView *)[ViewConstructor constructDefaultButton:[SegmentItemView class] withFrame:CGRectZero];
    }
    
    Segment *segment = [self segmentShow:self.segments index:index];
    [item setTitle:segment.item.title forState:UIControlStateNormal];
    item.titleLabel.font = [UIFont systemFontOfSize:20];
    item.layer.borderWidth = 0;
    item.delegate = self.segmentBar;
    
    return item;
}

-(void)segmentBarSelectedIndexChanged:(NSInteger)newIndex {
    if (newIndex >= 0) {
        if(self.segmentNaviDelegate && [self.segmentNaviDelegate respondsToSelector:@selector(segmentNaviWillChange:)]) {
            [self.segmentNaviDelegate segmentNaviWillChange:self.currentIndex];
        }
        self.currentIndex = newIndex;
//        self.title = [self.titleArray objectAtIndex:newIndex];
//        [self.contentTable selectIndex:newIndex];
        [self selectIndex:newIndex];
        
        if(self.segmentNaviDelegate && [self.segmentNaviDelegate respondsToSelector:@selector(segmentNaviChange:)]) {
            [self.segmentNaviDelegate segmentNaviChange:newIndex];
        }
    }
}

-(void)contentSelectedIndexChanged:(NSInteger)newIndex {
    [self.segmentBar selectIndex:newIndex];
}

-(void)scrollOffsetChanged:(CGPoint)offset {
    NSInteger page = (NSInteger)offset.y / self.view.frame.size.width ;
    CGFloat radio = (CGFloat)((NSInteger)offset.y%(NSInteger)self.view.frame.size.width)/self.view.frame.size.width;
    [self.segmentBar setLineOffsetWithPage:page andRatio:radio];
}

#pragma mark Table view methods
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.frame.size.width;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self segmentsShowCount:self.segments];
//    NSInteger rowCount = self.segments.count;
//    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    }

    Segment *segment = [self segmentShow:self.segments index:indexPath.row];
//    Segment *segment = [self.segments objectAtIndex:[indexPath row]];
    UIView *vw = segment.content.view;
    vw.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height);
    [cell.contentView addSubview:vw];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.segmentsTableView.contentOffset.y / self.segmentsTableView.frame.size.width;
    [self contentSelectedIndexChanged:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint pt = self.segmentsTableView.contentOffset;
    [self scrollOffsetChanged:pt];
}

-(void)selectIndex:(NSInteger)index
{
    if(self.segments.count == 0)
        return;
    [self.segmentsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)reloadData {
//    self.currentIndex = 0;
//    [self.segmentBar selectIndex:0];
    [self.segmentBar reloadData];
    [self.segmentsTableView reloadData];
}
@end
