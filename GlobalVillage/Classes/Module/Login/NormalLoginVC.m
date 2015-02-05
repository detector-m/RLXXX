//
//  NormalLoginVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NormalLoginVC.h"
#import "RLLabel.h"
#import "RLButton.h"
#import "RLTextField.h"

#import "RegisterVC.h"
#import "NewsVC.h"

#import "RLFileOperation.h"
#import "LoginController.h"

@interface NormalLoginVC () <LoginControllerDelegate>
@property (nonatomic, strong) RLTextField *accountTF;
@property (nonatomic, strong) RLTextField *passworldTF;

@property (nonatomic, readwrite, strong) LoginController *controller;
@end

@implementation NormalLoginVC

- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (void)dataDoLoad {
    self.controller = [[LoginController alloc] init];
    self.controller.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"登录", nil);
    
    self.navigationItem.backBarButtonItem = nil;

    [self dataDoLoad];
    
    [self textFieldsDoLoad];
    [self buttonsDoLoad];
}

- (void)textFieldsDoLoad {
    self.accountTF = [[RLTextField alloc] initWithFrame:CGRectMake(15, 30, self.view.bounds.size.width-30, 40)];
    self.accountTF.placeholder = NSLocalizedString(@"地球号/手机号", nil);
    self.accountTF.keyboardType = UIKeyboardTypeNumberPad;
    self.accountTF.text = [[RLFileOperation userLoginInfo] objectForKey:@"kUsername"];
//    self.accountTF.delegate = self;
    self.accountTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.accountTF];
    
    self.passworldTF = [[RLTextField alloc] initWithFrame:CGRectMake(15, 90, self.view.bounds.size.width-30, 40)];
    self.passworldTF.placeholder = NSLocalizedString(@"密码", nil);
    self.passworldTF.secureTextEntry = YES;
//    self.passworldTF.delegate = self;
    self.passworldTF.returnKeyType = UIReturnKeyDone;
    self.passworldTF.text = [[RLFileOperation userLoginInfo] objectForKey:@"kUserPwd"];
    [self.view addSubview:_passworldTF];
}

- (void)buttonsDoLoad {
    RLButton *loginBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(15, 160, (self.view.bounds.size.width-45)/2, 40)];
    [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    RLButton *registerBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(self.view.bounds.size.width-(self.view.bounds.size.width-45)/2-15, 160, (self.view.bounds.size.width-45)/2, 40)];
    [registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
//    UIButton *forgetPasswordBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(self.view.bounds.size.width-120, 210, 100, 30)];
//    forgetPasswordBtn.backgroundColor = [UIColor clearColor];
//    [forgetPasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [forgetPasswordBtn setTitle:NSLocalizedString(@"忘记密码？", nil) forState:UIControlStateNormal];
//    [forgetPasswordBtn addTarget:self action:@selector(clickForgetPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forgetPasswordBtn];
}

- (void)clickLoginBtn:(UIButton *)button {
    [self endEditing];
    
    if(!([self.accountTF.text isMobile] || [self.accountTF.text isChikyugo]) || !(self.passworldTF.text.length >= 6)) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"请检查用户名和密码！", nil)];
        
        return;
    }
    
    User *user = [User sharedUser];
    [self.controller loginRequest:self.accountTF.text password:self.passworldTF.text location:user.location thirdOpenKey:nil loginType:kLoginTypeLocal];
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"登录中。。。", nil)];
}
- (void)clickRegisterBtn:(UIButton *)button {
    RegisterVC *vc = [[RegisterVC alloc] init];
    [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
}
- (void)clickForgetPasswordBtn:(UIButton *)button {
    
}

#pragma mark - LoginControllerDelegate
- (void)loginResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"用户名或密码错误！", nil)];
        };
    }
    else {
//        [GVPopViewManager showDialogWithTitle:@"登录成功！"];
        User *user = [User sharedUser];
        [user setAccount:user.phone andPassword:self.passworldTF.text];
//        [ChangeVCController changeMainRootViewController:[NewsVC class]];
        [RLFileOperation storeLoginInfo:user.dqNumber pwd:user.password date:nil plateforme:@"local" openKey:nil];
        block = ^(){
            NewsVC *vc = [[NewsVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        };
    }
    
    [self mainThreadAsync:block];
}

@end
