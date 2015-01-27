//
//  ChannelsView.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChannelsView.h"

@interface ChannelsView ()
@property (nonatomic, readwrite, strong) NSMutableArray *channels;
@end
@implementation ChannelsView

- (void)dealloc {
    [self.channels removeAllObjects], self.channels = nil;
}

- (void)dataDoLoad {
    if(self.channels) {
        return;
    }
    
    self.channels = [NSMutableArray array];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self dataDoLoad];
    }
    
    return self;
}

@end
