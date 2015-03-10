//
//  NearbyPersonCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NearbyPersonCell.h"
#import "RLTextSize.h"

#define GenderViewWidth 20.0f

#define kMargin 5.0f
#define kThumbWidth 50.0f

@implementation NearbyPersonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.genderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GenderViewWidth, GenderViewWidth)];
        [self.contentView addSubview:self.genderView];
        
        self.distance = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(0, 0, 50, 18)];
        self.distance.textColor = [UIColor lightGrayColor];
        self.distance.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.distance];
        
        self.date = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(0, 0, 80, 18)];
        self.date.textColor = [UIColor lightGrayColor];
        self.date.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.date];
        
        self.add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        self.frame = CGRectMake(0, 0, 30, 30);
        [self.contentView addSubview:self.add];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect cellFrame = self.contentView.frame;
    
    self.imageView.bounds  = CGRectMake (kMargin, 5, cellFrame.size.height-10,cellFrame.size.height-10);
    self.imageView.frame  =  CGRectMake (kMargin, 5, cellFrame.size.height-10,cellFrame.size.height-10);
    
    CGRect tmpFrame = self.textLabel.frame;
    CGFloat width = [RLTextSize textWidthWithString:self.textLabel.text andFont:self.textLabel.font andHeight:tmpFrame.size.height]+5;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = width;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.genderView.frame;
    tmpFrame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width+10;
    tmpFrame.origin.y = self.textLabel.frame.origin.y-5;
    self.genderView.frame = tmpFrame;
    
    tmpFrame = self.date.frame;
    width = [RLTextSize textWidthWithString:self.date.text andFont:self.date.font andHeight:tmpFrame.size.height]+10;
    tmpFrame.origin.x = cellFrame.size.width - width - 20;
    tmpFrame.origin.y = self.textLabel.frame.origin.y;
    tmpFrame.size.width = width;
    self.date.frame = tmpFrame;
    
    tmpFrame = self.distance.frame;
    width = [RLTextSize textWidthWithString:self.distance.text andFont:self.distance.font andHeight:tmpFrame.size.height]+10;
    tmpFrame.origin.x = self.date.frame.origin.x - width - 10;
    tmpFrame.origin.y = self.date.frame.origin.y;
    tmpFrame.size.width = width;
    self.distance.frame = tmpFrame;
    
    tmpFrame =  self.detailTextLabel.frame ;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x - 30 - 20;
    self.detailTextLabel.frame  = tmpFrame;
    
    if(!self.add.hidden) {
        tmpFrame = self.add.frame;
        tmpFrame.origin.x = cellFrame.size.width - 30 - 20;
        tmpFrame.origin.y = self.detailTextLabel.frame.origin.y;
        self.add.frame = tmpFrame;
    }
}

@end
