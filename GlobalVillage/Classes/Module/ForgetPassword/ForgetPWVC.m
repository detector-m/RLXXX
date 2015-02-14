//
//  ForgetPWVC.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/14.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "ForgetPWVC.h"
#import "ResetPWVC.h"
#import "RLInputView.h"

#import "NSString+Regex.h"

#import "ForgetPasswordController.h"
#import "ResetPWVC.h"

@interface ForgetPWVC () <ForgetPasswordControllerDelegate>
@property (nonatomic, strong) RLInputView *phoneInputView;
@property (nonatomic, strong) RLInputView *authcodeInputView;

@property (nonatomic, strong) UIButton *authcodeButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, readwrite, strong) ForgetPasswordController *controller;
@end

@implementation ForgetPWVC

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
    
    self.title = NSLocalizedString(@"获取验证码", nil);
    
    [self dataDoLoad];
    
    [self inputViewsDoLoad];
    [self buttonsDoLoad];
    
    UILabel *warnLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(10, self.nextButton.frame.origin.y+self.nextButton.frame.size.height+15, self.view.frame.size.width-20, 30)];
    warnLB.text = NSLocalizedString(@"请填写注册该号码的手机号码！", nil);
    [self.view addSubview:warnLB];
}

- (void)inputViewsDoLoad {
    CGRect frame = self.view.frame;
    
    self.phoneInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 30, frame.size.width-20, 40)];
    [self.phoneInputView regulateFrameOrigin];
    self.phoneInputView.title.text = NSLocalizedString(@"手机号", nil);
    ((UITextField *)self.phoneInputView.textInputView).placeholder = NSLocalizedString(@"请输入注册的手机号", nil);
    ((UITextField *)self.phoneInputView.textInputView).keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneInputView];
    
    self.authcodeInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 85, frame.size.width-20, 40)];
    self.authcodeInputView.title.text = NSLocalizedString(@"验证码", nil);
    ((UITextField *)self.authcodeInputView.textInputView).placeholder = NSLocalizedString(@"请输入验证码", nil);
    ((UITextField *)self.authcodeInputView.textInputView).keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.authcodeInputView];
}

- (void)buttonsDoLoad {
    CGRect frame = self.view.frame;
    frame.origin.y = self.authcodeInputView.frame.origin.y+self.authcodeInputView.frame.size.height + 15;
    frame.origin.x = frame.size.width - 120;
    frame.size.width = 100.0f;
    frame.size.height = 25.0f;
    
    self.authcodeButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:frame];
    [self.authcodeButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    self.authcodeButton.layer.borderWidth = 0.0f;
    [self.authcodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.authcodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.authcodeButton addTarget:self action:@selector(clickAuthcodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.authcodeButton];
    
    frame = self.authcodeButton.frame;
    frame.origin.x = self.view.frame.size.width/3;
    frame.origin.y = frame.origin.y+frame.size.height + 20;
    frame.size.width = frame.origin.x;
    frame.size.height = 40;
    
    self.nextButton = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:frame];
    [self.nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
}

- (void)clickAuthcodeBtn:(UIButton *)btn {
    if(![((UITextField *)self.phoneInputView.textInputView).text isMobile]) {
        //            ((UITextField *)self.phoneInputView.textInputView).text
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"请输入正确的手机号", nil)];
        return;
    }

    [self endEditing];
    btn.enabled = NO;
    [self performSelector:@selector(recoverBtn:) withObject:btn afterDelay:30.0f];
    [self.controller mobileAuthCodeRequest:((UITextField *)self.phoneInputView.textInputView).text appId:@"GlobalVillage"];
}

- (void)recoverBtn:(UIButton *)btn {
    if(btn.enabled == NO)
        btn.enabled = YES;
}

- (void)clickNextBtn:(UIButton *)btn {
    if(!([((UITextField *)self.phoneInputView.textInputView).text isMobile] && [((UITextField *)self.authcodeInputView.textInputView).text isMobileAuthCode])) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"请填写正确的手机号和验证码!", nil)];
        
        return;
    }
    
    [self endEditing];
    [self.controller verifyMobileAuthCodeRequest:((UITextField *)self.authcodeInputView.textInputView).text withPhoneNumber:((UITextField *)self.phoneInputView.textInputView).text];
    self.authcodeButton.enabled = YES;
}

- (void)mobileAuthCodeResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    if(response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:@"验证码获取有误！稍后再试！"];
        };
    }
    [self mainThreadAsync:block];
}

- (void)verifyMobileAuthCodeResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    if(response.status == 0) {
        block = ^(){
            ResetPWVC *vc = [[ResetPWVC alloc] init];
            vc.authcode = ((UITextField *)self.authcodeInputView.textInputView).text;
            vc.mobileNumber = ((UITextField *)self.phoneInputView.textInputView).text;
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        };
    }
    else {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:@"验证码有误！"];
        };
    }
    
    [self mainThreadAsync:block];
}
@end
