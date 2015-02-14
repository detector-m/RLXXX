//
//  ProfileCommonCell.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ProfileCommonCell.h"

@implementation ProfileCommonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}
@end
