//
//  RLImageCropViewController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLImageCropViewController.h"
#import "RLImage.h"

#define BOUNDCE_DURATION 0.3f

@interface RLImageCropViewController ()
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *editedImage;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect lastestFrame;
@end

@implementation RLImageCropViewController

- (void)dealloc {
    _originalImage = nil;
    _editedImage = nil;
    _imageView = nil;
    _overlayView = nil;
    _ratioView = nil;
}

- (id)initWithImage:(UIImage *)oriImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRation {
    self = [super init];
    if(self) {
        _cropFrame = cropFrame;
        _limitRatio = limitRation;
//        _originalImage = oriImage;
        _originalImage = [RLImage fixOrientation:oriImage];
        oriImage = nil;
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    [self initBtns];
}

- (void)initViews {
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _imageView.multipleTouchEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    _imageView.image = _originalImage;
    
    //scale to fit the screen
    CGFloat oriW = _cropFrame.size.width;
    CGFloat oriH = _originalImage.size.height * (oriW/_originalImage.size.width);
    CGFloat oriX = _cropFrame.origin.x;// + (_cropFrame.size.width - oriW) / 2;
    CGFloat oriY = _cropFrame.origin.y + (_cropFrame.size.height-oriH)/2;
    
    _oldFrame = CGRectMake(oriX, oriY, oriW, oriH);
    _lastestFrame = _oldFrame;
    /*
     _oldFrame = self.view.bounds;
     */
    _imageView.frame = _oldFrame;
    
    
    _largeFrame = CGRectMake(0, 0, _limitRatio*_oldFrame.size.width, _limitRatio*_oldFrame.size.height);
    
    [self.view addSubview:_imageView];
    
    _overlayView = [[UIView alloc] init];
    _overlayView.frame = self.view.bounds;
    _overlayView.alpha = 0.5f;
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.userInteractionEnabled = NO;
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_overlayView];
    
    _ratioView = [[UIView alloc] init];
    _ratioView.frame = _cropFrame;
    _ratioView.layer.borderColor = _cropBorderColor ? _cropBorderColor.CGColor : [UIColor orangeColor].CGColor;
    _ratioView.layer.borderWidth = 1.0f;
    _ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:_ratioView];
    
    [self overlayClipping];
    [self addGestures];
}

- (void)initBtns {
    UIButton *cancelBtn = [self createBtn:NSLocalizedString(@"取消", nil)];
    cancelBtn.frame = CGRectMake(10, self.view.frame.size.height-50, 100, 45);
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [self createBtn:NSLocalizedString(@"确定", nil)];
    confirmBtn.frame = CGRectMake(self.view.frame.size.width-110, self.view.frame.size.height-50, 100, 45);
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (UIButton *)createBtn:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    return btn;
}


- (void)clickCancelBtn:(UIButton *)btn {
    if(_delegate &&
       /*[_delegate conformsToProtocol:@protocol(ImageCropDelegate)]*/
       [(id)_delegate respondsToSelector:@selector(imageCropDidCancel:)]) {
        [_delegate imageCropDidCancel:self];
    }
    
//    [self dismissVC:self];
}

- (void)clickConfirmBtn:(UIButton *)btn {
    if(_delegate && [(id)_delegate respondsToSelector:@selector(imageCrop:didFinished:)]) {
        [_delegate imageCrop:self didFinished:[self cropImage]];
    }
//    [self dismissVC:self];
}

- (void)dismissVC:(UIViewController *)vc {
    if(![vc isBeingDismissed]) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)overlayClipping {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    //    CGRect t1 = _ratioView.frame;
    //    CGRect t2 = _overlayView.frame;
    
    CGRect left = CGRectMake(0,
                             0,
                             _ratioView.frame.origin.x,
                             _overlayView.frame.size.height);
    CGRect right = CGRectMake(
                              _ratioView.frame.origin.x+_ratioView.frame.size.width,
                              0,
                              _overlayView.frame.size.width-_ratioView.frame.origin.x-_ratioView.frame.size.width,
                              _overlayView.frame.size.height);
    CGRect top = CGRectMake(0,
                            0,
                            _overlayView.frame.size.width,
                            _ratioView.frame.origin.y);
    CGRect bottom = CGRectMake(0,
                               _ratioView.frame.origin.y+_ratioView.frame.size.height,
                               _overlayView.frame.size.width,
                               _overlayView.frame.size.height-_ratioView.frame.origin.y-_ratioView.frame.size.height);
    
    // ratioView 的左边
    CGPathAddRect(path, NULL, left);
    // ratioView 的右边
    CGPathAddRect(path, NULL, right);
    // ratioView 的上边
    CGPathAddRect(path, NULL, top);
    // ratioView 的下边
    CGPathAddRect(path, NULL, bottom);
    maskLayer.path = path;
    _overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

- (void)addGestures {
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] init];
    [pinGesture addTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [panGesture addTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)pinchView:(UIPinchGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan ||
       gesture.state == UIGestureRecognizerStateChanged) {
        _imageView.transform = CGAffineTransformScale(_imageView.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = _imageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        __weak UIImageView *view = _imageView;
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            view.frame = newFrame;
            _lastestFrame = newFrame;
        }];
    }
}

- (void)panView:(UIPanGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan ||
       gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat absCenterX = _cropFrame.origin.x + _cropFrame.size.width/2;
        CGFloat absCenterY = _cropFrame.origin.y + _cropFrame.size.height/2;
        CGFloat scaleRatio = _imageView.frame.size.width/_cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX-_imageView.center.x) / (scaleRatio*absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY-_imageView.center.y) / (scaleRatio*absCenterY);
        CGPoint translation = [gesture translationInView:_imageView.superview];
        _imageView.center = CGPointMake(_imageView.center.x+translation.x*acceleratorX, _imageView.center.y+translation.y*acceleratorY);
        [gesture setTranslation:CGPointZero inView:_imageView.superview];
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = _imageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            _imageView.frame = newFrame;
            _lastestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)theFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(theFrame.origin.x+theFrame.size.width/2, theFrame.origin.y+theFrame.size.height/2);
    if(theFrame.size.width < _oldFrame.size.width) {
        theFrame = _oldFrame;
    }
    if(theFrame.size.width > _largeFrame.size.width) {
        theFrame = _largeFrame;
    }
    theFrame.origin.x = oriCenter.x - theFrame.size.width/2;
    theFrame.origin.y = oriCenter.y - theFrame.size.height/2;
    
    return theFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)theFrame {
    //水平
    if(theFrame.origin.x > _cropFrame.origin.x) {
        theFrame.origin.x = _cropFrame.origin.x;
    }
    if(CGRectGetMaxX(theFrame) < _cropFrame.origin.x + _cropFrame.size.width) {
        theFrame.origin.x = _cropFrame.origin.x + _cropFrame.size.width  - theFrame.size.width;
    }
    //垂直
    if(theFrame.origin.y > _cropFrame.origin.y) {
        theFrame.origin.y = _cropFrame.origin.y;
    }
    if(CGRectGetMaxY(theFrame) < _cropFrame.origin.y+_cropFrame.size.height) {
        theFrame.origin.y = _cropFrame.origin.y + _cropFrame.size.height - theFrame.size.height;
    }
    
    //适配水平的矩形
    if(_imageView.frame.size.width > _imageView.frame.size.height &&
       theFrame.size.height <= _cropFrame.size.height) {
        theFrame.origin.y = _cropFrame.origin.y + (_cropFrame.size.height - theFrame.size.height) / 2;
    }
    
    return theFrame;
}

#define ICON_WIDTH 80

- (UIImage *)cropImage {
    CGRect squareFrame = _cropFrame;
    CGFloat scaleRatio = _lastestFrame.size.width / _originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - _lastestFrame.origin.x)/scaleRatio;
    CGFloat y = (squareFrame.origin.y - _lastestFrame.origin.y)/scaleRatio;
    CGFloat w = squareFrame.size.width/scaleRatio;
    CGFloat h = squareFrame.size.height/scaleRatio;
    
    if(_lastestFrame.size.width < _cropFrame.size.width) {
        CGFloat newW = _originalImage.size.width;
        CGFloat newH = newW*(_cropFrame.size.height/_cropFrame.size.width);
        x = 0;
        y = y+(h-newH)/2;
        w = newH;
        h = newH;
    }
    
    if(_lastestFrame.size.height < _cropFrame.size.height) {
        CGFloat newH = _originalImage.size.height;
        CGFloat newW = newH*(_cropFrame.size.width/_cropFrame.size.height);
        x = x+(w-newW)/2;
        y = 0;
        w = newH;
        h = newH;
    }
    
    CGRect imageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = _originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, imageRect);
    CGSize size = imageRect.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextRotateCTM(context, -M_PI_2);
    CGContextDrawImage(context, imageRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    _editedImage = smallImage;
    _originalImage = nil;
    CGImageRelease(subImageRef);
    
    smallImage = [self iconImage:smallImage];
    
    return smallImage;
}

- (UIImage *)iconImage:(UIImage *)image {
    UIImage *subImage = image;
    CGFloat ratio = 1;
    if(subImage.size.width > ICON_WIDTH*2) {
        ratio = (ICON_WIDTH*2)/image.size.width;
        subImage = [RLImage scaleImage:subImage toScale:ratio];
    }
    else if(subImage.size.height > ICON_WIDTH*2) {
        ratio = (ICON_WIDTH*2)/image.size.height;
        subImage = [RLImage scaleImage:subImage toScale:ratio];
    }
    return subImage;
}

@end
