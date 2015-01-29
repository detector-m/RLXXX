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

@interface Segment : NSObject
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) SegmentItem *item;
@property (nonatomic, strong) SegmentContent *content;
@end
