//
//  RLImage.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLImage.h"

@implementation RLImage
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        return img;
        
    }
}

+ (UIImage *)scaleImage:(UIImage *)originalImage toScale:(CGFloat)ratio {
    if(!originalImage) {
        return nil;
    }
    if(!ratio) {
        return originalImage;
    }
    
    ratio = fabsf(ratio);
    
    CGSize oriImgSize = originalImage.size;
    CGSize contextSize = CGSizeMake(oriImgSize.width*ratio, oriImgSize.height*ratio);
    UIGraphicsBeginImageContext(contextSize);
    [originalImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
    UIImage *subImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImg;
}

+ (UIImage *)resizeImage:(UIImage *)originalImage size:(CGSize)size {
    if(originalImage == nil) {
        return nil;
    }
    if(CGSizeEqualToSize(size, CGSizeZero)) {
        return originalImage;
    }
    
    size = CGSizeMake(fabsf(size.width), fabsf(size.height));
    
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *subImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImg;
}

+ (UIImage *)captureView:(UIView *)view {
    if(view == nil)
        return nil;
    
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)cropImage:(UIImage *)originalImage rect:(CGRect)rect {
    if(originalImage == nil)
        return nil;
    if(CGRectIsEmpty(rect))
        return originalImage;
    
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGSize size = rect.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage *subImg = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return subImg;
    
}

- (UIImage *)iconImage:(UIImage *)oriImage {
    if(oriImage == nil)
        return nil;
    CGFloat cellHeight = 70;
    CGSize iconSize = CGSizeMake(cellHeight-10,cellHeight-10);
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, iconSize.width, iconSize.height);
    [oriImage drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
