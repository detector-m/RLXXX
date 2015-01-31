//
//  SegmentBar.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SegmentBar.h"
#import "SegmentItemView.h"
#import "RLColor.h"

#define kSelectedColor [UIColor colorWithRed:206/255.0 green:222/255.0 blue:235/255.0 alpha:1]
//[UIColor colorWithRed:232/255.0 green:228/255.0 blue:219/255.0 alpha:1]
#define kLineColor [UIColor clearColor]
#define kBackgroundColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
@interface SegmentBar ()
@property (nonatomic, strong) NSMutableSet *reusableItemViews;
@property (nonatomic, assign) NSInteger firstVisibleIndex;
@property (nonatomic, assign) NSInteger lastVisibleIndex;

@property (nonatomic, readwrite, strong) UIView *lineView;
@end

@implementation SegmentBar
- (void)dealloc {
    [self dataDoClean];
    self.lineView = nil;
}

- (CGSize)textSizeWithFont:(UIFont *)font andText:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return size;
}
- (void)dataDoLoad {
    self.reusableItemViews = [[NSMutableSet alloc] init];
    
    self.selectedIndex = 0;
    self.firstVisibleIndex = NSIntegerMax;
    self.lastVisibleIndex = NSIntegerMin;
}

- (void)dataDoClean {
    if(self.reusableItemViews) {
        [self.reusableItemViews removeAllObjects], self.reusableItemViews = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.itemViewHasBorder = NO;
        [self dataDoLoad];
        
        self.panGestureRecognizer.delaysTouchesBegan = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 2)];
        self.lineView.backgroundColor = kLineColor;//[RLColor colorWithHexString:@"#87CEEB"];
        [self addSubview:self.lineView];
        
        self.backgroundColor = kBackgroundColor;
    }
    
    return self;
}

- (void)setSelectIndexDisplay:(__unused NSInteger)tag {
    UIButton *button = (UIButton *)[self viewWithTag:self.selectedIndex+kSegmentStartTag];
    //    233,233,216
    button.backgroundColor = kSelectedColor;//[UIColor colorWithRed:188.0/255.0 green:233.0/255.0 blue:222.0/255.0 alpha:150.0/255.0];//[UIColor blueColor];
    
//    CGSize size = [self textSizeWithFont:button.titleLabel.font andText:button.titleLabel.text];
//    CGRect rc = button.frame;
//    self.lineView.frame = CGRectMake(rc.origin.x+(rc.size.width-size.width)/2, self.frame.size.height - 2, size.width, 2);
    CGRect rc = button.frame;
    self.lineView.frame = CGRectMake(rc.origin.x, self.frame.size.height - 2, rc.size.width, 2);
}
- (void)cancelSelectIndexDisplay:(__unused NSInteger)tag {
    UIButton *button = (UIButton *)[self viewWithTag:self.selectedIndex+kSegmentStartTag];
    button.backgroundColor = [UIColor clearColor];
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
    
    if (lineRC.origin.x - self.contentOffset.x >= self.frame.size.width  / 3)
    {
        NSInteger index = self.selectedIndex;
        NSInteger itemCount = [self.dataSource itemViewsNumberOfSegmentBar:self];
        if (self.selectedIndex + 2 < itemCount)
        {
            index = self.selectedIndex - 2;
        }
        else if (self.selectedIndex + 1 < itemCount)
        {
            index = self.selectedIndex - 1;
        }
//        CGRect rc = [self viewWithTag:index +kSegmentStartTag].frame;
//        [self scrollRectToVisible:rc animated:YES];
        
        CGPoint offset = CGPointMake([self widthOffsetAtIndex:index], 0);
        if(offset.x > self.contentSize.width-self.bounds.size.width) {
            offset.x = self.contentSize.width-self.bounds.size.width;
        }
        [self setContentOffset:offset animated:YES];

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
//        CGRect rc = [self viewWithTag:index + kSegmentStartTag].frame;
//        [self scrollRectToVisible:rc animated:YES];

        CGPoint offset = CGPointMake([self widthOffsetAtIndex:index], 0);
        [self setContentOffset:offset animated:YES];
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
    if (lineRC2.size.width < lineRC.size.width) {
        width =  lineRC.size.width - (lineRC.size.width-lineRC2.size.width)*ratio;
    }
    else if(lineRC2.size.width > lineRC.size.width) {
        width =  lineRC.size.width + (lineRC2.size.width-lineRC.size.width)*ratio;
    }
    CGFloat x = lineRC.origin.x + (lineRC2.origin.x - lineRC.origin.x)*ratio;
    
    self.lineView.frame = CGRectMake(x, self.frame.size.height - 2, width, 2);
}


- (SegmentItemView *)dequeueReusableItemView {
    SegmentItemView *v = [self.reusableItemViews anyObject];
    
    if(v != nil) {
        [self.reusableItemViews removeObject:v];
//        if(self.selectedIndex != index) {
            v.backgroundColor = [UIColor clearColor];
//        }
//        else {
//            v.backgroundColor = kBackgroundColor;
//        }
    }
    
    return v;
}

- (void)queueReusableItemViews {
    for(UIView *v in [self subviews]) {
        if([v isKindOfClass:[SegmentItemView class]]) {
            [self.reusableItemViews addObject:v];
            [v removeFromSuperview];
        }
    }
    
    self.firstVisibleIndex = NSIntegerMax;
    self.lastVisibleIndex = NSIntegerMin;
}
- (void)reloadData {
    [self queueReusableItemViews];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(self.dataSource == nil ||
       !([self.dataSource respondsToSelector:@selector(itemViewsNumberOfSegmentBar:)]))
        return;
    
    NSInteger itemCount = [self.dataSource itemViewsNumberOfSegmentBar:self];
    if(itemCount == 0)
        return;

    CGRect visibleBounds = self.bounds;
    CGSize contentSize = self.contentSize;

    if((visibleBounds.origin.x < 0 || visibleBounds.origin.y < 0) || (contentSize.width > 0 && visibleBounds.origin.x >= contentSize.width))
        return;
    
    CGFloat visibleWidth = visibleBounds.size.width;
    CGFloat visibleWidthEnd = visibleBounds.origin.x + visibleWidth;
 
    NSInteger startIndex = 0;
    NSInteger stopIndex = 0;
    CGFloat xOffset = 0;
    CGFloat yOffset = 1;
    CGFloat width = 0;
    CGFloat itemWidth;
    
    CGFloat orignalX;
    for(NSInteger i=0; i<itemCount; i++) {
        itemWidth = [self.dataSource itemWidthOfSegmentBar:self forIndex:i];
         orignalX = width;
        width += itemWidth;
        
        if(width > visibleBounds.origin.x && orignalX <= visibleBounds.origin.x) {
            startIndex = i;
            xOffset = orignalX;
        }
        
        if(width > visibleWidthEnd && orignalX  <= visibleWidthEnd) {
            stopIndex = i;
        }
        else {
            if(i==itemCount-1 && stopIndex == 0) {
                stopIndex = i;
            }
        }
    }
    
    if(self.firstVisibleIndex == startIndex && self.lastVisibleIndex == stopIndex) {
        return;
    }
    
    contentSize = CGSizeMake(width, visibleBounds.size.height);
    if(!CGSizeEqualToSize(self.contentSize, contentSize)) {
        self.contentSize = contentSize;
    }
    
    CGRect viewFrame;
    CGFloat widthForDelete;
    for(UIView *v in [self subviews]) {
        if([v isKindOfClass:[SegmentItemView class]]) {
            viewFrame = v.frame;
            widthForDelete = (viewFrame.origin.x + viewFrame.size.width);

            if(widthForDelete < visibleBounds.origin.x ||
               viewFrame.origin.x >= visibleWidthEnd) {
                [self.reusableItemViews addObject:v];
                [v removeFromSuperview];
            }
        }
    }
    
    for(NSInteger index = startIndex; index<=stopIndex; index++) {
        BOOL isMissing = !(index >= self.firstVisibleIndex && index <= self.lastVisibleIndex);
        itemWidth = [self.dataSource itemWidthOfSegmentBar:self forIndex:index];

        if(!isMissing) {
            xOffset += itemWidth;
            continue;
        }
        SegmentItemView *itemView = [self.dataSource itemView:self forIndex:index];
        viewFrame = CGRectMake(xOffset, yOffset, itemWidth, self.frame.size.height-2);
        itemView.tag = index + kSegmentStartTag;
        itemView.frame = viewFrame;
        
        [self addSubview:itemView];
        xOffset += itemWidth;
    }
    
//    if(self.selectedIndex == 0)
    {
        [self setSelectIndexDisplay:self.selectedIndex];
    }
    
    self.firstVisibleIndex = startIndex;
    self.lastVisibleIndex = stopIndex;
}

- (CGFloat)widthOffsetAtIndex:(NSInteger)index {
    if(self.dataSource == nil ||
       !([self.dataSource respondsToSelector:@selector(itemViewsNumberOfSegmentBar:)]) ||
       [self.dataSource itemViewsNumberOfSegmentBar:self] == 0 ||
       index == 0)
        return 0.0f;
    CGFloat widthOffset = 0.0f;
    for(NSInteger i=0; i<index; i++) {
        widthOffset += [self.dataSource itemWidthOfSegmentBar:self forIndex:i];
    }
    
    return widthOffset;
}

#if 0
- (void)loadSubViewsData {
    [self normalButtonsDoLoad];
}
#define ButtonPadding 15.0f
- (void)normalButtonsDoLoad {
    CGFloat width = 0;
    for(NSInteger i = 0; i< self.titleArray.count; i++) {
        
        NSString *title = [self.titleArray objectAtIndex:i];
        UIButton *button = [self itemWithTitle:title tag:i+kSegmentStartTag];
        
        CGSize size = [self textSizeWithFont:button.titleLabel.font andText:title];
        button.frame = CGRectMake(width, 2, size.width+ButtonPadding, self.frame.size.height-4);
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    self.showsHorizontalScrollIndicator = NO;
    
    [self reloadSubViews];
    [self setSelectIndexDisplay:0];
}

- (UIButton *)itemWithTitle:(NSString *)aTitle tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:self.frame.size.height/2.5];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    button.layer.cornerRadius = 7;
    button.tag = tag;
    
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)addItemWithTitle:(NSString *)title {
    UIButton *button = [self itemWithTitle:title tag:self.buttonArray.count+kSegmentStartTag];
    CGSize size = [self textSizeWithFont:button.titleLabel.font andText:title];
    button.frame = CGRectMake(0, 2, size.width+ButtonPadding, self.frame.size.height-4);
    [self addSubview:button];
    [self.buttonArray addObject:button];
    
    [self reloadSubViews];
}

- (void)removeItemWithTitle:(NSString *)title {
    for(UIButton *btn in self.buttonArray) {
        if([btn.titleLabel.text isEqualToString:title]) {
            [btn removeFromSuperview];
            [self.buttonArray removeObject:btn];
            break;
        }
    }
    
    [self reloadSubViews];
}


- (void)reloadSubViews {
    if(self.buttonArray == nil || self.buttonArray.count == 0) {
        self.buttonArray = [NSMutableArray array];
        [self loadSubViewsData];
        
        return;
    }
    
    CGFloat width = 0;
    CGRect frame = CGRectZero;
    for(NSInteger i=0; i<self.buttonArray.count; i++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        [button setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        frame = button.frame;
        frame.origin.x = width;
        button.frame = frame;
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
#endif
@end
