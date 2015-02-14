//
//  MineVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MineVC.h"
#import "ProfileVC.h"
#import "SettingsVC.h"

@interface MineVC ()
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLTableModel *tableModel;
@end

@implementation MineVC

- (void)dealloc {
    [self dataDoClean];
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = NSLocalizedString(NSLocalizedString(@"我的", nil), nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.title = @"";
}

- (void)dataDoClean {
    self.tableModel = nil;
}
- (void)dataDoLoad {
    self.tableModel = [[RLTableModel alloc] init];
    [self.tableModel.datas addObject:NSLocalizedString(@"个人信息", nil)];
    [self.tableModel.datas addObject:NSLocalizedString(@"我的商城", nil)];
    [self.tableModel.datas addObject:NSLocalizedString(@"设置", nil)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"我的", nil);
    [self dataDoLoad];
    
    [self tableViewDoLoad];
}

- (void)tableViewDoLoad {
    if(self.tableView) {
        return;
    }
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0f, 0.0f);//{0.0f, 0.0f};

    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
//    self.tableView.rowHeight = 100;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
#define kMineSections 3
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kMineSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
    cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.tableModel.datas objectAtIndex:indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsMake(2, 3, 2, 3);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.userInteractionEnabled = NO;
    switch (indexPath.section) {
        case 0:
        {
            ProfileVC *vc = [[ProfileVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationController:self.tabBarController.navigationController pushVC:vc];
        }
            break;
        case 1: {
            SettingsVC *vc = [[SettingsVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationController:self.tabBarController.navigationController pushVC:vc];
        }
            break;
            
        case 2: {
            SettingsVC *vc = [[SettingsVC alloc] init];
            vc.mineVC = self;
            [ChangeVCController pushViewControllerByNavigationController:self.tabBarController.navigationController pushVC:vc];
        }
            break;
            
        default:
            break;
    }
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

@end
