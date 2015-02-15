//
//  ProfileVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileVC.h"
#import "MineVC.h"
#import "RLUtilitiesMethods.h"
#import "ProfileTitleCell.h"
#import "ProfileCommonCell.h"

#import "ProfileModifyVC.h"
#import "BirthdaySettingVC.h"
#import "GenderSettingVC.h"

#import "RLImageCropViewController.h"
#import "ImageController.h"
#import "MineController.h"

@interface ProfileVC () <RLImageCropDelegate, ImageControllerDelegate, MineControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLTableModel *tableModel;
@property (nonatomic, weak) UIButton *imageButton;
@property (nonatomic, strong) UIImage *updatePicImage;

@property (nonatomic, readwrite, strong) ImageController *controller;
@property (nonatomic, readwrite, strong) MineController *mineController;
@end

@implementation ProfileVC
- (void)dealloc {
    [self dataDoClean];
    self.tableView = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.controller removeAllRequest];
    [self.mineController removeAllRequest];
    return [super navigationShouldPopOnBackButton];
}

- (void)dataDoClean {
    self.tableModel = nil;
    
    self.controller.delegate = nil;
    self.controller = nil;
    
    self.mineController.delegate = nil;
    self.mineController = nil;
}
- (void)dataDoLoad {
    self.tableModel = [[RLTableModel alloc] init];
    NSArray *array = [NSArray arrayWithContentsOfFile:resourcePathWithResourceName(@"ProfileConfig.plist")];
    [self.tableModel.datas addObjectsFromArray:array];
    
    self.controller = [[ImageController alloc] init];
    self.controller.delegate = self;
    
    self.mineController = [[MineController alloc] init];
    self.mineController.delegate = self;
    
    self.controller.accessToken = [User sharedUser].accessToken;
    
    self.updatePicImage = [UIImage imageNamed:@"PicDefault.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"个人信息", nil);
    [self dataDoLoad];
    [self tableViewDoLoad];
    
    User *user = [User sharedUser];
    [self.controller downloadImageRequest:user.picUrl imageScale:@"1" accessToken:user.accessToken];
}

- (void)tableViewDoLoad {
    if(self.tableView) {
        return;
    }
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0f, 0.0f);//{0.0f, 0.0f};
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
#define kMineSections 1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kMineSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableModel.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
        return 80.0f;
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    User *user = [User sharedUser];

    if(indexPath.row == 0) {
        cell = [ViewConstructor constructCell:[ProfileTitleCell class] withIdentifier:kTableCellIdentifier withTableView:tableView];
        cell.textLabel.text = user.nickname;
        cell.detailTextLabel.text = user.dqNumber;
//        ((ProfileTitleCell *)cell).subTextLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
        if(user.pic) {
            self.updatePicImage = [UIImage imageWithData:user.pic];
        }
        else {
            [((ProfileTitleCell *)cell).imageButton setImage:[UIImage imageNamed:@"PicDefault.png"] forState:UIControlStateNormal];
        }
        [((ProfileTitleCell *)cell).imageButton removeTarget:self action:@selector(clickPicBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [((ProfileTitleCell *)cell).imageButton addTarget:self action:@selector(clickPicBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.imageButton = ((ProfileTitleCell *)cell).imageButton;
    }
    else {
        cell = [ViewConstructor constructCell:[ProfileCommonCell class] withIdentifier:kTableCellIdentifier withTableView:tableView];
        cell.textLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
            case 1:
                cell.detailTextLabel.text = user.gender == kGenderTypeMan ? NSLocalizedString(@"男", nil) : NSLocalizedString(@"女", nil);
                break;
            case 2:
                cell.detailTextLabel.text = @"1990/1/2";
                break;
            case 3:
                cell.detailTextLabel.text = user.signature;
                break;
            case 4:
                cell.detailTextLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
                break;
            case 5:
                cell.detailTextLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
                break;
            case 6:
                cell.detailTextLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
                break;
            case 7:
                cell.detailTextLabel.text = [self.tableModel.datas objectAtIndex:indexPath.row];
                break;
            case 8:
                cell.detailTextLabel.text = @"";
                break;
                
            default:
                break;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsMake(2, 3, 2, 3);
    }
    
    return cell;
}

- (void)deselectRow:(UITableView *)tableView {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.userInteractionEnabled = NO;
    User *user = [User sharedUser];
    
    switch (indexPath.row) {
        case 0: {
            ProfileModifyVC *vc = [[ProfileModifyVC alloc] initWithStyle:kRLInputViewStyleTextField];
            vc.superVC = self;
            vc.title = NSLocalizedString(@"昵称", nil);
            vc.modifyInputView.title.text = NSLocalizedString(@"昵称", nil);
            ((UITextField *)vc.modifyInputView.textInputView).text = user.nickname;
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
            break;
        case 1: {
            GenderSettingVC *vc = [[GenderSettingVC alloc] init];
            vc.superVC = self;
            vc.gender = [User sharedUser].gender;
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
            break;
        case 2: {
            BirthdaySettingVC *vc = [[BirthdaySettingVC alloc] init];
            vc.superVC = self;
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
            break;
        case 3: {
            ProfileModifyVC *vc = [[ProfileModifyVC alloc] initWithStyle:kRLInputViewStyleTextView];
            vc.superVC = self;
            vc.title = NSLocalizedString(@"个性签名", nil);
            vc.modifyInputView.title.text = NSLocalizedString(@"个性签名", nil);
            ((UITextField *)vc.modifyInputView.textInputView).text = user.signature;
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
            break;
            
        default:
            break;
    }
    
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

- (void)clickPicBtn:(UIButton *)button {
    [self showActionSheet];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *theImage = nil;
    __weak ProfileVC *weakSelf = self;
    
    //    [picker stopVideoCapture];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    void (^completionBlock)() = ^(void) {
        if(theImage == nil)
            return ;
        
        RLImageCropViewController *imgEditorVC = [[RLImageCropViewController alloc] initWithImage:theImage cropFrame:CGRectMake((weakSelf.view.frame.size.width-100)/2, (weakSelf.view.frame.size.height-100)/2, 100, 100) limitScaleRatio:5.0f];
        imgEditorVC.delegate = (id)weakSelf;
        
        void (^imgEditorCompletionBlock)() = nil;
        
        [weakSelf presentViewController:imgEditorVC animated:NO completion:imgEditorCompletionBlock];
    };
    [self dismissViewControllerAnimated:YES completion:completionBlock];
}

#pragma makr - 图片裁剪 －> ImageCropDelegate
- (void)imageCrop:(RLImageCropViewController *)cropVC didFinished:(UIImage *)editedImage {
//    [self.imageButton setImage:editedImage forState:UIControlStateNormal];
    self.updatePicImage = editedImage;
    [self.controller uploadImageRequest:editedImage accessToken:nil];
    [GVPopViewManager showActivityWithTitle:NSLocalizedString(@"等待上传头像。。。", nil) forView:self.view];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropDidCancel:(RLImageCropViewController *)cropVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImageControllerDelegate
- (void)uploadImageResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"上传头像失败！", nil)];
        };
    }
    else {
        [GVPopViewManager removeActivity];
        User *user = [User sharedUser];
        user.picUrl = response.responseData;
        [self.mineController updateUserInfoRequest:nil sex:nil city:nil headPortrait:user.picUrl age:nil signature:nil accessToken:user.accessToken];
    }
    
    [self mainThreadAsync:block];
}

- (void)downloadImageResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"获取头像失败！", nil)];
            [self.imageButton setImage:[UIImage imageNamed:@"PicDefault.png"] forState:UIControlStateNormal];
        };
    }
    else {
        [GVPopViewManager removeActivity];
//        User *user = [User sharedUser];
        [User sharedUser].pic = response.responseData;
        block = ^(){
            [self.imageButton setImage:[UIImage imageWithData:[User sharedUser].pic] forState:UIControlStateNormal];
        };
    }
    
    [self mainThreadAsync:block];
}

- (void)updateUserInfoResponse:(GVResponse *)response {
    dispatch_block_t block = NULL;
    if(response == nil || response.status != 0) {
        block = ^(){
            [GVPopViewManager showDialogWithTitle:NSLocalizedString(@"更新头像失败！", nil)];
        };
    }
    else {
        [GVPopViewManager removeActivity];

        block = ^(){
            [self.imageButton setImage:self.updatePicImage forState:UIControlStateNormal];
        };
    }
    
    [self mainThreadAsync:block];
}
@end
