//
//  CompleteRegisterinfoVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "CompleteRegisterinfoVC.h"
#import "RLTextField.h"
#import "RLRadioButton.h"

#import "RLImageCropViewController.h"
#import "ChooseDQNumberVC.h"

//性别 0->女 , 1->男
typedef NS_ENUM(NSUInteger, GenderType) {
    kGenderTypeWom = 0,
    kGenderTypeMan = 1,
};
@interface CompleteRegisterinfoVC ()<RLImageCropDelegate>
@property (nonatomic, readwrite, strong) UIButton *pickPicBtn;
@property (nonatomic, readwrite, strong) RLRadioButton *manBtn;
@property (nonatomic, readwrite, strong) RLRadioButton *womBtn;

@property (nonatomic, readwrite, strong) RLTextField *nameTF;

@property (nonatomic, readwrite, assign) GenderType gender;
@end

@implementation CompleteRegisterinfoVC

//- (BOOL)navigationShouldPopOnBackButton {
//    [self.controller removeAllRequest];
//    
//    return [super navigationShouldPopOnBackButton];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"完善注册信息", nil);
    
    [self subviewsDoLoad];
}

- (void)subviewsDoLoad {
    CGRect frame = self.view.frame;
    self.pickPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pickPicBtn.frame = CGRectMake(120, 20, 80, 80);
    [self.pickPicBtn regulateFrameOriginX];
    [self.pickPicBtn setImage:[UIImage imageNamed:@"PicDefault.png"] forState:UIControlStateNormal];
    [self.pickPicBtn addTarget:self action:@selector(clickPickPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pickPicBtn];
    self.pickPicBtn.imageView.layer.cornerRadius = 5;
    self.pickPicBtn.layer.cornerRadius = 10;
    
    self.nameTF = (RLTextField *)[ViewConstructor constructDefaultTextField:[RLTextField class] withFrame:CGRectMake(10, 120, self.view.bounds.size.width-20, 40)];
//    nameTf.text = _user.user_nickname;
    self.nameTF.placeholder = NSLocalizedString(@"请填写用户名", nil);
    [self.view addSubview:self.nameTF];
    
    //性别 0->女 , 1->男
    self.gender = kGenderTypeMan;

    self.manBtn = [self constructRadioButtonFrame:CGRectMake(40, 180, 60, 20)];
    self.manBtn.label.text = NSLocalizedString(@"男", nil);
    [self.manBtn addTarget:self action:@selector(clickManBtn:)];
    self.manBtn.button.selected = YES;
    [self.view addSubview:self.manBtn];
    
    self.womBtn = [self constructRadioButtonFrame:CGRectMake(frame.size.width-40-60, 180, 60, 20)];
    self.womBtn.label.text = NSLocalizedString(@"女", nil);
    [self.womBtn addTarget:self action:@selector(clickWomBtn:)];
    [self.view addSubview:self.womBtn];
    
    UILabel *warnLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 20)];
    [warnLb regulateFrameOriginX];
    warnLb.textAlignment = NSTextAlignmentLeft;
    warnLb.textColor = [UIColor lightGrayColor];
    warnLb.font = [UIFont systemFontOfSize:12];
    warnLb.text = NSLocalizedString(@"建议使用真实信息，让你的朋友更容易认出你", nil);
    [self.view addSubview:warnLb];
    
    RLButton *completeBtn = (RLButton *)[ViewConstructor constructDefaultButton:[RLButton class] withFrame:CGRectMake(110, 270, 100, 40)];
    [completeBtn regulateFrameOriginX];
    [completeBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(clickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
}

- (RLRadioButton *)constructRadioButtonFrame:(CGRect)frame {
    RLRadioButton *radioButton = [[RLRadioButton alloc] initWithFrame:frame];
    [radioButton.button setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
    [radioButton.button setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
    return radioButton;
}

- (void)clickPickPicBtn:(UIButton *)button {
    [self endEditing];
    
    [self showActionSheet];
}

- (void)clickManBtn:(id)button {
    [self endEditing];
    if(!self.manBtn.button.selected){
        self.manBtn.button.selected = !self.manBtn.button.selected;
        self.womBtn.button.selected = !self.womBtn.button.selected;
        
        self.gender = kGenderTypeMan;
    }
}

- (void)clickWomBtn:(id)button {
    [self endEditing];
    if(!self.womBtn.button.selected){
        self.womBtn.button.selected = !self.womBtn.button.selected;
        self.manBtn.button.selected = !self.manBtn.button.selected;
        
        self.gender = kGenderTypeWom;
    }
}

- (void)clickCompleteBtn:(UIButton *)button {
    [self endEditing];
    
    UIImage *image = [self.pickPicBtn imageForState:UIControlStateNormal];
    
    [User sharedUser].pic = UIImagePNGRepresentation(image);
    [User sharedUser].gender = self.gender;
    [User sharedUser].nickname = self.nameTF.text;
    
    ChooseDQNumberVC *vc = [[ChooseDQNumberVC alloc] init];
    [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *theImage = nil;
    __weak CompleteRegisterinfoVC *weakSelf = self;
 
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
    [picker dismissViewControllerAnimated:YES completion:completionBlock];
}

#pragma makr - 图片裁剪 －> ImageCropDelegate
- (void)imageCrop:(RLImageCropViewController *)cropVC didFinished:(UIImage *)editedImage {
    [self.pickPicBtn setImage:editedImage forState:UIControlStateNormal];
}

//- (void)imageCropDidCancel:(RLImageCropViewController *)cropVC {
//}

@end
