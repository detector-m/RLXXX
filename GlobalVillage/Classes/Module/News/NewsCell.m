//
//  NewsCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/5.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()
@property (nonatomic, readwrite) UIImageView *thumbView;
@property (nonatomic, readwrite) UILabel *title;
@property (nonatomic, readwrite) UILabel *abstract;
@end

@implementation NewsCell
- (void)dealloc {
    self.thumbView.image = nil;
    self.thumbView = nil;
    self.title = nil;
    self.abstract = nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        [self.textLabel removeFromSuperview];
        [self.detailTextLabel removeFromSuperview];
        [self.imageView removeFromSuperview];

        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, kThumbWidth, kThumbWidth)];
        self.thumbView.contentMode  = UIViewContentModeScaleAspectFit;
        self.thumbView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.thumbView];

        CGRect frame = self.thumbView.frame;
        CGFloat titleOffset = frame.size.width+frame.origin.x+kMargin;
        CGFloat titleWidth = self.frame.size.width-(frame.size.width+frame.origin.x+kMargin+30);
        
        self.title = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(titleOffset, kMargin, titleWidth, 44)];
        self.title.numberOfLines = 2;
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.title];
        
        self.abstract = [ViewConstructor constructDefaultLabel:[UILabel class] withFrame:CGRectMake(titleOffset, kMargin+self.title.frame.size.height, titleWidth, 46)];
        self.abstract.numberOfLines = 3;
        self.abstract.textColor = [UIColor lightGrayColor];
        self.abstract.textAlignment = NSTextAlignmentLeft;
        self.abstract.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.abstract];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = nil;
        self.selectedBackgroundView = nil;
        self.multipleSelectionBackgroundView = nil;

    }
    
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGRect cellFrame = self.contentView.frame;
//    
//    self.imageView.bounds  = CGRectMake (kMargin,5, cellFrame.size.height-10,cellFrame.size.height-10);
//    self.imageView.frame  =  CGRectMake (kMargin,5, cellFrame.size.height-10,cellFrame.size.height-10);
//    
//    CGRect tmpFrame = self.textLabel.frame ;
//    self.textLabel.text = self.textLabel.text;
//    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
//    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
//    //    tmpFrame.origin.y = kMargin*1.5;
//    self.textLabel.frame = tmpFrame;
//    //    [self.textLabel sizeToFit];
//    
//    tmpFrame =  self.detailTextLabel.frame ;
//    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
//    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
//    //    tmpFrame.origin.y = cellFrame.size.height/2 + 2.5;
//    self.detailTextLabel.frame  = tmpFrame;
//    //    [self.detailTextLabel sizeToFit];
//}
@end
