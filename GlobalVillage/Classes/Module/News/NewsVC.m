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
#import "RLUtilitiesMethods.h"

#import "NewsDetailVC.h"
#import "NewsChannelsVC.h"

#import "UIImageView+WebCache.h"

#import "NewsController.h"

#define kDefaultPageSize 10

@interface NewsVC () <NewsControllerDelegate, SegmentNaviDelegate, RefreshDelegate>
@property (nonatomic, readwrite, strong) SegmentNaviVC *segmentVC;
@property (nonatomic, readwrite, strong) NSMutableArray *segments Description(NewsSegmentModel);

@property (nonatomic, strong) UIButton *channelsButton;

@property (nonatomic, readwrite, strong) NewsController *controller;
@end

@implementation NewsVC

- (void)dealloc {
    [self dataDoClear];
}

- (void)dataDoClear {
    self.controller.delegate = nil;
    self.controller = nil;
    [self.segments removeAllObjects], self.segments = nil;
}

- (void)dataDoLoad {
    self.controller = [[NewsController alloc] init];
    self.controller.delegate = self;

    self.segments = [NSMutableArray array];
}

- (void)cleanDatas {
    [self.segments removeAllObjects];
    [self.segmentVC.segments removeAllObjects];
}

//- (BOOL)navigationShouldPopOnBackButton {
//
//    [self.navigationController popViewControllerAnimated:YES];
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataDoLoad];
    
    [self navigationTitleButtonDoLoad];
    
    self.controller.accessToken = [User sharedUser].accessToken;
    
    [self.controller newsTypeListRequest:[User sharedUser].accessToken];
}

- (void)navigationTitleButtonDoLoad {
    UIImage *image = [UIImage imageNamed:@"NewsTitle.png"];

    UIButton *button = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    button.layer.borderWidth = 0.0f;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickNavigationTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:button];
}

- (void)clickNavigationTitleBtn:(UIButton *)button {
     [self.controller newsTypeListRequest:[User sharedUser].accessToken];
}

- (void)segmentNaviVCDoLoad {
    if(self.segmentVC != nil) {
        [self segmentNaviDataDoLoad];
        [self.segmentVC reloadData];
        return;
    }
    
//    NSMutableArray *array = [NSMutableArray array];
//    for(NSInteger i=0; i<self.segments.count; i++) {
//        RefreshView *refreshView = [[RefreshView alloc] initWithStyle:kRefreshViewStyleTableView];
//        [refreshView setDelegates:self];
//        
//        ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
//        ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = 100;
//        ((RefreshTableView *)refreshView.refreshTargetView).tag = kSegmentStartTag+i;
//        
//        NewsSegmentModel *segment = [self.segments objectAtIndex:i];
//        segment.view = refreshView;
//        
//        ////////////////////////////
//        Segment *barSegment = [[Segment alloc] init];
//        barSegment.item.title = segment.title;
//        barSegment.content.view = segment.view;
//        [array addObject:barSegment];
//    }
    
    self.segmentVC = [[SegmentNaviVC alloc] init];
    self.segmentVC.segmentNaviDelegate = self;
    [self.segmentVC setBarViewWidth:self.view.frame.size.width-60];
    
    [self segmentNaviDataDoLoad];

    
    [self addChildViewController:self.segmentVC];
    [self.view addSubview:self.segmentVC.view];
    
    self.channelsButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(self.segmentVC.segmentBar.frame.size.width+3, 0, 58, self.segmentVC.segmentBar.frame.size.height)];
    [self.channelsButton addTarget:self action:@selector(clickChannelsBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.channelsButton.layer.borderWidth = 0.0f;
    [self.channelsButton setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
    self.channelsButton.backgroundColor = [UIColor colorWithRed:49/255.0 green:126/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:self.channelsButton];
}

- (void)segmentNaviDataDoLoad {
    for(NSInteger i=0; i<self.segments.count; i++) {
        RefreshView *refreshView = [[RefreshView alloc] initWithStyle:kRefreshViewStyleTableView];
        [refreshView setDelegates:self];
        
        ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
        ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = 100;
        ((RefreshTableView *)refreshView.refreshTargetView).tag = kSegmentStartTag+i;
        
        NewsSegmentModel *segment = [self.segments objectAtIndex:i];
        segment.view = refreshView;
        
        ////////////////////////////
        segment.item.title = segment.title;
        segment.content.view = segment.view;
    }
    
    self.segmentVC.segments = self.segments;
}

- (void)clickChannelsBtn:(UIButton *)button {
    NewsChannelsVC *vc = [[NewsChannelsVC alloc] init];
    [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
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
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NewsDefaultIcon.jpg"] options:SDWebImageProgressiveDownload];

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
        NewsSegmentModel *segment = [self.segments objectAtIndex:index];
        RefreshView *refreshView = (RefreshView *)segment.view;
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
    
    [self.segments addObjectsFromArray:typeList];
    
    NewsTypeModel *newsType = [self segmentWithIndex:self.segmentVC.currentIndex].titleItem;
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
    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"获取新闻类型列表失败！", nil)];
        };
    }
    else {
        [self cleanDatas];
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
