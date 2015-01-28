//
//  ShareMessageModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageType) {
    kMessageTypeDefault = 1,
    kMessageTypeText = kMessageTypeDefault,
    kMessageTypeImage,
    kMessageTypeMedia,
    kMessageTypeLink,
};

@interface RLShareMessageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *scheme;

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) NSData *thumbData;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) MessageType messageType;

@property (nonatomic, assign) NSInteger appType;

- (void)fillDefaultData;
@end
