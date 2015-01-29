//
//  SegmentModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentModel : NSObject
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, readonly, strong) NSMutableArray *contents;
@end
