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
#import "URBAlertView.h"

#import "NewsController.h"

#define kDefaultPageSize 10

@interface NewsVC () <NewsControllerDelegate, SegmentNaviDelegate, RefreshDelegate>
@property (nonatomic, readwrite, strong) SegmentNaviVC *segmentVC;
@property (nonatomic, readwrite, strong) NSMutableArray *segments Description(NewsSegmentModel);

@property (nonatomic, strong) UIButton *channelsButton;
@property (nonatomic, strong) UIButton *navigationTitleButton;

@property (nonatomic, readwrite, strong) NewsController *controller;
@end

@implementation NewsVC

- (void)dealloc {
    [self dataDoClear];
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    
    URBAlertView *alertView = [URBAlertView dialogWithTitle:NSLocalizedString(@"是否退出到登录？", nil) subtitle:nil];
    alertView.blurBackground = NO;
    [alertView addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"确定", nil)];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *theAlertView) {
        [theAlertView hideWithCompletionBlock:^{
            if(buttonIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    
    [alertView showWithAnimation:URBAlertAnimationDefault];

    return NO;//[super navigationShouldPopOnBackButton];
}


- (void)navigationDidPopOnBackButton {
    [super navigationDidPopOnBackButton];
}

- (void)dataDoClear {
    self.controller.delegate = nil;
    self.controller = nil;
    [self.segments removeAllObjects], self.segments = nil;
    self.channelsButton = nil;
    self.navigationTitleButton = nil;
}

- (void)dataDoLoad {
    self.controller = [[NewsController alloc] init];
    self.controller.delegate = self;

    self.segments = [NSMutableArray array];
}

- (void)cleanDatas {
    [self.segmentVC cleanData];
    [self.segments removeAllObjects];
//    [self.segmentVC.segments removeAllObjects];
}

//- (BOOL)navigationShouldPopOnBackButton {
//
//    [self.navigationController popViewControllerAnimated:YES];
//    return YES;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationTitleButton.enabled = YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationTitleButton.enabled = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataDoLoad];
    
    [self navigationTitleButtonDoLoad];
    self.title = NSLocalizedString(@"地球村新闻", nil);
    
    self.controller.accessToken = [User sharedUser].accessToken;
    
    [self.controller newsTypeListRequest:[User sharedUser].accessToken];
}

- (void)navigationTitleButtonDoLoad {
    UIImage *image = [UIImage imageNamed:@"NewsTitle.png"];

    UIButton *button = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    button.layer.borderWidth = .0f;
    self.navigationTitleButton = button;
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.titleView = button;
    [self.navigationTitleButton addTarget:self action:@selector(clickNavigationTitleBtn:) forControlEvents:UIControlEventTouchUpInside];


//    self.navigationTitleButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake((self.view.frame.size.width-120)/2.0, 2, 120, 40)];
//    self.navigationTitleButton.layer.borderWidth = 0.0f;
    
//    [self.navigationTitleButton addTarget:self action:@selector(clickNavigationTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:self.navigationTitleButton];
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
    [self.segmentVC setBarViewWidth:self.view.frame.size.width-44];
    
    [self segmentNaviDataDoLoad];

    
    [self addChildViewController:self.segmentVC];
    [self.view addSubview:self.segmentVC.view];
    
    self.channelsButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(self.segmentVC.segmentBar.frame.size.width+2, 5, self.view.frame.size.width - self.segmentVC.segmentBar.frame.size.width-4, self.segmentVC.segmentBar.frame.size.height-10)];
    self.channelsButton.layer.borderWidth = 0.0f;
    [self.channelsButton addTarget:self action:@selector(clickChannelsBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.channelsButton setTitle:NSLocalizedString(@"更多", nil) forState:UIControlStateNormal];
//    self.channelsButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.channelsButton setImage:[UIImage imageNamed:@"MoreChannels.png"] forState:UIControlStateNormal];
    [self.channelsButton setTintColor:[UIColor colorWithRed:181/255.0 green:224/255.0 blue:239/255.0 alpha:1]];
    [self.view addSubview:self.channelsButton];
}

- (void)segmentNaviDataDoLoad {
    NSInteger count = [self segmentsShowCount:self.segments];
    for(NSInteger i=0; i<count/*self.segments.count*/; i++) {
        RefreshView *refreshView = [[RefreshView alloc] initWithStyle:kRefreshViewStyleTableView];
        [refreshView setDelegates:self];
        
        ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
        ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = kNewsCellHeight;
        ((RefreshTableView *)refreshView.refreshTargetView).tag = kSegmentStartTag+i;
        ((RefreshTableView *)refreshView.refreshTargetView).tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if ([(RefreshTableView *)refreshView.refreshTargetView respondsToSelector:@selector(setSeparatorInset:)]) {
            ((RefreshTableView *)refreshView.refreshTargetView).separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        
        NewsSegmentModel *segment = [self segmentShow:self.segments index:i];//[self.segments objectAtIndex:i];
        segment.view = refreshView;
        
        ////////////////////////////
        segment.item.title = segment.title;
        segment.content.view = segment.view;
    }
    
    self.segmentVC.segments = self.segments;
}

- (void)clickChannelsBtn:(UIButton *)button {
    NewsChannelsVC *vc = [[NewsChannelsVC alloc] init];
    vc.newsVC = self;
    [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
}
- (NewsSegmentModel *)segmentWithIndex:(NSInteger)index {
    
    return [self segmentShow:self.segments index:index];
//    return [self.segments objectAtIndex:index];
}

- (NewsModel *)newsWithIndex:(NSInteger)index andRow:(NSInteger)row {
    return [[self segmentWithIndex:index].contents objectAtIndex:row];
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

- (NewsSegmentModel *)segmentShow:(NSArray *)segments index:(NSInteger)index {
    NSInteger count = 0;
    for(NewsSegmentModel *inSegment in self.segments) {
        if(inSegment.segmentMode == kSegmentModeShow) {
            if(count == index) {
                return inSegment;
                
            }
            count++;
        }
    }
    
    return nil;
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
//    CGFloat height = numOfRow * tableView.rowHeight;
//    if(height < tableView.frame.size.height) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    else {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }

    return numOfRow;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kNewsCellHeight;
//}

- (NewsModel *)getNewsWithTag:(NSInteger)tag andRow:(NSInteger)row {
    NSInteger index = tag-kSegmentStartTag;
    
    return [self newsWithIndex:index andRow:row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if 0
    [tableView registerClass:[SegmentPageTableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
    NewsModel *news = [self getNewsWithTag:tableView.tag andRow:indexPath.row];
    SegmentPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
//        SegmentPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    
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
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NewsDefaultIcon.png"] options:SDWebImageProgressiveDownload];
#else
    [tableView registerClass:[NewsCell class] forCellReuseIdentifier:kTableCellIdentifier];
    NewsModel *news = [self getNewsWithTag:tableView.tag andRow:indexPath.row];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    
    cell.title.text = news.title;
    cell.abstract.text = news.abstract;
    
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
    [cell.thumbView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NewsDefaultIcon.png"] options:SDWebImageProgressiveDownload];
#endif

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
        NewsSegmentModel *segment = [self segmentShow:self.segments index:index];//[self.segments objectAtIndex:index];
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
        if(self.segmentVC.needReset) {
            [self.segmentVC resetIndex];
        }
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

- (void)newsSubscribeNewsChannelsResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"栏目提交失败！", nil)];
            
        };
        
    }
    else {
        __weak NewsVC *blockSelf = self;
        self.segmentVC.needReset = YES;
        block = ^(){
            [blockSelf.segmentVC resetIndex];
            [blockSelf.controller newsTypeListRequest:[User sharedUser].accessToken];
        };
        
    }
    
    [self mainThreadAsync:block];
}

#pragma mark News interface method
- (NSArray *)newsSegments {
    return self.segments;
}

- (NSArray *)subscribeNewsSegments {
    NSMutableArray *subscribeSegments = [NSMutableArray array];
    for(NewsSegmentModel *segment in self.segments) {
        if(segment.operationMode == kOperationModePerson) {
            if(segment.subscribeMode == kSubscribeModeYES) {
                [subscribeSegments addObject:segment];
            }
        }
    }
    
    return subscribeSegments;
}
- (NSArray *)unsubscribeNewsSegments {
    NSMutableArray *unsubscribeSegments = [NSMutableArray array];
    for(NewsSegmentModel *segment in self.segments) {
        if(segment.operationMode == kOperationModePerson) {
            if(segment.subscribeMode == kSubscribeModeNO) {
                [unsubscribeSegments addObject:segment];
            }
        }
    }
    return unsubscribeSegments;
}

- (void)commitChennelsForSubscribeAndUnSubscribe {
    NSMutableArray *subscribes = [NSMutableArray array];
    NSMutableArray *unsubscribes = [NSMutableArray array];
    NSMutableArray *subscribeSegments = (NSMutableArray *)[self subscribeNewsSegments];
    NewsTypeModel *newsType = nil;
    for(NewsSegmentModel *segment in self.segments) {
        newsType = segment.titleItem;

        if(segment.newsSubscribeMode == kNewsSegmentSubscribeModeSubscribe) {
            [subscribes addObject:[RLTypecast integerToString:newsType.ID]];
            segment.newsSubscribeMode = kNewsSegmentSubscribeModeNone;
            [subscribeSegments addObject:segment];
        }
        else if(segment.newsSubscribeMode == kNewsSegmentSubscribeModeUnSubscribe) {
            [unsubscribes addObject:[RLTypecast integerToString:newsType.ID]];
            segment.newsSubscribeMode = kNewsSegmentSubscribeModeNone;
            [subscribeSegments removeObject:segment];
        }
    }
    
    if(subscribes.count == 0 && unsubscribes.count == 0)
        return;
    [subscribes removeAllObjects];
    for(NewsSegmentModel *segment in subscribeSegments) {
        newsType = segment.titleItem;
        [subscribes addObject:[RLTypecast integerToString:newsType.ID]];
    }
    
    NSString *subscribesStr = [subscribes componentsJoinedByString:@","];
//    NSString *unsubscribesStr = [unsubscribes componentsJoinedByString:@","];
    [subscribes removeAllObjects], subscribes = nil;
    [unsubscribes removeAllObjects], unsubscribes = nil;
    [subscribeSegments removeAllObjects], subscribeSegments = nil;
    [self.controller newsSubscribeNewsChannelsRequest:subscribesStr unsubscribeNewsChannels:nil accessToken:nil];
}

- (void)selected:(NewsSegmentModel *)theSegment {
    NSInteger index = 0;
    for(Segment *segment in self.segments) {
        if(segment == theSegment)
            break;
        if(segment.segmentMode == kSegmentModeShow) {
            index++;
        }
    }
    
    [self.segmentVC.segmentBar selectIndex:index];
}
@end
