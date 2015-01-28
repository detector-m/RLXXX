//
//  RLImageCropViewController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLImageCropViewController;

@protocol RLImageCropDelegate
@optional
- (void)imageCrop:(RLImageCropViewController *)cropVC didFinished:(UIImage *)editedImage;
- (void)imageCropDidCancel:(RLImageCropViewController *)cropVC;
@end

@interface RLImageCropViewController : UIViewController
@property (nonatomic, weak) id<RLImageCropDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, weak) UIColor *cropBorderColor;

- (id)initWithImage:(UIImage *)oriImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRation;
@end
