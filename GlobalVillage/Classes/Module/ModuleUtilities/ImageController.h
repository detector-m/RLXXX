//
//  ImageController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/31.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"

@protocol ImageControllerDelegate <ModuleControllerDelegate>
@optional
- (void)uploadImageResponse:(GVResponse *)response;
- (void)downloadImageResponse:(GVResponse *)response;
@end
@interface ImageController : ModuleController <ModuleControllerDelegate>
@property (nonatomic, weak) NSString *accessToken;

- (void)uploadImageRequest:(UIImage *)imageData accessToken:(NSString *)accessToken;
- (void)downloadImageRequest:(NSString *)imageFileUrl imageScale:(NSString *)imageScale accessToken:(NSString *)accessToken;
@end
