//
//  NewsVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsVC.h"
#import "SegmentNaviVC.h"
#import "SegmentPageTableViewCell.h"
#import "RefreshView.h"
#import "RLColor.h"

#import "NewsDetailVC.h"

#import "UIImageView+WebCache.h"

#import "NewsController.h"

#define kDefaultPageSize 10

@interface NewsVC () <NewsControllerDelegate, SegmentNaviDelegate, RefreshDelegate>
@property (nonatomic, readwrite, strong) SegmentNaviVC *segmentVC;

@property (nonatomic, readwrite, strong) NSMutableArray *segmentTitles;
@property (nonatomic, readwrite, strong) NSMutableArray *segmentContentViews;
@property (nonatomic, readwrite, strong) NSMutableArray *segments Description(NewsSegmentModel);

@property (nonatomic, readwrite, strong) NewsController *controller;
@end

@implementation NewsVC

- (void)dealloc {
    [self dataDoClear];
}

- (void)dataDoClear {
    self.controller.delegate = nil;
    self.controller = nil;
    
    [self.segmentTitles removeAllObjects], self.segmentTitles = nil;
    [self.segmentContentViews removeAllObjects], self.segmentContentViews = nil;
    [self.segments removeAllObjects], self.segments = nil;
}

- (void)dataDoLoad {
    self.controller = [[NewsController alloc] init];
    self.controller.delegate = self;
    
    self.segmentTitles = [NSMutableArray array];
    self.segmentContentViews = [NSMutableArray array];
    self.segments = [NSMutableArray array];
}

//- (BOOL)navigationShouldPopOnBackButton {
//
//    [self.navigationController popViewControllerAnimated:YES];
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"新闻", nil);
    
    [self dataDoLoad];
    self.controller.accessToken = [User sharedUser].accessToken;
    
    [self.controller newsTypeListRequest:[User sharedUser].accessToken];
}

- (void)segmentNaviVCDoLoad {
    if(self.segmentVC != nil)
        return;
    
    for(NSInteger i=0; i<self.segmentTitles.count; i++) {
        RefreshView *refreshView = [[RefreshView alloc] initWithStyle:kRefreshViewStyleTableView];
        [refreshView setDelegates:self];
        
        ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
        ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = 100;
        ((RefreshTableView *)refreshView.refreshTargetView).tag = kSegmentStartTag+i;
        
        NewsSegmentModel *segment = [self.segments objectAtIndex:i];
        segment.view = refreshView;
        [self.segmentContentViews addObject:refreshView];
    }
    
    self.segmentVC = [[SegmentNaviVC alloc] init];
    self.segmentVC.titleArray = self.segmentTitles;
    self.segmentVC.contentArray = self.segmentContentViews;
    self.segmentVC.segmentNaviDelegate = self;
    
    [self addChildViewController:self.segmentVC];
    [self.view addSubview:self.segmentVC.view];
}

- (NewsSegmentModel *)segmentWithIndex:(NSInteger)index {
    return [self.segments objectAtIndex:index];
}

- (NewsModel *)newsWithIndex:(NSInteger)index andRow:(NSInteger)row {
    return [[self segmentWithIndex:index].contents objectAtIndex:row];
}

#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfRows:(NSInteger)tag {
    NSInteger num = 0;
    NSInteger index = tag-kSegmentStartTag;

    num = [self segmentWithIndex:index].contents.count;
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRow = [self numberOfRows:tableView.tag];
//    if(numOfRow * tableView.rowHeight < self.view.frame.size.height) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    else {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }
    
    if(numOfRow == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return numOfRow;
}

- (NewsModel *)getNewsWithTag:(NSInteger)tag andRow:(NSInteger)row {
    NSInteger index = tag-kSegmentStartTag;
    
    return [self newsWithIndex:index andRow:row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *news = [self getNewsWithTag:tableView.tag andRow:indexPath.row];
    SegmentPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier]; //[tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];//
    
    if(cell == nil) {
        cell = [[SegmentPageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableCellIdentifier];
        
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.numberOfLines = 4;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        cell.imageView.contentMode  = UIViewContentModeScaleAspectFit;
        cell.imageView.layer.cornerRadius = 5;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = news.abstract;
    
//    cell.autoresizesSubviews = YES;
//    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsMake(2, 3, 2, 3);
    }

    if(news.hasRead) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    NSURL *imageUrl = [NSURL URLWithString:news.picUrl];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"qq_icon.png"] options:SDWebImageProgressiveDownload];

    return cell;
}

- (void)deselectRow:(UITableView *)tableView
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    
    NSInteger index = tableView.tag - kSegmentStartTag;//self.segmentVC.currentIndex;
    NewsModel *news = [self newsWithIndex:index andRow:indexPath.row];
    NewsDetailVC *vc = [[NewsDetailVC alloc] init];
    vc.newsUrl = news.detailUrl;
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    news.hasRead = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(news.hasRead) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
//    if(news.hasRead) {
//        //R64G64B255
//        [self setCellAllSubViewsBGColor:[RLColor colorWithRed:64 green:64 blue:255 alpha:155] withCell:cell];
//    }
//    else {
//        [self setCellAllSubViewsBGColor:[UIColor clearColor] withCell:cell];
//    }
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

- (void)setCellAllSubViewsBGColor:(UIColor *)color withCell:(UITableViewCell *)cell {
    for(UIView *view in cell.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    cell.backgroundColor = color;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(![scrollView isKindOfClass:[RefreshTableView class]]) {
        return;
    }
    RefreshTableView *tableView = (RefreshTableView *)scrollView;
    
    
    if (tableView.refreshHeader) {
        [tableView.refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (tableView.refreshFooter) {
        [tableView.refreshFooter egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(![scrollView isKindOfClass:[RefreshTableView class]]) {
        return;
    }
    RefreshTableView *tableView = (RefreshTableView *)scrollView;
    
    if (tableView.refreshHeader) {
        [tableView.refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (tableView.refreshFooter) {
        [tableView.refreshFooter egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)beginReloadingDataWithRefreshMode:(RefreshMode)refreshMode object:(id)object {
    NSInteger index = ((RefreshTableView *)object).tag - kSegmentStartTag;
    NewsSegmentModel *segment = [self segmentWithIndex:index];
    NewsTypeModel *newsType = segment.titleItem;

    if(refreshMode == kRefreshModeRefresh) {
        segment.needRefresh = YES;
        [self.controller newsListRequest:newsType.ID currentCount:0 pageCount:kDefaultPageSize token:nil subtag:index];
    }
    else {
        segment.needRefresh = NO;
        [self.controller newsListRequest:newsType.ID currentCount:segment.contents.count pageCount:kDefaultPageSize token:nil subtag:index];
    }
}

- (void)segmentNaviChange:(NSInteger)newIndex {
    if(newIndex < 0)
        return;
    
    NewsSegmentModel *segment = [self segmentWithIndex:newIndex];
    NewsTypeModel *typeItem = segment.titleItem;
    if(segment.contents.count == 0) {
        [self.controller newsListRequest:typeItem.ID currentCount:0 pageCount:kDefaultPageSize token:nil subtag:newIndex];
    }
}

//显示新闻
- (void)reloadTableView:(UITableView *)tableView {
    [tableView reloadData];
}

- (void)reloadViewsWithTag:(NSInteger)tag{
    __weak NewsVC *blockSelf = self;
    NSInteger index = tag;
    void(^block)(void) = ^{
        
        RefreshView *refreshView = (RefreshView *)[blockSelf.segmentContentViews objectAtIndex:index];
        if(refreshView.refreshDelegate == blockSelf && ((RefreshTableView *)refreshView.refreshTargetView).reloading == YES) {
            [refreshView finishedReloadingData];
        }
        [blockSelf reloadTableView:((RefreshTableView *)refreshView.refreshTargetView)];
    };
    
    [self mainThreadAsync:block];
}

#pragma mark - data
- (void)newsTypeListParser:(NSArray *)typeList Description(NewsSegmentModel) {
    if(typeList.count == 0)
        return;
    
    for(NewsSegmentModel *segmentModel in typeList) {
        [self.segmentTitles addObject:segmentModel.title];
    }
    [self.segments addObjectsFromArray:typeList];
    
    NewsTypeModel *newsType = [self segmentWithIndex:0].titleItem;
    [self.controller newsListRequest:newsType.ID currentCount:0 pageCount:kDefaultPageSize token:nil subtag:self.segmentVC.currentIndex];
}

- (void)newsListParser:(NSArray *)newsList segmentIndex:(NSInteger)index {
    if(newsList.count == 0)
        return;
    
    NewsSegmentModel *segment = [self segmentWithIndex:index];
    if(segment.needRefresh) {
        [segment.contents removeAllObjects];
        segment.needRefresh = NO;
    }
    [segment.contents addObjectsFromArray:newsList];
}

#pragma mark - NewsControllerDelegate
- (void)newsTypeListResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"获取新闻类型列表失败！", nil)];
        };
    }
    else {
        [self newsTypeListParser:response.responseData];
        __weak NewsVC *blockSelf = self;
        block = ^(){
            [blockSelf segmentNaviVCDoLoad];
        };
    }
    
    [self mainThreadAsync:block];
}

- (void)newsListResponse:(GVResponse *)response subtag:(NSInteger)subtag {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"获取新闻列表失败！", nil)];
        };
    }
    else {
        [self newsListParser:response.responseData segmentIndex:subtag];
        __weak NewsVC *blockSelf = self;
        block = ^(){
            [blockSelf reloadViewsWithTag:subtag];
        };
    }
    
    [self mainThreadAsync:block];
}

@end
