//
//  SegmentPageTableViewCell.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/24.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentPageTableViewCell.h"

@implementation SegmentPageTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}

#define  kMargin 5.0f

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines = 2;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.detailTextLabel.numberOfLines = 3;
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        self.imageView.contentMode  = UIViewContentModeScaleAspectFit;
        self.imageView.layer.cornerRadius = 5;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.backgroundView = nil;
        self.selectedBackgroundView = nil;
        self.multipleSelectionBackgroundView = nil;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellFrame = self.contentView.frame;
    
    self.imageView.bounds  = CGRectMake (kMargin,5, cellFrame.size.height-10,cellFrame.size.height-10);
    self.imageView.frame  =  CGRectMake (kMargin,5, cellFrame.size.height-10,cellFrame.size.height-10);

    CGRect tmpFrame = self.textLabel.frame ;
    self.textLabel.text = self.textLabel.text;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
//    tmpFrame.origin.y = kMargin*1.5;
    self.textLabel.frame = tmpFrame;
//    [self.textLabel sizeToFit];
    
    tmpFrame =  self.detailTextLabel.frame ;
    tmpFrame.origin.x  = self.imageView.frame.size.width+self.imageView.frame.origin.x+kMargin;
    tmpFrame.size.width = cellFrame.size.width - tmpFrame.origin.x;
//    tmpFrame.origin.y = cellFrame.size.height/2 + 2.5;
    self.detailTextLabel.frame  = tmpFrame;
//    [self.detailTextLabel sizeToFit];
}

/*
 再说明一下重绘，重绘操作仍然在drawRect方法中完成，但是苹果不建议直接调用drawRect方法，当然如果你强直直接调用此方法，当然是没有效果的。苹果要求我们调用UIView类中的setNeedsDisplay方法，则程序会自动调用drawRect方法进行重绘。（调用setNeedsDisplay会自动调用drawRect）
 
 
 在UIView中,重写drawRect: (CGRect) aRect方法,可以自己定义想要画的图案.且此方法一般情况下只会画一次.也就是说这个drawRect方法一般情况下只会被掉用一次.
 当某些情况下想要手动重画这个View,只需要掉用[self setNeedsDisplay]方法即可.
 drawRect掉用是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量值).
 
 
 1.如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。
 2.该方法在调用sizeThatFits后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3.通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4.直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0.
 以上1,2推荐；而3,4不提倡
 
 
 1、若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。drawRect：方法不能手动显示调用，必须通过调用setNeedsDisplay 或者 setNeedsDisplayInRect ，让系统自动调该方法。
 2、若使用calayer绘图，只能在drawInContext: 中（类似鱼drawRect）绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法。
 3、若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来掉用setNeedsDisplay实时刷新屏幕
 */
//- (void)drawRect:(CGRect)rect {
//    UIEdgeInsets insets = {5, 5, 5, 5};
//    [super drawRect:UIEdgeInsetsInsetRect(rect, insets)];
//}

@end
