//
//  ResetPWVC.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/14.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "ResetPWVC.h"
#import "RLInputView.h"

#import "ForgetPasswordController.h"

@interface ResetPWVC () <ForgetPasswordControllerDelegate>
@property (nonatomic, readwrite, strong) RLInputView *passwordInputView;
@property (nonatomic, readwrite, strong) RLInputView *checkInputView;

@property (nonatomic, readwrite, strong) ForgetPasswordController *controller;
@end

@implementation ResetPWVC

- (void)dealloc {
    [self dataDoClean];
}

- (void)dataDoLoad {
    self.controller = [[ForgetPasswordController alloc] init];
    self.controller.delegate = self;
}

- (void)dataDoClean {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self.controller removeAllRequest];
    return [super navigationShouldPopOnBackButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"密码设置", nil);
    [self dataDoLoad];
    [self subViewsDoLoad];
}

- (void)subViewsDoLoad {
    CGRect frame = self.view.frame;
    
    UILabel *label1 = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(15, 15, 150, 40)];
    [label1 regulateFrameOrigin];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = NSLocalizedString(@"请填写密码", nil);
    [self.view addSubview:label1];
    
    self.passwordInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 75, frame.size.width-20, 40)];
    [self.passwordInputView regulateFrameOrigin];
    self.passwordInputView.title.text = NSLocalizedString(@"密码", nil);
    ((UITextField *)self.passwordInputView.textInputView).placeholder = NSLocalizedString(@"请输入密码", nil);
    ((UITextField *)self.passwordInputView.textInputView).secureTextEntry = YES;
    [self.view addSubview:self.passwordInputView];
    
    self.checkInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 135, frame.size.width-20, 40)];
    [self.checkInputView regulateFrameOrigin];
    self.checkInputView.title.text = NSLocalizedString(@"密码确认", nil);
    ((UITextField *)self.checkInputView.textInputView).secureTextEntry = YES;
    ((UITextField *)self.checkInputView.textInputView).placeholder = NSLocalizedString(@"请确认密码", nil);
    [self.view addSubview:self.checkInputView];
    
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
    NSString *pw1 = ((UITextField *)self.passwordInputView.textInputView).text;
    NSString *pw2 = ((UITextField *)self.checkInputView.textInputView).text;
    
    if(pw1.length < 6 || pw2.length < 6) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"密码不安全", nil)];
        return;
    }
    
    if(![pw1 isEqualToString:pw2]) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"两次输入的密码不同!", nil)];
        return;
    }
    
    [self.controller findPasswordRequest:self.mobileNumber authcode:self.authcode newPassword:pw1];
}


- (void)findPasswordResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:@"重置密码失败！"];
        };
    }
    else {
        block = ^(){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [GVPopViewManager showDialogWithTitle:@"重置密码成功！"];
        };
    }
    [self mainThreadAsync:block];
}
@end
