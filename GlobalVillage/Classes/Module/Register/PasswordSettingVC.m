//
//  PasswordSettingVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "PasswordSettingVC.h"

#import "RLInputView.h"

#import "RegisterController.h"
#import "RLFileOperation.h"

#import "RLBaseNavigationController.h"
#import "NewsVC.h"

@interface PasswordSettingVC () <RegisterControllerDelegate>
@property (nonatomic, readwrite, strong) RLInputView *passwordInputView;
@property (nonatomic, readwrite, strong) RLInputView *checkInputView;

@property (nonatomic, readwrite, strong) RegisterController *controller;
@end

@implementation PasswordSettingVC
- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)navigationShouldPopOnBackButton {
    return [super navigationShouldPopOnBackButton];
}

- (void)navigationDidPopOnBackButton {
    [self.controller removeAllRequest];
    [super navigationDidPopOnBackButton];
}

- (void)dataDoLoad {
    self.controller = [[RegisterController alloc] init];
    self.controller.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"设置密码", nil);

    [self dataDoLoad];
    [self subviewsDoLoad];
}

- (void)subviewsDoLoad {
    CGRect frame = self.view.frame;
//    CGFloat inputViewWidth = frame.size.width-20;
//    CGFloat inputViewHeight = 30;
//    CGFloat spaceV = 3;
//    CGFloat heightOffset = 0;
    
    UILabel *label1 = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(15, 15, 150, 40)];
    [label1 regulateFrameOrigin];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = NSLocalizedString(@"请填写密码", nil);
    [self.view addSubview:label1];
    
    self.passwordInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 75, frame.size.width-20, 40)];
    [self.passwordInputView regulateFrameOrigin];
    self.passwordInputView.title.text = NSLocalizedString(@"密码", nil);
    ((UITextField *)self.passwordInputView.textInputView).secureTextEntry = YES;
    [self.view addSubview:self.passwordInputView];
    
    self.checkInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 135, frame.size.width-20, 40)];
    [self.checkInputView regulateFrameOrigin];
    self.checkInputView.title.text = NSLocalizedString(@"密码确认", nil);
    ((UITextField *)self.checkInputView.textInputView).secureTextEntry = YES;
    [self.view addSubview:self.checkInputView];
    
//    UILabel *passwordLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(15, 75, 100, 40)];
//    [passwordLB regulateFrameOrigin];
//    passwordLB.textAlignment = NSTextAlignmentLeft;
//    passwordLB.text = NSLocalizedString(@"密码", nil);
//    [self.view addSubview:passwordLB];
//    
//    self.passwordTF = [ViewConstructor constructDefaultTextField:[UITextField class] withFrame:CGRectMake(105, 75, 185+15, 40)];
//    [self.passwordTF regulateFrameOrigin];
//    self.passwordTF.secureTextEntry = YES;
//    [self.view addSubview:self.passwordTF];
//    
//    UILabel *checkPasswordLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(15, 135, 100, 40)];
//    [checkPasswordLB regulateFrameOrigin];
//    checkPasswordLB.textAlignment = NSTextAlignmentLeft;
//    checkPasswordLB.text = NSLocalizedString(@"密码确认", nil);
//    [self.view addSubview:checkPasswordLB];
//    
//    self.checkPasswordTF = [ViewConstructor constructDefaultTextField:[UITextField class] withFrame:CGRectMake(105, 135, 185+15, 40)];
//    [self.checkPasswordTF regulateFrameOrigin];
//    self.checkPasswordTF.secureTextEntry = YES;
//    [self.view addSubview:self.checkPasswordTF];
    
    UIButton *confirmBtn = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(80, 190, 160, 40)];
    [confirmBtn regulateFrameOrigin];
    [confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    UILabel *warnLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(15, 255, 290, 30)];
    [warnLB regulateFrameOrigin];
    warnLB.textColor = [UIColor blueColor];
    warnLB.text = NSLocalizedString(@"请牢牢记住你的密码，不要再弄丢了哦！", nil);
    [self.view addSubview:warnLB];
}

- (void)clickConfirmBtn:(UIButton *)button {
    [self endEditing];
    
    if(((UITextField *)self.passwordInputView.textInputView).text.length < 6) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"密码太短，不安全！", nil)];
        return;
    }
    
    if(![((UITextField *)self.passwordInputView.textInputView).text isEqualToString:((UITextField *)self.checkInputView.textInputView).text]) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"两次密码输入不正确！", nil)];
        return;
    }
    
    User *user = [User sharedUser];
    user.password = ((UITextField *)self.passwordInputView.textInputView).text;
    [self.controller requestRegist:user.dqNumber phoneNumber:user.phone password:user.password gender:user.gender nickname:user.nickname location:user.location /*pic:user.pic*/];
    
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"正在注册...", nil)];
}

#pragma makr - request delegate
- (void)request:(RLRequest *)request didLoadFailed:(id)result {
    dispatch_block_t block = NULL;
    block = ^() {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"网络有问题", nil)];
    };
    
    [self mainThreadAsync:block];
}

- (void)registerResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^() {
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"注册失败！", nil)];
        };
    }
    else {
//        DLog(@"%@", response.responseData);
        User *user = [User sharedUser];
        [user setAccount:user.phone andPassword:((UITextField *)self.passwordInputView.textInputView).text];
        [RLFileOperation storeLoginInfo:user.dqNumber pwd:user.password date:nil plateforme:@"local" openKey:nil];
        block = ^() {
//            [ChangeVCController changeMainRootViewController:[NewsVC class]];
            NewsVC *vc = [[NewsVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationControllerFromRootViewController:self.navigationController pushVC:vc];
        };
    }
    [self mainThreadAsync:block];
}
@end
