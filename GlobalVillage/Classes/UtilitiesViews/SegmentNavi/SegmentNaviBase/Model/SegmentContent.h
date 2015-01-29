//
//  SegmentContent.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentItem.h"

@interface SegmentContent : NSObject
@property (nonatomic, weak) SegmentItem *item; //belong which item
@property (nonatomic, weak) UIView *view;
@end
