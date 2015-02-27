//
//  PasswordSettingVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/10.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "PasswordSetVC.h"
#import "RLInputView.h"

#import "MineController.h"

@interface PasswordSetVC () <MineControllerDelegate>
@property (nonatomic, strong) RLInputView *oldPasswordInputView;
@property (nonatomic, strong) RLInputView *setPasswordInputView;
@property (nonatomic, strong) RLInputView *checkInputView;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) MineController *controller;
@end

@implementation PasswordSetVC
- (void)dealloc {
    [self dataDoClean];
}

- (void)dataDoLoad {
    self.controller = [[MineController alloc] init];
    self.controller.delegate = self;
}

- (void)dataDoClean {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    return [super navigationShouldPopOnBackButton];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"密码设置", nil);
    
    [self dataDoLoad];
    
    [self inputViewsDoLoad];
    [self buttonDoLoad];
}

- (void)inputViewsDoLoad {
    CGRect frame = self.view.frame;
    
    self.oldPasswordInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 30, frame.size.width-20, 40)];
    [self.oldPasswordInputView regulateFrameOrigin];
    self.oldPasswordInputView.title.text = NSLocalizedString(@"原密码", nil);
    ((UITextField *)self.oldPasswordInputView.textInputView).placeholder = NSLocalizedString(@"请输入原密码", nil);
    ((UITextField *)self.oldPasswordInputView.textInputView).secureTextEntry = YES;
    [self.view addSubview:self.oldPasswordInputView];
    
    self.setPasswordInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 85, frame.size.width-20, 40)];
    [self.setPasswordInputView regulateFrameOrigin];
    self.setPasswordInputView.title.text = NSLocalizedString(@"新密码", nil);
    ((UITextField *)self.setPasswordInputView.textInputView).placeholder = NSLocalizedString(@"请输入新密码", nil);
    ((UITextField *)self.setPasswordInputView.textInputView).secureTextEntry = YES;
    [self.view addSubview:self.setPasswordInputView];
    
    self.checkInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 140, frame.size.width-20, 40)];
    [self.checkInputView regulateFrameOrigin];
    self.checkInputView.title.text = NSLocalizedString(@"密码确认", nil);
    ((UITextField *)self.checkInputView.textInputView).secureTextEntry = YES;
    ((UITextField *)self.checkInputView.textInputView).placeholder = NSLocalizedString(@"请确认密码", nil);
    [self.view addSubview:self.checkInputView];
}

- (void)buttonDoLoad {
    [self endEditing];
    CGRect frame = self.view.frame;
    frame.origin.y = self.checkInputView.frame.size.height+self.checkInputView.frame.origin.y + 30;
    frame.origin.x = self.view.frame.size.width/3;
    frame.size.width = self.view.frame.size.width/3;
    frame.size.height = 40;
    self.commitButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:frame];
    [self.commitButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitButton];
}

- (void)clickCommitBtn:(UIButton *)button {
    [self endEditing];

    NSString *pw1 = ((UITextField *)self.setPasswordInputView.textInputView).text;
    NSString *pw2 = ((UITextField *)self.checkInputView.textInputView).text;
    
    NSString *pw3 = ((UITextField *)self.oldPasswordInputView.textInputView).text;
    
    if(pw1.length < 6 || pw2.length < 6) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"密码不安全", nil)];
        return;
    }
    
    if(![pw1 isEqualToString:pw2]) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"两次输入的密码不同!", nil)];
        return;
    }
    
    if([pw3 isEqualToString:pw1]) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"原密码与新密码相同!", nil)];
        return;
    }
    
    [self.controller resetPasswordRequest:pw3 newPassword:pw1 accessToken:[User sharedUser].accessToken];
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"正在设置密码。。。", nil)];
}

#pragma mark - request response
- (void)resetPasswordResponse:(GVResponse *) response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"设置密码失败！", nil)];
        };
    }
    else {
        block = ^(){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"设置密码成功！", nil)];
        };
    }
    
    [self mainThreadAsync:block];
}
@end
