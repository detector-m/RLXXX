//
//  ShareAppModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLShareAppModel : NSObject
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *appRedirectURI;

@property (nonatomic, copy) NSString *appAccessToken;
@property (nonatomic, copy) NSString *appUserId;

- (void)clearDatas;
@end
