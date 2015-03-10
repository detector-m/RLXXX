//
//  NewsCell.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/5.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNewsCellHeight 100.0f
#define kMargin 5.0f
#define kThumbWidth 90.0f
@interface NewsCell : UITableViewCell
@property (nonatomic, readonly) UIImageView *thumbView;
@property (nonatomic, readonly) UILabel *title;
@property (nonatomic, readonly) UILabel *abstract;

@property (nonatomic, readwrite) BOOL needThumbview;
@end
