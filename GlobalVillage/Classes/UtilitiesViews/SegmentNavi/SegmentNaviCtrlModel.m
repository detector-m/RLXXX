//
//  SegmentNaviCtrlModel.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/24.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentNaviCtrlModel.h"

@interface SegmentNaviCtrlModel ()
@property (nonatomic, readwrite, strong) NSMutableArray *barCtrlItems;
@property (nonatomic, readwrite, strong) NSMutableArray *contentCtrlItems;

@property (nonatomic, readwrite, assign, setter=setCurIndex:) UInt8 curIndex;
@end

@implementation SegmentNaviCtrlModel
@synthesize barCtrlItems = _barCtrlItems;
@synthesize contentCtrlItems = _contentCtrlItems;

@synthesize curIndex = _curIndex;

- (void)dealloc {
    [_barCtrlItems removeAllObjects], _barCtrlItems = nil;
    [_contentCtrlItems removeAllObjects], _contentCtrlItems = nil;
}

- (instancetype)init {
    if(self = [super init]) {
        self.barCtrlItems = [NSMutableArray array];
        self.contentCtrlItems = [NSMutableArray array];
        self.curIndex = 0;
    }
    
    return self;
}

- (void)setCurIndex:(UInt8)curIndex {
    if(curIndex < 0)
        return;
    _curIndex = curIndex;
}

- (id)getBarCtrlItemWithIndex:(NSInteger)index {
    if(index < 0)
        return nil;
    return [self.barCtrlItems objectAtIndex:index];
}

- (id)getContentCtrlItemWithIndex:(NSInteger)index {
    if(index < 0 || self.contentCtrlItems.count == 0 || self.contentCtrlItems.count <= index)
        return nil;
    return [self.contentCtrlItems objectAtIndex:index];
}
@end
