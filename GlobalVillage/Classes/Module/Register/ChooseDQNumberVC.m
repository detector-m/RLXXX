//
//  ChooseDQNumberVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChooseDQNumberVC.h"

#import "RLRadioButton.h"
#import "DQNumberCell.h"

#import "PasswordSettingVC.h"

#import "RegisterController.h"

#import "URBAlertView.h"

//获取地球号 isCharge-> 1 收费  0免费
typedef NS_ENUM(NSUInteger, ChargeType) {
    kChargeTypeFree = 0,
    kChargeTypeCharge = 1,
};
@interface ChooseDQNumberVC () <RegisterControllerDelegate>
@property (nonatomic, readwrite, strong) RLRadioButton *freeRadioBtn;
@property (nonatomic, readwrite, strong) RLRadioButton *chargeRadioBtn;

@property (nonatomic, readwrite, strong) UICollectionView *numberCollectionView;

@property (nonatomic, readwrite, strong) NSArray *freeDQNumbers;
@property (nonatomic, readwrite, weak) NSString *selectedDQNumber;
@property (nonatomic, readwrite, assign) ChargeType chargeType;

@property (nonatomic, readwrite, strong) RegisterController *controller;
@end

@implementation ChooseDQNumberVC
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
    
    self.title = NSLocalizedString(@"选择地球号", nil);
    
    [self dataDoLoad];
    
    [self topViewDoLoad];
    [self middleViewDoLoad];
    [self bottomViewDoLoad];
    
    [self.controller dqNumberList:kChargeTypeFree andCount:20];
    [GVPopViewManager showActivity];
}

//顶部view的加载
- (void)topViewDoLoad {
    CGRect frame = self.view.frame;
    
    UILabel *warnLB = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(10, 10, frame.size.width-20, 20)];
    warnLB.text = NSLocalizedString(@"选择地球号后，可以用它直接登录，请牢记你的地球号", nil);
    warnLB.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:warnLB];
    
    self.chargeType = kChargeTypeFree;
    self.freeRadioBtn = [self constructRadioButtonFrame:CGRectMake(40, 35, 80, 20)];
    [self.freeRadioBtn regulateFrameOrigin];
    self.freeRadioBtn.label.text = NSLocalizedString(@"免费", nil);
    [self.freeRadioBtn addTarget:self action:@selector(clickFreeRadioBtn:)];
    self.freeRadioBtn.button.selected = YES;
    [self.view addSubview:self.freeRadioBtn];
    
//    self.chargeRadioBtn = [self constructRadioButtonFrame:CGRectMake(160, 35, 80, 20)];
//    [self.chargeRadioBtn regulateFrameOrigin];
//    self.chargeRadioBtn.label.text = NSLocalizedString(@"靓号", nil);
//    [self.chargeRadioBtn addTarget:self action:@selector(clickChargeRadioBtn:)];
//    [self.view addSubview:self.chargeRadioBtn];
}

- (RLRadioButton *)constructRadioButtonFrame:(CGRect)frame {
    RLRadioButton *radioButton = [[RLRadioButton alloc] initWithFrame:frame];
    [radioButton.button setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
    [radioButton.button setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
    return radioButton;
}

- (void)clickFreeRadioBtn:(id)button {
    [self endEditing];
    if(!self.freeRadioBtn.button.selected) {
        self.freeRadioBtn.button.selected = !self.freeRadioBtn.button.selected;
        self.chargeRadioBtn.button.selected = !self.chargeRadioBtn.button.selected;
        
        self.chargeType = kChargeTypeFree;
    }
}

- (void)clickChargeRadioBtn:(id)button {
    [self endEditing];
    if(!self.chargeRadioBtn.button.selected){
        self.chargeRadioBtn.button.selected = !self.chargeRadioBtn.button.selected;
        self.freeRadioBtn.button.selected = !self.freeRadioBtn.button.selected;
        
        self.chargeType = kChargeTypeCharge;
    }
}

- (void)middleViewDoLoad {
    CGRect frame = self.view.frame;
    frame.origin.y = 60;
    
    self.numberCollectionView = [self defaultCollectionView];
    self.numberCollectionView.frame = frame;
    [self.numberCollectionView regulateFrameOrigin];
    frame = self.numberCollectionView.frame;
    frame.size.height -= (frame.origin.y+50);
    self.numberCollectionView.frame = frame;
    [self.numberCollectionView registerClass:[DQNumberCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [self.view addSubview:self.numberCollectionView];
}

- (UICollectionView *)defaultCollectionView {
    UICollectionView *aCollectionView = nil;
    UICollectionViewFlowLayout *aCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aCollectionViewFlowLayout];
    aCollectionView.dataSource = self;
    aCollectionView.delegate = self;
    
    aCollectionView.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
    aCollectionView.backgroundColor = [UIColor lightGrayColor];
    
    return aCollectionView;
}

//底部button 的加载
- (void)bottomViewDoLoad {
    CGRect frame = self.view.frame;
    
    UIButton *confirmBtn = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(20, 387, frame.size.width-40, 40)];
//    [confirmBtn regulateFrameOrigin];
    [confirmBtn regulateFrameOriginY];
    [confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
//    UIButton *skipBtn = [ViewConstructor constructDefaultButton:[UIButton class] withFrame:CGRectMake(frame.size.width-20-120, 387, 120, 40)];
//    [skipBtn regulateFrameOrigin];
//    [skipBtn setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
//    [skipBtn addTarget:self action:@selector(clickSkipBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:skipBtn];
}

- (void)clickConfirmBtn:(UIButton *)button {
    if(self.selectedDQNumber == nil) {
        [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"未选择地球号!!!", nil)];
        return;
    }
    
    [self.controller verifyDQNumber:self.selectedDQNumber];
//    [self pushToPasswordSettingVC];
}

- (void)clickAlertViewConfirm {
    self.selectedDQNumber = [self.freeDQNumbers objectAtIndex:(arc4random()%self.freeDQNumbers.count)];
    [self pushToPasswordSettingVC];
}

- (void)pushToPasswordSettingVC {
    [User sharedUser].dqNumber = self.selectedDQNumber;
    PasswordSettingVC *vc = [[PasswordSettingVC alloc] init];
    [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
}

- (void)clickSkipBtn:(UIButton *)button {
    __block ChooseDQNumberVC *blockSelf = self;

    void (^alertHandlerBlock)(NSInteger buttonIndex, URBAlertView *theAlertView) = ^(NSInteger buttonIndex, URBAlertView *theAlertView) {
        //确定按钮
        if(buttonIndex == 0) {
            [blockSelf clickAlertViewConfirm];
        }
        
        [theAlertView hideWithCompletionBlock:^{ }];
    };
    
     URBAlertView *alertView = [URBAlertView dialogWithTitle:NSLocalizedString(@"跳过后将随机给你分配地球号，确定跳过吗？", nil) subtitle:nil];
    alertView.blurBackground = NO;
    [alertView addButtonWithTitle:NSLocalizedString(@"确定", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    
    [alertView setHandlerBlock:alertHandlerBlock];
    [alertView showWithAnimation:URBAlertAnimationDefault];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:
(NSInteger)section {
    if(self.chargeType == kChargeTypeFree) {
        return self.freeDQNumbers.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DQNumberCell *cell = [cv dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
//    NSString *numStr = self.chargeType == kChargeTypeCharge ? [[_dataChargeDQNumArray objectAtIndex:indexPath.row] objectForKey:RespondFieldChikyugoKey] : [[_dataFreeDQNumArray objectAtIndex:indexPath.row] objectForKey:RespondFieldChikyugoKey];
    
    cell.textLabel.text = [self.freeDQNumbers objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

//cell的子view

- (CGSize)collectionView:(UICollectionView *)aCollectionView layout:(UICollectionViewLayout *)aCollectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(aCollectionView.frame.size.width/2-0.5, 40);
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        //    [self deselectItem];
    self.selectedDQNumber = [self.freeDQNumbers objectAtIndex:indexPath.row];
//    NSString *str = [NSString stringWithFormat:@"请牢记该地球号：%@", self.selectedDQNumber];
//    [GVPopViewManager showDialogWithTitle:NSLocalizedString(str, nil)];
}

- (void)deselectItem {
    for(NSIndexPath *path in [self.numberCollectionView indexPathsForSelectedItems]) {
        [self.numberCollectionView deselectItemAtIndexPath:path animated:YES];
    }
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

- (void)collectionViewReload {
    [self.numberCollectionView reloadData];
}

#pragma mark - RegisterControllerDelegate
- (void)freeDQNumberListResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status == 0) {
        block = ^() {
            self.freeDQNumbers = response.responseData;
            [self collectionViewReload];
        };
    }
    else {
        block = ^() {
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"地球号获取失败", nil)];
        };
    }
    
    [self mainThreadAsync:block];
}

- (void)chargeDQNumberListResponse:(GVResponse *)response {
    dispatch_block_t block = nil;
    if(response.status == 0) {
        block = ^() {
            [self collectionViewReload];
        };
    }
    else {
        block = ^() {
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"地球号获取失败", nil)];
        };
    }
    
    [self mainThreadAsync:block];
}

- (void)verifyDQNumberResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response.status != 0) {
        block = ^() {
            [GVPopViewManager showDialogWithTitle:@"该地球号已被占用！"];
        };
    }
    else {
        block = ^() {
            [self pushToPasswordSettingVC];
        };
    }
    [self mainThreadAsync:block];
}
@end
