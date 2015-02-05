//
//  NewsVC.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableViewController.h"
#import "NewsCell.h"

@class NewsSegmentModel;
@interface NewsVC : RLTableViewController

- (NSArray *)newsSegments;
- (NSArray *)subscribeNewsSegments;
- (NSArray *)unsubscribeNewsSegments;

- (void)commitChennelsForSubscribeAndUnSubscribe;

- (void)selected:(NewsSegmentModel *)segment;
@end
