//
//  RLPickerViewController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RLPickerViewController : RLBaseViewController
@property (nonatomic, readonly, strong) UIActionSheet *actionSheet;
- (BOOL)isCameraAvailable;
- (BOOL)isRearCameraAvailable;
- (BOOL)isFrontCameraAvailable;
- (BOOL)isPhotoLibraryAvailable;

//- (UIActionSheet *)actionSheet;
- (void)showActionSheet;
@end
