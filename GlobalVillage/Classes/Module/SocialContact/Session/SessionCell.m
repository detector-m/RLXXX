//
//  SessionCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/4.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SessionCell.h"

#define kMargin 5.0f
#define kThumbWidth 50.0f

@interface SessionCell ()
@property (nonatomic, readwrite, strong) UILabel *dateLabel;
@end

@implementation SessionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.dateLabel = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(self.contentView.frame.size.width-30, self.contentView.frame.size.height/2 - 20, 100, 20)];
        self.dateLabel.font = [UIFont systemFontOfSize:15];
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLabel];
        
        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellFrame = self.contentView.frame;
    
    self.imageView.bounds  = CGRectMake (kMargin, 5, cellFrame.size.height-10,cellFrame.size.height-10);
    self.imageView.frame  =  CGRectMake (kMargin, 5, cellFrame.size.height-10,cellFrame.size.height-10);
    
    CGRect tmpFrame = self.textLabel.frame ;
    self.textLabel.text = self.textLabel.text;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x - 100;

    self.textLabel.frame = tmpFrame;
    
    tmpFrame =  self.detailTextLabel.frame ;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
    self.detailTextLabel.frame  = tmpFrame;
    
    self.dateLabel.frame = CGRectMake(self.contentView.frame.size.width-30-100, self.contentView.frame.size.height/2 - 20, 100, 20);
}

@end
