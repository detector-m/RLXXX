//
//  PhoneAuthCodeVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "PhoneAuthCodeVC.h"

#import "CompleteRegisterinfoVC.h"

#import "RegisterController.h"

static NSInteger count = 60;
@interface PhoneAuthCodeVC () <RegisterControllerDelegate>
@property (nonatomic, readwrite, strong) RLTextField *authcodeTF;
@property (nonatomic, readwrite, strong) NSTimer *timer;

@property (nonatomic, readwrite, strong) RegisterController *controller;
@end

@implementation PhoneAuthCodeVC

- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (void)dataDoLoad {
    self.controller = [[RegisterController alloc] init];
    self.controller.delegate = self;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    
    return [super navigationShouldPopOnBackButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate], self.timer = nil;
    count = 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"获取手机验证码", nil);
    
    [self dataDoLoad];
    
    [self subviewsDoLoad];
}

- (void)subviewsDoLoad {
    self.authcodeTF = (RLTextField *)[ViewConstructor constructDefaultTextField:[RLTextField class] withFrame:CGRectMake(15, 20, 160, 40)];
    [self.authcodeTF regulateFrameOriginX];
    self.authcodeTF.placeholder = NSLocalizedString(@"输入验证码", nil);
    self.authcodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.authcodeTF];
    
    RLButton *getAuthcodeBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(190, 20, 125, 40)];
    [getAuthcodeBtn regulateFrameOriginX];
    [getAuthcodeBtn setTitle:NSLocalizedString(@"60s后重新获取", nil) forState:UIControlStateNormal];
//    [getAuthcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getAuthcodeBtn addTarget:self action:@selector(clickGetAuthcodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAuthcodeBtn];
    
//    [self getCodeTimerControl:getAuthcodeBtn];
    [self doGetCode:getAuthcodeBtn];
    
    RLButton *nextBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(120, 110, 80, 40)];
    [nextBtn regulateFrameOriginX];
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

    UILabel *authcodeTipLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(20, 170, 290, 20)];
    [authcodeTipLB regulateFrameOriginX];
    authcodeTipLB.font = [UIFont systemFontOfSize:12.0];
    authcodeTipLB.text = [NSString stringWithFormat:NSLocalizedString(@"验证码已发送到:%@, 请查收", nil), [User sharedUser].phone];
    authcodeTipLB.textColor = [UIColor lightGrayColor];
    [self.view addSubview:authcodeTipLB];
}

- (void)clickGetAuthcodeBtn:(UIButton *)button {
    [self doGetCode:button];
}

- (void)clickNextBtn:(UIButton *)button {
    [self endEditing];
    if(![self.authcodeTF.text isMobileAuthCode]) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"手机验证码输入有误", nil)];
        
        return;
    }
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"验证中。。。", nil)];
    [self.controller verifyMobileAuthCodeRequest:self.authcodeTF.text withPhoneNumber:[User sharedUser].phone];
}

- (void)doGetCode:(UIButton *)btn
{
    [self.controller mobileAuthCodeRequest:[User sharedUser].phone appId:@"test"];
    [self getCodeTimerControl:btn];
}

- (void)getCodeTimerControl:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    [btn setBackgroundColor:[UIColor orangeColor]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLb) userInfo:btn repeats:YES];
}

- (void)updateLb
{
    UIButton *btn = (UIButton *)self.timer.userInfo;
    
    if(count <= 0){
        count = 60;
        btn.userInteractionEnabled = YES;
        [btn setTitle:[NSString stringWithFormat:NSLocalizedString(@"获取验证码", nil)] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        [self.timer invalidate], self.timer = nil;
    }
    else{
        [btn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ds后重新获取", nil), count] forState:UIControlStateNormal];
    }
    count--;
}

- (void)verifyMobileAuthCodeResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    if(response.status == 0) {
        block = ^(){
            CompleteRegisterinfoVC *vc = [[CompleteRegisterinfoVC alloc] init];
            
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
