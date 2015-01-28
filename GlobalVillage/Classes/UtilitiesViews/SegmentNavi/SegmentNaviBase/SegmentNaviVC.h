//
//  SegmentNaviVC.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentBar.h"

@protocol SegmentNaviDelegate <NSObject>
@optional
- (void)segmentNaviWillChange:(NSInteger)index;
- (void)segmentNaviChange:(NSInteger)newIndex;
@end

@interface SegmentNaviVC : UIViewController
@property (nonatomic, readonly, assign) NSInteger currentIndex;
@property (nonatomic, readwrite, strong) NSArray *titleArray;
@property (nonatomic, readwrite, strong) NSArray *contentArray;

@property (nonatomic, readwrite, assign) CGFloat barViewWidth;
//@property (nonatomic, readwrite, assign) CGRect barViewFrame;

@property (nonatomic, readwrite, weak) id<SegmentNaviDelegate> segmentNaviDelegate;
@end
