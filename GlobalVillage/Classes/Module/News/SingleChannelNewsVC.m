//
//  SingleChannelNewsVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SingleChannelNewsVC.h"
#import "RLTableModel.h"
#import "RefreshView.h"
#import "SegmentPageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailVC.h"

#import "NewsController.h"

@interface SingleChannelNewsVC () <NewsControllerDelegate, RefreshDelegate>
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) RLTableModel *tableModel;
@property (nonatomic, readwrite, strong) NewsController *controller;
@end

@implementation SingleChannelNewsVC
- (void)dealloc {
    [self dataDoClear];
}

- (void)navigationDidPopOnBackButton {
    [self.controller removeAllRequest];
    [super navigationDidPopOnBackButton];
}

- (void)dataDoClear {
    self.controller.delegate = nil;
    self.controller = nil;
    self.tableModel = nil;
    self.newsType = nil;
}

- (void)dataDoLoad {
    self.controller = [[NewsController alloc] init];
    self.controller.delegate = self;
    self.controller.accessToken = [User sharedUser].accessToken;
    self.tableModel = [[RLTableModel alloc] init];
}

#define kDefaultPageSize 10

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.newsType.title;
    [self dataDoLoad];
    
//    [self refreshViewDoLoad];
    [self.controller newsListRequest:self.newsType.ID currentCount:self.tableModel.datas.count pageCount:kDefaultPageSize token:nil subtag:0];
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"加载中。。。", nil) forView:self.view];
}

- (void)refreshViewDoLoad {
    if(self.refreshView) {
        [self.refreshView reloadTableViewData];
        return;
    }
    RefreshView *refreshView = [[RefreshView alloc] initWithStyle:kRefreshViewStyleTableView];
    [refreshView setDelegates:self];
    CGRect frame = self.view.frame;
//    if(frame.origin.y > 0) {
//        NSString *test = [NSString stringWithFormat:@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
//        [GVPopViewManager showDialogWithTitle:test];
//    }
    frame.origin.x = frame.origin.y = 0;
    refreshView.frame = frame;
    ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
    ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = kNewsCellHeight;
    ((RefreshTableView *)refreshView.refreshTargetView).tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([(RefreshTableView *)refreshView.refreshTargetView respondsToSelector:@selector(setSeparatorInset:)]) {
        ((RefreshTableView *)refreshView.refreshTargetView).separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    self.refreshView = refreshView;
    [self.view addSubview:self.refreshView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRow = [self.tableModel.datas count];
    
    return numOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
#if 0
    NewsModel *news = [self.tableModel.datas objectAtIndex:indexPath.row];
    SegmentPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
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
    NewsModel *news = [self.tableModel.datas objectAtIndex:indexPath.row];
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
    NewsModel *news = [self.tableModel.datas objectAtIndex:indexPath.row];
    NewsDetailVC *vc = [[NewsDetailVC alloc] init];
    vc.newsUrl = news.detailUrl;

    [self.navigationController pushViewController:vc animated:YES];
    news.hasRead = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(news.hasRead) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//- (UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
//    return [UITableViewHeaderFooterView new];
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [UIView new];
//    
//    // If you are not using ARC:
//    // return [[UIView new] autorelease];
//}

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
    
    if(refreshMode == kRefreshModeRefresh) {
        self.tableModel.needRefresh = YES;
        [self.controller newsListRequest:self.newsType.ID currentCount:0 pageCount:kDefaultPageSize token:nil subtag:0];
    }
    else {
        self.tableModel.needRefresh = NO;
        [self.controller newsListRequest:self.newsType.ID currentCount:self.tableModel.datas.count pageCount:kDefaultPageSize token:nil subtag:0];
    }
}

#pragma mark - data
- (void)newsListParser:(NSArray *)newsList segmentIndex:(NSInteger)index {
    if(newsList.count == 0)
        return;
    
    if(self.tableModel.needRefresh) {
        [self.tableModel.datas removeAllObjects];
        self.tableModel.needRefresh = NO;
    }
    [self.tableModel.datas addObjectsFromArray:newsList];
}

#pragma mark - NewsControllerDelegate
- (void)newsListResponse:(GVResponse *)response subtag:(NSInteger)subtag {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        __weak SingleChannelNewsVC *blockSelf = self;

        block = ^(){
            if(blockSelf.refreshView.refreshDelegate == blockSelf && ((RefreshTableView *)blockSelf.refreshView.refreshTargetView).reloading == YES) {
                [self.refreshView finishedReloadingData];
            }
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"获取新闻列表失败！", nil)];
        };
    }
    else {
        [self newsListParser:response.responseData segmentIndex:subtag];
        __weak SingleChannelNewsVC *blockSelf = self;
        block = ^() {
            [GVPopViewManager removeActivity];
            if(blockSelf.refreshView.refreshDelegate == blockSelf && ((RefreshTableView *)blockSelf.refreshView.refreshTargetView).reloading == YES) {
                [self.refreshView finishedReloadingData];
            }
            if(((NSArray *)response.responseData).count > 0) {
                [blockSelf refreshViewDoLoad];
            }
        };
    }
    
    [self mainThreadAsync:block];
}

@end
