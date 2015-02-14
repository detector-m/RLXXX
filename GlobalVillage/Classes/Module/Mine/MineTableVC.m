//
//  MineTableVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MineTableVC.h"

@interface MineTableVC ()
@property (nonatomic, readwrite, strong) UITableView *tableView;
@end

@implementation MineTableVC

- (void)dealloc {
    self.tableView = nil;
    [self dataDoClean];
}

- (void)dataDoLoad {
    self.tableModel = [[RLTableModel alloc] init];
}

- (void)dataDoClean {
    [self.tableModel.datas removeAllObjects];
    self.tableModel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataDoLoad];
    [self tableViewDoLoad];
}

- (void)tableViewDoLoad {
    if(self.tableView) {
        return;
    }
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0f, 0.0f);//{0.0f, 0.0f};
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
#define kMineSections 1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kMineSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableModel.datas.count;
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

    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}
@end
