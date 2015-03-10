//
//  SearchStrangerVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SearchStrangerVC.h"

@interface SearchStrangerVC () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation SearchStrangerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"添加好友", nil);
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:NSLocalizedString(@"确定", nil)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    [self.view addSubview:self.searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

@end
