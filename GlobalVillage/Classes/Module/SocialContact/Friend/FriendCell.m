//
//  FriendCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "FriendCell.h"

#define kMargin 10.0f
#define kThumbWidth 36.0f
@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellFrame = self.contentView.frame;
    
    self.imageView.bounds  = CGRectMake (kMargin, 4, cellFrame.size.height- 8, cellFrame.size.height-8);
    self.imageView.frame  =  CGRectMake (kMargin, 4, cellFrame.size.height-8, cellFrame.size.height-8);
    
    CGRect tmpFrame = self.textLabel.frame ;
    self.textLabel.text = self.textLabel.text;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
    self.textLabel.frame = tmpFrame;
}

@end
