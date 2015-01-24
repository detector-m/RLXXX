//
//  RLPickerViewController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLPickerViewController.h"

@interface RLPickerViewController () <UIImagePickerControllerDelegate>
@property (nonatomic, readwrite, strong) UIActionSheet *actionSheet;
@end

@implementation RLPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actionSheet = [self constructActionSheet];
}

- (UIActionSheet *)constructActionSheet {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:((id<UIActionSheetDelegate>)self) cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),
                                  NSLocalizedString(@"相册", nil), nil];
    
    return choiceSheet;
}

- (void)showActionSheet {
    if(self.actionSheet) {
        [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)btnIndex {
    if(btnIndex > 1)
        return;
    
    UIImagePickerController *imagePickVC = [[UIImagePickerController alloc] init];
    NSMutableArray *mediaTypes = [NSMutableArray array];
    [mediaTypes addObject:(__bridge NSString*)kUTTypeImage];
    imagePickVC.mediaTypes = mediaTypes;
    imagePickVC.delegate = (id)self;

    if(btnIndex == 0) { //拍照
        if([self isCameraAvailable]) {
            imagePickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else if(btnIndex == 1) { //相册
        if([self isPhotoLibraryAvailable]) {
            imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    [self presentViewController:imagePickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    void (^completionBlock)() = nil;
    [picker dismissViewControllerAnimated:YES completion:completionBlock];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    void (^completionBlock)() = nil;
    
    [picker dismissViewControllerAnimated:YES completion:completionBlock];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return YES;
}
@end
