//
//  SegmentNaviVC.m
//  GlobalVillage
//
//  Created by RivenL on 14/12/22.
//  Copyright (c) 2014年 RivenL. All rights reserved.
//

#import "SegmentNaviVC.h"
#import "SegmentBar.h"
#import "SegmentContentView.h"
#import "UIViewController+Expand.h"

#define kBarHeight 50
@interface SegmentNaviVC () <SegmentDelegate>
@property (nonatomic, readwrite, assign) NSInteger currentIndex;
//@property (nonatomic, readwrite, strong) NSArray *titleArray;

@property (nonatomic, strong) SegmentContentView *contentTable;
@property (nonatomic, strong) SegmentBar *segmentBar;
@end

@implementation SegmentNaviVC
@synthesize titleArray = _titleArray;
@synthesize currentIndex = _currentIndex;

@synthesize contentTable = _contentTable;
@synthesize segmentBar = _segmentBar;
@synthesize contentArray = _contentArray;

@synthesize barViewWidth = _barViewWidth;
//@synthesize barViewFrame = _barViewFrame;

@synthesize segmentNaviDelegate = _segmentNaviDelegate;

- (void)dealloc {
    self.titleArray = nil;
    self.contentArray = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)resizeFrame {
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect frame = self.view.frame;
    
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navigationFrame = self.navigationController.navigationBarHidden ? CGRectZero : self.navigationController.navigationBar.bounds;
    CGRect tabBarFrame = self.tabBarController.tabBar.hidden ? CGRectZero : self.tabBarController.tabBar.frame;
    
//    CGRect frame = self.view.frame;
    CGFloat height = frame.size.height - (navigationFrame.size.height +
                                          statusFrame.size.height +
                                          tabBarFrame.size.height);
    CGFloat originY = self.navigationController.navigationBarHidden ? statusFrame.size.height : 0;
    if(self.navigationController == nil)
        originY = statusFrame.size.height;
//    else if(!self.navigationController.navigationBarHidden) {
//        height += navigationFrame.size.height + statusFrame.size.height;
//    }
    frame = CGRectMake(frame.origin.x, frame.origin.y + originY, frame.size.width, height);
    self.view.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resizeFrame];
    
    if(self.barViewWidth == 0) {
        self.barViewWidth = self.view.frame.size.width;
    }
    [self performSelectorOnMainThread:@selector(subviewsDoLoad) withObject:nil waitUntilDone: YES];
}

- (void)subviewsDoLoad {
    if(self.segmentBar == nil) {
        self.segmentBar = [[SegmentBar alloc] init];
        self.segmentBar.frame = CGRectMake(0, 0, self.barViewWidth, kBarHeight);
        self.segmentBar.titleArray = self.titleArray;
        [self.view addSubview:self.segmentBar];
        self.segmentBar.segmentDelegate = self;
        [self.segmentBar reloadSubViews];
    }
    
    if(self.contentTable == nil) {
        self.contentTable = [[SegmentContentView alloc] initWithFrame:CGRectMake(0,  kBarHeight, self.view.frame.size.width, self.view.frame.size.height - kBarHeight)];
        self.contentTable.cellDataSource = self.contentArray;
        self.contentTable.swipeDelegate = self;
        [self.view addSubview:self.contentTable];
        self.currentIndex = 0;
    }
}

- (void)setBarViewWidth:(CGFloat)barViewWidth {
    if(barViewWidth == 0.0f || self.segmentBar.frame.size.width == barViewWidth)
        return;
    _barViewWidth = barViewWidth;
    if(self.segmentBar == nil)
        return;
    self.segmentBar.frame = CGRectMake(0, 0, _barViewWidth, kBarHeight);
    [self.segmentBar reloadSubViews];
    
}

-(void)segmentBarSelectedIndexChanged:(NSInteger)newIndex
{
    if (newIndex >= 0)
    {
        if(self.segmentNaviDelegate && [self.segmentNaviDelegate respondsToSelector:@selector(segmentNaviWillChange:)]) {
            [self.segmentNaviDelegate segmentNaviWillChange:self.currentIndex];
        }
        self.currentIndex = newIndex;
        self.title = [self.titleArray objectAtIndex:newIndex];
        [self.contentTable selectIndex:newIndex];
        
        if(self.segmentNaviDelegate && [self.segmentNaviDelegate respondsToSelector:@selector(segmentNaviChange:)]) {
            [self.segmentNaviDelegate segmentNaviChange:newIndex];
        }
    }
}

-(void)contentSelectedIndexChanged:(NSInteger)newIndex
{
    [self.segmentBar selectIndex:newIndex];
}

-(void)scrollOffsetChanged:(CGPoint)offset
{
    NSInteger page = (NSInteger)offset.y / self.view.frame.size.width ;
    CGFloat radio = (CGFloat)((NSInteger)offset.y%(NSInteger)self.view.frame.size.width)/self.view.frame.size.width;
    [self.segmentBar setLineOffsetWithPage:page andRatio:radio];
}
@end
