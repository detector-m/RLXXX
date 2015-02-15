//
//  GenderSettingVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "GenderSettingVC.h"
#import "RLRadioButton.h"

#import "MineController.h"

@interface GenderSettingVC () <MineControllerDelegate>
@property (nonatomic, strong) RLRadioButton *manBtn;
@property (nonatomic, strong) RLRadioButton *womBtn;

@property (nonatomic, strong) MineController *controller;
@end

@implementation GenderSettingVC
- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (void)dataDoLoad {
    self.controller = [[MineController alloc] init];
    self.controller.delegate = self;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    return [super navigationShouldPopOnBackButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"性别", nil);
    [self dataDoLoad];
    
    [self radioButtonsDoLoad];
}

- (void)radioButtonsDoLoad {
    CGRect frame = self.view.frame;
    
    self.manBtn = [self constructRadioButtonFrame:CGRectMake(40, 44, 60, 20)];
    self.manBtn.label.text = NSLocalizedString(@"男", nil);
    [self.manBtn addTarget:self action:@selector(clickManBtn:)];
    self.manBtn.button.selected = YES;
    [self.view addSubview:self.manBtn];
    
    self.womBtn = [self constructRadioButtonFrame:CGRectMake(frame.size.width-40-60, 44, 60, 20)];
    self.womBtn.label.text = NSLocalizedString(@"女", nil);
    [self.womBtn addTarget:self action:@selector(clickWomBtn:)];
    [self.view addSubview:self.womBtn];
    
    if(self.gender == kGenderTypeMan) {
        self.manBtn.button.selected = YES;
        self.womBtn.button.selected = NO;
    }
    else {
        self.womBtn.button.selected = YES;
        self.manBtn.button.selected = NO;
    }
}

- (RLRadioButton *)constructRadioButtonFrame:(CGRect)frame {
    RLRadioButton *radioButton = [[RLRadioButton alloc] initWithFrame:frame];
    [radioButton.button setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
    [radioButton.button setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
    return radioButton;
}

- (void)clickManBtn:(id)button {
    [self endEditing];
    if(!self.manBtn.button.selected){
        self.manBtn.button.selected = !self.manBtn.button.selected;
        self.womBtn.button.selected = !self.womBtn.button.selected;
        
        self.gender = kGenderTypeMan;
    }
}

- (void)clickWomBtn:(id)button {
    [self endEditing];
    if(!self.womBtn.button.selected){
        self.womBtn.button.selected = !self.womBtn.button.selected;
        self.manBtn.button.selected = !self.manBtn.button.selected;
        
        self.gender = kGenderTypeWom;
    }
}

- (void)clickCommitBtn:(UIBarButtonItem *)item {
    if(self.gender == [User sharedUser].gender) {
        return;
    }
    
    [self.controller updateUserInfoRequest:nil sex:[RLTypecast integerToString:self.gender] city:nil headPortrait:nil age:nil signature:nil accessToken:[User sharedUser].accessToken];
}

- (void)updateUserInfoResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    [GVPopViewManager removeActivity];
    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"更新性别失败！", nil)];
        };
    }
    else {
        User *user = [User sharedUser];
        user.gender = self.gender;
        __weak GenderSettingVC *weakSelf = self;
        block = ^(){
            [weakSelf.superVC reloadData];
            [ChangeVCController popViewControllerByNavigationController:weakSelf.navigationController];
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"修改成功", nil)];
        };
    }
    
    [self mainThreadAsync:block];
}
@end
