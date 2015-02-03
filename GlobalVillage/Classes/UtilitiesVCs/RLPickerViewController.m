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
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation RLPickerViewController
- (void)dealloc {
    self.actionSheet = nil;
    self.imagePicker = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    self.imagePicker = nil;
}

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
    
    if([self isCameraAvailable] == NO)
        return;
    if(self.imagePicker == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(__bridge_transfer NSString*)kUTTypeImage];
//        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        self.imagePicker.mediaTypes = mediaTypes;
        self.imagePicker.delegate = (id)self;
    }

    if(btnIndex == 0) { //拍照
        if([self isCameraAvailable]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else if(btnIndex == 1) { //相册
        if([self isPhotoLibraryAvailable]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:^(){}];
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
