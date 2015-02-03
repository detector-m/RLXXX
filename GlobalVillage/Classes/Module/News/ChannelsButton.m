//
//  ChannelsButton.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ChannelsButton.h"
@interface ChannelsButton ()
@property (nonatomic, readwrite, strong) UIImageView *deleteImageView;
@end

@implementation ChannelsButton
- (void)dealloc {
    self.deleteImageView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-7, -7, 15, 15)];
        self.deleteImageView.image = [UIImage imageNamed:@"ChannelDelete.png"];
        self.deleteImageView.hidden = YES;
        [self addSubview:self.deleteImageView];
    }
    
    return self;
}

@end
