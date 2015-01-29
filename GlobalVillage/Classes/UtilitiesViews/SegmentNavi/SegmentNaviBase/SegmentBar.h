//
//  SegmentBar.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentItemView.h"

#define kSegmentStartTag 100

@class SegmentBar;
@protocol SegmentBarDataSource <NSObject>
@optional
- (NSInteger)itemViewsNumberOfSegmentBar:(SegmentBar *)segmentBar;
- (SegmentItemView *)itemView:(SegmentBar *)sgementBar forIndex:(NSInteger)index;
- (CGFloat)itemWidthOfSegmentBar:(SegmentBar *)segmentBar forIndex:(NSInteger)index;
@end

@protocol SegmentBarDelegate <NSObject>
-(void)segmentBarSelectedIndexChanged:(NSInteger)newIndex;
-(void)contentSelectedIndexChanged:(NSInteger)newIndex;
-(void)scrollOffsetChanged:(CGPoint)offset;
@end


@interface SegmentBar : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, weak) id<SegmentBarDataSource> dataSource;
@property (nonatomic, assign) BOOL itemViewHasBorder;

@property (nonatomic, readonly, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, readwrite, weak) id<SegmentBarDelegate> segmentDelegate;


- (SegmentItemView *)dequeueReusableItemView;
- (void)reloadData;

- (void)setLineOffsetWithPage:(CGFloat)page andRatio:(CGFloat)ratio;
- (void)selectIndex:(NSInteger)index;
@end
