//
//  SettingsVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SettingsVC.h"
#import "PasswordSetVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)dataDoLoad {
    [super dataDoLoad];
    [self.tableModel.datas addObject:NSLocalizedString(@"设置密码", nil)];
//    [self.tableModel.datas addObject:@"Test2"];
//    [self.tableModel.datas addObject:@"Test3"];
//    [self.tableModel.datas addObject:@"Test4"];
}

- (void)dataDoClean {
    [super dataDoClean];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"设置", nil);
    [self tableViewFooterViewDoLoad];
}

- (void)tableViewFooterViewDoLoad {

    self.tableView.tableFooterView.frame = CGRectMake(0, 0, self.view.frame.size.width, 59);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, .5f)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.tableView.tableFooterView addSubview:view];
    
    CGRect frame = self.tableView.tableFooterView.frame;
    UIButton *button = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(frame.size.width*0.3, 10, frame.size.width*0.4, 44)];
    [button setTitle:NSLocalizedString(@"退出", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableFooterView addSubview:button];
}

- (void)clickLogoutBtn:(UIButton *)button {
    [self.mineVC.tabBarController.navigationController popToRootViewControllerAnimated:YES];
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
        case 0: {
            PasswordSetVC *vc = [[PasswordSetVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
            break;
        case 1: {
        }
            break;
            
        case 2: {
            
        }
            break;
            
        default:
            break;
    }
    
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}
@end
