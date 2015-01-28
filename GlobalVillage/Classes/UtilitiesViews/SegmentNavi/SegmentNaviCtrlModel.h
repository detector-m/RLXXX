//
//  SegmentNaviCtrlModel.h
//  GlobalVillage
//
//  Created by RivenL on 14/12/24.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentNaviCtrlModel : NSObject
@property (nonatomic, readonly, strong) NSMutableArray *barCtrlItems;
@property (nonatomic, readonly, strong) NSMutableArray *contentCtrlItems;
@property (nonatomic, readonly, assign) UInt8 curIndex;

- (void)setCurIndex:(UInt8)curIndex;
- (id)getBarCtrlItemWithIndex:(NSInteger)index;
- (id)getContentCtrlItemWithIndex:(NSInteger)index;

@end
