//
//  NewsSegmentModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentModel.h"
#import "NewsMacros.h"
typedef NS_ENUM(UInt8, NewsSegmentSubscribeMode) {
    kNewsSegmentSubscribeModeNone,
    kNewsSegmentSubscribeModeSubscribe,
    kNewsSegmentSubscribeModeUnSubscribe,
};
@interface NewsSegmentModel : SegmentModel
@property (nonatomic, strong) id titleItem;
@property (nonatomic, assign) OperationMode operationMode;
@property (nonatomic, assign) SubscribeMode subscribeMode;
@property (nonatomic, assign) BOOL needRefresh;

@property (nonatomic, assign) NewsSegmentSubscribeMode newsSubscribeMode;
@end
