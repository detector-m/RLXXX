//
//  NewsChannelMode.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/27.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsSegmentModel;
@interface NewsChannelMode : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id channelView;
@property (nonatomic, weak) NewsSegmentModel *segment;
@end
