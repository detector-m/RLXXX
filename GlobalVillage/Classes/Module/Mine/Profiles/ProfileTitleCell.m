//
//  ProfileTitleCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileTitleCell.h"
#import "RLTextSize.h"

@interface ProfileTitleCell ()
@property (nonatomic, readwrite, strong) UILabel *subTextLabel;
@property (nonatomic, readwrite, strong) UIButton *imageButton;
@end
@implementation ProfileTitleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.subTextLabel = [[UILabel alloc] init];
        self.subTextLabel.font = [UIFont systemFontOfSize:12];
        self.subTextLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.subTextLabel];
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.imageButton];
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    CGFloat widthOffset = 10;
    
    self.imageView.frame = CGRectMake(widthOffset, 5, frame.size.height-10, frame.size.height-10);
    self.imageButton.frame = self.imageView.frame;

    widthOffset += self.imageView.frame.size.width + 15;
    
    frame = self.textLabel.frame;
    frame.origin.x = widthOffset;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = widthOffset;
    self.detailTextLabel.frame = frame;
    
//    widthOffset = [RLTextSize textWidthWithString:self.textLabel.text andFont:self.textLabel.font andHeight:[self.textLabel.font lineHeight]+4];
    widthOffset += 1 + self.textLabel.frame.origin.x+self.textLabel.frame.size.width;
    
    CGFloat heightOffset = self.textLabel.frame.origin.y+self.textLabel.frame.size.height - self.subTextLabel.font.lineHeight-1;
    if(heightOffset <= 0)
        heightOffset = 20;
    self.subTextLabel.frame = CGRectMake(widthOffset, heightOffset, 50, self.subTextLabel.font.lineHeight+2);
}
@end
