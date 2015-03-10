//
//  NearbyPersonVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NearbyPersonVC.h"
#import "RefreshView.h"
#import "RLTableModel.h"

#import "NearbyPersonCell.h"

#import "UIImageView+WebCache.h"

#import "AddFriendController.h"

#define kDefaultPageSize 10

@interface NearbyPersonVC () <RefreshDelegate, AddFriendControllerDelegate>
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) RLTableModel *tableModel;

@property (nonatomic, strong) AddFriendController *controller;
@end

@implementation NearbyPersonVC
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
}

- (void)dataDoLoad {
    self.controller = [[AddFriendController alloc] init];
    self.controller.delegate = self;
    
    self.tableModel = [[RLTableModel alloc] init];
}

#define kDefaultPageSize 10

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"附近的人", nil);
    
    [self dataDoLoad];
    
    [self refreshViewDoLoad];
//    [self.controller newsListRequest:self.newsType.ID currentCount:self.tableModel.datas.count pageCount:kDefaultPageSize token:nil subtag:0];
    User *user = [User sharedUser];
    [self.controller nearbyPersonRequest:user.accessToken longitude:user.location.longitude latitude:user.location.latitude radius:3000 pageCount:kDefaultPageSize currentCount:self.tableModel.datas.count];
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
    frame.origin.x = frame.origin.y = 0;
    refreshView.frame = frame;
    ((RefreshTableView *)refreshView.refreshTargetView).showsVerticalScrollIndicator = NO;
    ((RefreshTableView *)refreshView.refreshTargetView).rowHeight = 60;
    ((RefreshTableView *)refreshView.refreshTargetView).tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([(RefreshTableView *)refreshView.refreshTargetView respondsToSelector:@selector(setSeparatorInset:)]) {
        ((RefreshTableView *)refreshView.refreshTargetView).separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    self.refreshView = refreshView;
    [self.view addSubview:self.refreshView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRow = [self.tableModel.datas count];
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerClass:[NearbyPersonCell class] forCellReuseIdentifier:kTableCellIdentifier];
    NearbyPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"tee";
    cell.detailTextLabel.text = @"你好你好！";
    cell.genderView.image = [UIImage imageNamed:@"NewsDefaultIcon.png"];
    cell.distance.text = @"hei";
    cell.date.text = @"xsfd";
    
    if([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsMake(2, 3, 2, 3);
    }
    
    NSURL *imageUrl = [NSURL URLWithString:@""];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NewsDefaultIcon.png"] options:SDWebImageProgressiveDownload];
    
    return cell;
}

- (void)deselectRow:(UITableView *)tableView
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}
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
//        [self.controller newsListRequest:self.newsType.ID currentCount:0 pageCount:kDefaultPageSize token:nil subtag:0];
    }
    else {
        self.tableModel.needRefresh = NO;
//        [self.controller newsListRequest:self.newsType.ID currentCount:self.tableModel.datas.count pageCount:kDefaultPageSize token:nil subtag:0];
    }
}


#pragma mark - response
- (void)nearbyPersonResponse:(GVResponse *)response {

}
@end
