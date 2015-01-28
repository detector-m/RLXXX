//
//  SegmentBar.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentBar.h"
#import "SegmentBarItem.h"
#import "RLColor.h"

@interface SegmentBar ()
@property (nonatomic, readwrite, strong) NSMutableArray *buttonArray;

@property (nonatomic, readwrite, strong) UIView *lineView;
@end

@implementation SegmentBar
@synthesize selectedIndex = _selectedIndex;
@synthesize titleArray = _titleArray;
@synthesize buttonArray = _buttonArray;
@synthesize lineView = _lineView;

@synthesize segmentDelegate = _segmentDelegate;

- (void)dealloc {
    self.titleArray = nil;
    [self.buttonArray removeAllObjects], self.buttonArray = nil;
    self.lineView = nil;
}

- (void)dataInitialize {
    self.selectedIndex = 0;
    self.buttonArray = [NSMutableArray array];
}

- (instancetype)init {
    if(self = [super init]) {
        [self dataInitialize];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 2)];
//        self.lineView.backgroundColor = [UIColor redColor];
        self.lineView.backgroundColor = [RLColor colorWithHexString:@"#87CEEB"];
        [self addSubview:self.lineView];
        
        self.panGestureRecognizer.delaysTouchesBegan = YES;
    }
    
    return self;
}

- (CGSize)textSizeWithFont:(UIFont *)font andText:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return size;
}

- (void)loadSubViewsData {
    /*
    CGFloat width = 0;
    for(NSInteger i = 0; i< self.titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *title = [self.titleArray objectAtIndex:i];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i+kSegmentStartTag;

        CGSize size = [self textSizeWithFont:button.titleLabel.font andText:title];
        button.frame = CGRectMake(width, 0, size.width+10, 25);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        width += button.frame.size.width;
    }
    if(width > self.frame.size.width)
        self.contentSize = CGSizeMake(width, 25);
    else {
        CGFloat buttonWidth = self.frame.size.width/self.buttonArray.count;
        for(NSInteger j=0; j<self.buttonArray.count; j++) {
            UIButton *button = [self.buttonArray objectAtIndex:j];
            button.frame = CGRectMake(j*buttonWidth, 0, buttonWidth, 25);
        }
//        self.contentSize = self.frame.s
    }
    self.showsHorizontalScrollIndicator = NO;
    
    [self setSelectIndexDisplay:0];
     */
    
//    [self itemDoLoad];
    [self normalButtonsDoLoad];
}
#define ButtonPadding 15.0f
- (void)normalButtonsDoLoad {
    CGFloat width = 0;
    for(NSInteger i = 0; i< self.titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:self.frame.size.height/2.5];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *title = [self.titleArray objectAtIndex:i];
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.cornerRadius = 7;
        button.tag = i+kSegmentStartTag;
        
        CGSize size = [self textSizeWithFont:button.titleLabel.font andText:title];
        button.frame = CGRectMake(width, 2, size.width+ButtonPadding, self.frame.size.height-4);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        width += button.frame.size.width;
    }
    if(width > self.frame.size.width)
        self.contentSize = CGSizeMake(width, self.frame.size.height);
    else {
        CGFloat buttonWidth = self.frame.size.width/self.buttonArray.count;
        for(NSInteger j=0; j<self.buttonArray.count; j++) {
            UIButton *button = [self.buttonArray objectAtIndex:j];
            button.frame = CGRectMake(j*buttonWidth, 0, buttonWidth, self.frame.size.height);
        }
        //        self.contentSize = self.frame.s
    }
    self.showsHorizontalScrollIndicator = NO;
    
    [self setSelectIndexDisplay:0];
}

- (void)itemDoLoad {
    CGFloat width = 0;
    for(NSInteger i = 0; i< self.titleArray.count; i++) {
        SegmentBarItem *button = [SegmentBarItem buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *title = [self.titleArray objectAtIndex:i];
        button.itemLabel.text = title;
        button.itemImageView.image = [UIImage imageNamed:@"qq_icon.png"];
        button.tag = i+kSegmentStartTag;
        
        CGSize size = [self textSizeWithFont:button.titleLabel.font andText:title];
        button.frame = CGRectMake(width, 2, size.width+10, self.frame.size.height-4);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        width += button.frame.size.width;
    }
    if(width > self.frame.size.width)
        self.contentSize = CGSizeMake(width, self.frame.size.height);
    else {
        CGFloat buttonWidth = self.frame.size.width/self.buttonArray.count;
        for(NSInteger j=0; j<self.buttonArray.count; j++) {
            UIButton *button = [self.buttonArray objectAtIndex:j];
            button.frame = CGRectMake(j*buttonWidth, 0, buttonWidth, self.frame.size.height);
        }
        //        self.contentSize = self.frame.s
    }
    self.showsHorizontalScrollIndicator = NO;
    
    [self setSelectIndexDisplay:0];
}

- (void)setSelectIndexDisplay:(__unused NSInteger)tag {
    UIButton *button = (UIButton *)[self viewWithTag:self.selectedIndex+kSegmentStartTag];
//    233,233,216
    button.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:233.0/255.0 blue:222.0/255.0 alpha:150.0/255.0];//[UIColor blueColor];
    
    CGSize size = [self textSizeWithFont:button.titleLabel.font andText:button.titleLabel.text];
    CGRect rc = button.frame;
    self.lineView.frame = CGRectMake(rc.origin.x+(rc.size.width-size.width)/2, self.frame.size.height - 2, size.width, 2);
}
- (void)cancelSelectIndexDisplay:(__unused NSInteger)tag {
    UIButton *button = (UIButton *)[self viewWithTag:self.selectedIndex+kSegmentStartTag];
    button.backgroundColor = [UIColor clearColor];
}

- (void)reloadSubViews {
    if(self.buttonArray == nil || self.buttonArray.count == 0) {
        self.buttonArray = [NSMutableArray array];
        [self loadSubViewsData];
        
        return;
    }
    
    CGFloat width = 0;
    for(NSInteger i=0; i<self.buttonArray.count; i++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        [button setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        width += button.frame.size.width;
    }

    if(width > self.frame.size.width)
        self.contentSize = CGSizeMake(width, 25);
    else {
        CGFloat buttonWidth = self.frame.size.width/self.buttonArray.count;
        for(NSInteger j=0; j<self.buttonArray.count; j++) {
            UIButton *button = [self.buttonArray objectAtIndex:j];
            button.frame = CGRectMake(j*buttonWidth, 0, buttonWidth, 25);
        }
    }
    
    [self selectIndex:0];
}

- (void)onClick:(UIButton *)button {
    if(self.selectedIndex != button.tag - kSegmentStartTag) {
        [self selectIndex:(button.tag - kSegmentStartTag)];
    }
}

- (void)selectIndex:(NSInteger)index {
    if(self.selectedIndex == index) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.2];
        [self setSelectIndexDisplay:0];
        [UIView commitAnimations];
        
        return;
    }
    
    [self cancelSelectIndexDisplay:0];
    self.selectedIndex = index;
    
    if(self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(segmentBarSelectedIndexChanged:)]) {
        
        [self.segmentDelegate segmentBarSelectedIndexChanged:self.selectedIndex];
    }
    
    CGRect lineRC = [self viewWithTag:self.selectedIndex+kSegmentStartTag].frame;

    if (lineRC.origin.x - self.contentOffset.x > self.frame.size.width * 2  / 3)
    {
        NSInteger index = self.selectedIndex;
        if (self.selectedIndex + 2 < self.buttonArray.count)
        {
            index = self.selectedIndex + 2;
        }
        else if (self.selectedIndex + 1 < self.buttonArray.count)
        {
            index = self.selectedIndex + 1;
        }
        CGRect rc = [self viewWithTag:index +kSegmentStartTag].frame;
        [self scrollRectToVisible:rc animated:YES];
    }
    else if ( lineRC.origin.x - self.contentOffset.x < self.frame.size.width / 3)
    {
        NSInteger index = self.selectedIndex;
        if (self.selectedIndex - 2 >= 0)
        {
            index = self.selectedIndex - 2;
        }
        else if (self.selectedIndex - 1 >= 0)
        {
            index = self.selectedIndex - 1;
        }
        CGRect rc = [self viewWithTag:index + kSegmentStartTag].frame;
        [self scrollRectToVisible:rc animated:YES];
    }
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.2];
    [self setSelectIndexDisplay:0];
    [UIView commitAnimations];
}

- (void)setLineOffsetWithPage:(CGFloat)page andRatio:(CGFloat)ratio {
    CGRect lineRC  = [self viewWithTag:page+kSegmentStartTag].frame;
    CGRect lineRC2  = [self viewWithTag:page+1+kSegmentStartTag].frame;
    
    CGFloat width = lineRC2.size.width;
    if (lineRC2.size.width < lineRC.size.width)
    {
        width =  lineRC.size.width - (lineRC.size.width-lineRC2.size.width)*ratio;
    }
    else if(lineRC2.size.width > lineRC.size.width)
    {
        width =  lineRC.size.width + (lineRC2.size.width-lineRC.size.width)*ratio;
    }
    CGFloat x = lineRC.origin.x + (lineRC2.origin.x - lineRC.origin.x)*ratio;
    
    self.lineView.frame = CGRectMake(x, self.frame.size.height - 2, width, 2);
}
@end
