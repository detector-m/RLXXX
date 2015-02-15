//
//  ProfileModifyVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileModifyVC.h"
#import "MineController.h"

@interface ProfileModifyVC () <MineControllerDelegate>
@property (nonatomic, readwrite, strong) RLInputView *modifyInputView;
@property (nonatomic, strong) MineController *controller;
@end

@implementation ProfileModifyVC
- (void)dealloc {
    [self dataDoClean];
    self.modifyInputView = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    return [super navigationShouldPopOnBackButton];
}

- (void)dataDoClean {
    
    self.controller.delegate = nil;
    self.controller = nil;
}
- (void)dataDoLoad {

    self.controller = [[MineController alloc] init];
    self.controller.delegate = self;

//    self.controller.accessToken = [User sharedUser].accessToken;
}


- (instancetype)initWithStyle:(RLInputViewStyle)style {
    if(self = [super init]) {
        [self modifyInputViewDoLoadWithStyle:style];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataDoLoad];
}

- (void)modifyInputViewDoLoadWithStyle:(RLInputViewStyle)style {
    CGRect frame = self.view.frame;
    
    if(style == kRLInputViewStyleTextField) {
        self.modifyInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextField andFrame:CGRectMake(10, 44, frame.size.width-20, 44)];
    }
    else {
        self.modifyInputView = [[RLInputView alloc] initWithInputViewStyle:kRLInputViewStyleTextView andFrame:CGRectMake(10, 44, frame.size.width-20, 88)];
    }
    [self.view addSubview:self.modifyInputView];
}

- (void)clickCommitBtn:(UIBarButtonItem *)item {
    [self endEditing];
    if([self.modifyInputView.textInputView isKindOfClass:[UITextField class]]) {
        NSString *text = ((UITextField *)self.modifyInputView.textInputView).text;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(text.length == 0) {
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"昵称输入有误！", nil)];
            return;
        }

        [self.controller updateUserInfoRequest:text sex:nil city:nil headPortrait:nil age:nil signature:nil accessToken:[User sharedUser].accessToken];
        
        [GVPopViewManager showActivityForView:self.view];
    }
    else {
        NSString *text = ((UITextView *)self.modifyInputView.textInputView).text;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(text.length == 0) {
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"个性签名输入有误！", nil)];
            return;
        }

        [self.controller updateUserInfoRequest:nil sex:nil city:nil headPortrait:nil age:nil signature:text accessToken:[User sharedUser].accessToken];
        [GVPopViewManager showActivityForView:self.view];
    }
}

#pragma mark - response delegates
- (void)updateUserInfoResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    [GVPopViewManager removeActivity];

    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"更新头像失败！", nil)];
        };
    }
    else {
        [GVPopViewManager removeActivity];
        User *user = [User sharedUser];
        if([self.modifyInputView.textInputView isKindOfClass:[UITextField class]]) {
            user.nickname = ((UITextField *)self.modifyInputView.textInputView).text;
        }
        else {
            user.signature = ((UITextView *)self.modifyInputView.textInputView).text;
        }
        __weak ProfileModifyVC *weakSelf = self;
        block = ^(){
            [weakSelf.superVC reloadData];
            [ChangeVCController popViewControllerByNavigationController:weakSelf.navigationController];
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"修改成功", nil)];
        };
    }
    
    [self mainThreadAsync:block];
}
@end
