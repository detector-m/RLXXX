//
//  Segment.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentItem.h"
#import "SegmentContent.h"

typedef NS_ENUM(UInt8, SegmentMode) {
    kSegmentModeHide,
    kSegmentModeShow,
};

@interface Segment : NSObject
@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) SegmentMode segmentMode;

@property (nonatomic, strong) SegmentItem *item;
@property (nonatomic, strong) SegmentContent *content;
@end
