//
//  NewsSegmentModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentModel.h"

@interface NewsSegmentModel : SegmentModel
@property (nonatomic, strong) id titleItem;

@property (nonatomic, assign) BOOL needRefresh;
@end
