//
//  SegmentBar.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSegmentStartTag 100
@protocol SegmentDelegate <NSObject>
-(void)segmentBarSelectedIndexChanged:(NSInteger)newIndex;
-(void)contentSelectedIndexChanged:(NSInteger)newIndex;
-(void)scrollOffsetChanged:(CGPoint)offset;
@end

@interface SegmentBar : UIScrollView
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, readwrite, strong) NSArray *titleArray;
@property (nonatomic, readonly, strong) NSMutableArray *buttonArray;
@property (nonatomic, readonly, strong) UIView *lineView;

@property (nonatomic, readwrite, weak) id<SegmentDelegate> segmentDelegate;

- (void)reloadSubViews;
- (void)setLineOffsetWithPage:(CGFloat)page andRatio:(CGFloat)ratio;
- (void)selectIndex:(NSInteger)index;
@end
