//
//  SegmentNaviVC.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentBar.h"
#import "SegmentsTableView.h"
#import "Segment.h"

#define kBarHeight 44
@protocol SegmentNaviDelegate <NSObject>
@optional
- (void)segmentNaviWillChange:(NSInteger)index;
- (void)segmentNaviChange:(NSInteger)newIndex;
@end

@interface SegmentNaviVC : UIViewController <SegmentBarDataSource, SegmentBarDelegate, UITableViewDataSource, UITableViewDelegate>
//-------------------
@property (nonatomic, readonly, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *segments;
@property (nonatomic, readwrite, assign) CGFloat barViewWidth;

@property (nonatomic, readwrite, weak) id<SegmentNaviDelegate> segmentNaviDelegate;

@property (nonatomic, readonly, strong) SegmentBar *segmentBar;
@property (nonatomic, readonly, strong) SegmentsTableView *segmentsTableView;

@property (nonatomic, assign) BOOL needReset;

- (void)cleanData;
- (void)reloadData;

- (void)resetIndex;
@end
