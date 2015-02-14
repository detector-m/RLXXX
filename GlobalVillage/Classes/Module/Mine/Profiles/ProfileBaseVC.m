//
//  ProfileBaseVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileBaseVC.h"

@interface ProfileBaseVC ()

@end

@implementation ProfileBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"提交", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clickCommitBtn:)];
    self.navigationItem.rightBarButtonItem = commitButton;
}

- (void)clickCommitBtn:(UIBarButtonItem *)item {
    
}
@end
