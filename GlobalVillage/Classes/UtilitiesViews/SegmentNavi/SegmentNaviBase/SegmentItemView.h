//
//  SegmentBarItem.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentBar;
@interface SegmentItemView : UIButton
@property (nonatomic, readwrite, weak) SegmentBar *delegate;
@end
