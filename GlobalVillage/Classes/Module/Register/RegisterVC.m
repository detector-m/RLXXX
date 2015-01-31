//
//  RegisterVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RegisterVC.h"
#import "RLLabel.h"
#import "RLButton.h"
#import "RLTextField.h"

#import "PhoneAuthCodeVC.h"

#import "RegisterController.h"

@interface RegisterVC () <RegisterControllerDelegate>
@property (nonatomic, readwrite, strong) RLTextField *phoneTF;
@property (nonatomic, readwrite, assign) BOOL cheked;

@property (nonatomic, readwrite, strong) RegisterController *controller;
@end

@implementation RegisterVC

- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dataDoLoad {
    self.controller = [[RegisterController alloc] init];
    self.controller.delegate = self;
}

- (BOOL)navigationShouldPopOnBackButton {
    return [super navigationShouldPopOnBackButton];
}

- (void)navigationDidPopOnBackButton {
    [self.controller removeAllRequest];
    [super navigationDidPopOnBackButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"手机注册", nil);
    
    [self dataDoLoad];
    [self subviewsDoLoad];
}

- (void)subviewsDoLoad {
    UIView *phoneNumInputView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, self.view.bounds.size.width-30, 40)];
    //    phView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:phoneNumInputView];
    phoneNumInputView.layer.cornerRadius = 5;
    phoneNumInputView.layer.borderWidth = 1;
    phoneNumInputView.layer.borderColor = [[UIColor grayColor] CGColor];
    phoneNumInputView.layer.masksToBounds = NO;
    
    UILabel *areaNumLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(0, 0, 80, 40)];
    areaNumLB.textColor = [UIColor blueColor];
    areaNumLB.text = NSLocalizedString(@"中国＋86", nil);
    [phoneNumInputView addSubview:areaNumLB];
    
    UILabel *vLineLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(81, 0, 1, 40)];
    vLineLB.backgroundColor = [UIColor grayColor];
    [phoneNumInputView addSubview:vLineLB];
    
    self.phoneTF = (RLTextField *)[ViewConstructor constructDefaultTextField:[RLTextField class] withFrame:CGRectMake(88, 0, phoneNumInputView.bounds.size.width-88, 40)];
    self.phoneTF.borderStyle = UITextBorderStyleNone;
    self.phoneTF.placeholder = NSLocalizedString(@"请输入你的手机号", nil);
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneNumInputView addSubview:self.phoneTF];
    
    RLButton *nextBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(120, 110, 80, 40)];
    [nextBtn regulateFrameOriginX];
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    self.cheked = YES;
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(15, 190, 20, 20);
    [checkBtn setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
    [checkBtn setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setSelected:self.cheked];
    [self.view addSubview:checkBtn];
    
    UILabel *authLB = (UILabel *)[ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(35, 190, 90, 20)];
    authLB.text = NSLocalizedString(@"我已阅读并同意", nil);
    authLB.font = [UIFont systemFontOfSize:12];
    authLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:authLB];
    
    UILabel *dealLB = [[UILabel alloc] initWithFrame:CGRectMake(125, 190, 145, 20)];
    dealLB.textAlignment = NSTextAlignmentLeft;
    dealLB.textColor = [UIColor blueColor];
    dealLB.font = [UIFont systemFontOfSize:12];
    dealLB.text = NSLocalizedString(@"地球村软件许可及服务协议", nil);
    [self.view addSubview:dealLB];
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 145, 1)];
    lineLb.backgroundColor = [UIColor blueColor];
    [dealLB addSubview:lineLb];
}

- (void)clickNextBtn:(UIButton *)button {
    [self endEditing];

    if(![self.phoneTF.text isMobile] || !self.cheked) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"请检查手机号和阅读协议！", nil)];
        return;
    }
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"手机号确认。。。", nil)];
    [User sharedUser].phone = self.phoneTF.text;
    
    [self.controller verifyPhoneNumberRequest:self.phoneTF.text];
}

- (void)clickCheckBtn:(UIButton *)button {
    self.cheked = !self.cheked;
    button.selected = self.cheked;
}

//request delegate
- (void)request:(RLRequest *)request
  didLoadFailed:(id)result {
    DLog(@"%@", result);
    [User sharedUser].phone = nil;
}

- (void)verifyPhoneNumberResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    //可用
    if([response.responseData integerValue] == 0) {
        block = ^(){
            [GVPopViewManager removeActivity];
            PhoneAuthCodeVC *vc = [[PhoneAuthCodeVC alloc] init];
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        };
    }
    else {
        block = ^() {
            [GVPopViewManager removeActivity];
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"手机号已被注册！", nil)];
        };
    }
    [self mainThreadAsync:block];
}
@end
