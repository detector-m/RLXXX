//
//  RLTableModel.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableModel.h"
@interface RLTableModel ()
@property (nonatomic, readwrite, strong) NSMutableArray *datas Description(datas);
@end

@implementation RLTableModel
- (void)dealloc {
    [self.datas removeAllObjects], self.datas = nil;
}

- (instancetype)init {
    if(self = [super init]) {
        self.datas = [NSMutableArray array];
    }
        
    return self;
}
@end
