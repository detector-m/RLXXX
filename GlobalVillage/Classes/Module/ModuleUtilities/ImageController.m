//
//  ImageController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/31.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ImageController.h"

@implementation ImageController

+ (void)requestWithType:(RequestType)type andSubtag:(NSInteger)subtag parameters:(NSMutableDictionary *)parameters andDelegate:(id<RLRequestDelegate>)delegate {
    [GVRequestManager requestWithType:type subTag:subtag parameters:parameters keyClass:NSStringFromClass(self.class) andDelegate:delegate];
}

//- (void)uploadImageRequest:(NSData *)imageData accessToken:(__unused NSString *)accessToken {
//    NSMutableDictionary *parameters = [GVRequestParameterManager uploadImageParameter:imageData];
//    if(!parameters)
//    {
//        DLog(@"uploadImageDic error!");
//        NSAssert(parameters !=nil, @"uploadImageDic error!");
//    }
//
//    [[self class] requestWithType:kRequestTypeUploadImage andSubtag:0 parameters:parameters andDelegate:self];
//}

- (void)uploadImageRequest:(UIImage *)imageData accessToken:(__unused NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager uploadImageParameter:imageData];
    if(!parameters)
    {
        DLog(@"uploadImageDic error!");
        NSAssert(parameters !=nil, @"uploadImageDic error!");
    }
    
    [[self class] requestWithType:kRequestTypeUploadImage andSubtag:0 parameters:parameters andDelegate:self];
}

- (void)downloadImageRequest:(NSString *)imageFileUrl imageScale:(NSString *)imageScale accessToken:(NSString *)accessToken {
    NSMutableDictionary *parameters = [GVRequestParameterManager downloadImageParameter:imageFileUrl imageScaleVale:imageScale accessToken:accessToken];
    if(!parameters)
    {
        DLog(@"downloadImageRequest error!");
        NSAssert(parameters !=nil, @"downloadImageRequest error!");
    }
    
    [[self class] requestWithType:kRequestTypeDownloadImage andSubtag:0 parameters:parameters andDelegate:self];
}

#pragma mark - RLRequestDelegate
- (void)request:(RLRequest *)request
didFailWithError:(NSError *)error {
    DLog(@"%@", error);
    [GVPopViewManager removeActivity];
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
    
    dispatch_block_t block = NULL;
    block = ^() {
        [GVPopViewManager showDialogWithTitle:@"网络有问题"];
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)request:(RLRequest *)request
        didLoad:(id)result {
    [GVPopViewManager removeActivity];
    
    [self responseWithType:request.tag subtag:request.subTag result:result];
    
    [[RLRequestMgr shared] removeRequestForKey:NSStringFromClass(self.class) request:request];
}

- (void)responseWithType:(RequestType)type subtag:(NSInteger)subtag result:(id)result {
    if(self.delegate == nil)
        return;
    
    /*__unused */
    GVResponse *response = [[self class] responseWithReqeustResponseData:result];
    
    id<ImageControllerDelegate> delegate = (id<ImageControllerDelegate>)self.delegate;
    switch (type) {
        case kRequestTypeUploadImage:
            DLog(@"%@", result);
            response.responseData = result;
            response.responseData = [self parseNewsTypeListResponse:response];
            
            if([delegate respondsToSelector:@selector(uploadImageResponse:)]) {
                [delegate uploadImageResponse:response];
            }
            break;
        case kRequestTypeDownloadImage:
            response.responseData = result;
            if([delegate respondsToSelector:@selector(downloadImageResponse:)]) {
                [delegate downloadImageResponse:response];
            }
            break;
        default:
            break;
    }
}

- (NSString *)parseNewsTypeListResponse:(GVResponse *)response {
    if(response == nil || response.status != 0)
        return nil;

    DLog(@"%@", response.responseData);
    NSDictionary *imageInfo = [[response.responseData objectForKey:RespondFieldUploadImageImagesKey] firstObject];
    
    return [imageInfo objectForKey:RespondFieldNameKey];

}
@end
