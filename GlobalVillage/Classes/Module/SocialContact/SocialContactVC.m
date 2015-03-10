//
//  SocialContactVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "SocialContactVC.h"
#import "SegmentNaviVC.h"
#import "SocialContactSegmentModel.h"
#import "SessionCell.h"
#import "FriendCell.h"
#import "UIImageView+WebCache.h"

#import "SearchStrangerVC.h"
#import "NearbyPersonVC.h"

#import "pinyin.h"
#import "ChineseString.h"

@interface SocialContactVC () <SegmentNaviDelegate>
@property (nonatomic, readwrite, strong) SegmentNaviVC *segmentVC;
@property (nonatomic, readwrite, strong) NSMutableArray *segments Description(SocialContactSegmentModel);

/*friends*/
@property (nonatomic, strong) NSMutableArray *lettersIndexSet;
@property (nonatomic, strong) NSMutableArray *letterTableContent;
//test
@property (nonatomic, strong) NSMutableArray *stringsToSort;
@end

@implementation SocialContactVC
- (void)dealloc {
    [self dataDoClear];
}

- (BOOL)navigationShouldPopOnBackButton {
//    [self.controller removeAllRequest];
    
    return [super navigationShouldPopOnBackButton];
}

- (void)navigationDidPopOnBackButton {
    [super navigationDidPopOnBackButton];
}

- (void)dataDoClear {
//    self.controller.delegate = nil;
//    self.controller = nil;
//    [self.segments removeAllObjects], self.segments = nil;
//    self.channelsButton = nil;
//    self.navigationTitleButton = nil;
    [self.segments removeAllObjects], self.segments = nil;
    [self.lettersIndexSet removeAllObjects], self.lettersIndexSet = nil;
    [self.letterTableContent removeAllObjects], self.letterTableContent = 0;
}

- (void)dataDoLoad {
//    self.controller = [[NewsController alloc] init];
//    self.controller.delegate = self;
//    
//    self.segments = [NSMutableArray array];
    self.segments = [NSMutableArray array];
    
    self.lettersIndexSet = [NSMutableArray array];
    self.letterTableContent = [NSMutableArray array];
    for(NSInteger i=0; i<27; i++) {
        [self.letterTableContent addObject:[NSMutableArray array]];
    }
    
    /*test*/
    self.stringsToSort = [NSMutableArray arrayWithObjects:
                                   @"电脑",
                                   @"显示器",
                                   @"你好",
                                   @"推特",
                                   @"乔布斯",
                                   @"再见",
                                   @"暑假作业",
                                   @"键盘",
                                   @"鼠标",
                                   @"谷歌",
                                   @"苹果",
                                    @"111",
                          @"abc",
                          @"cc",
                                   nil];
}

- (void)cleanDatas {
//    [self.segmentVC cleanData];
//    [self.segments removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"社交", nil);
    
    [self dataDoLoad];
    [self pinyinFirstLetters];
    
    [self segmentNaviVCDoLoad];
}

- (void)pinyinFirstLetters {
    for(NSInteger i=0; i<[self.stringsToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc] init];
        
        chineseString.string=[NSString stringWithString:[self.stringsToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        unichar c;
        if(![chineseString.string isEqualToString:@""]){
//            NSString *pinYinResult=[NSString string];
            NSString *pinYinResult = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:0])]uppercaseString];

//            for(int j=0;j<chineseString.string.length;j++){
//                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
//                
//                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
//            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        c = [chineseString.pinYin characterAtIndex:0];
        if(c >= 'A' && c <= 'Z') {
            if(![self isContainString:chineseString.pinYin array:self.lettersIndexSet]) {
                [self.lettersIndexSet addObject:chineseString.pinYin];
            }
            NSMutableArray *array = [self.letterTableContent objectAtIndex:c-'A'];
            [array addObject:chineseString.string];
        }
        else {
            if(![self isContainString:@"#" array:self.lettersIndexSet]) {
                [self.lettersIndexSet addObject:@"#"];
            }
            NSMutableArray *array = [self.letterTableContent lastObject];
            [array addObject:chineseString.string];
        }
    }
    
    self.lettersIndexSet = [NSMutableArray arrayWithArray: [self.lettersIndexSet sortedArrayUsingSelector:@selector(localizedCompare:)]];
//    NSString *tmp = [self.lettersIndexSet firstObject];
//    [self.lettersIndexSet removeObjectAtIndex:0];
//    [self.lettersIndexSet addObject:tmp];
    [self.lettersIndexSet insertObject:UITableViewIndexSearch atIndex:0];
    DLog(@"%@", self.lettersIndexSet);
}

- (BOOL)isContainString:(NSString *)str array:(NSArray *)array {
    for(NSString *s in array) {
        if([s isEqualToString:str])
            return YES;
    }
    
    return NO;
}

- (void)segmentNaviVCDoLoad {
    if(self.segmentVC != nil) {
        [self segmentNaviDataDoLoad];
        [self.segmentVC reloadData];
        return;
    }
    
    self.segmentVC = [[SegmentNaviVC alloc] init];
    self.segmentVC.segmentNaviDelegate = self;
    [self.segmentVC setBarViewWidth:self.view.frame.size.width];
    
    [self segmentNaviDataDoLoad];
    
    [self addChildViewController:self.segmentVC];
    [self.view addSubview:self.segmentVC.view];
}

- (void)segmentNaviDataDoLoad {
    [self.segments addObject:[self sessionSegment]];
    [self.segments addObject:[self friendSegment]];
    [self.segments addObject:[self circleSegment]];
    [self.segments addObject:[self aadFriendSegment]];

    self.segmentVC.segments = self.segments;
}

- (UITableView *)constructTableView {
    UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    view.delegate = self;
    view.dataSource = self;
    view.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
    
    view.showsVerticalScrollIndicator = NO;
    view.rowHeight = 44.0f;
    view.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([view respondsToSelector:@selector(setSeparatorInset:)]) {
        view.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }

    return view;
}

- (SocialContactSegmentModel *)constructSegment {
    SocialContactSegmentModel *tmpSegment = [[SocialContactSegmentModel alloc] init];
    tmpSegment.title = NSLocalizedString(@"", nil);
    tmpSegment.item.title = tmpSegment.title;
    tmpSegment.segmentMode = kSegmentModeShow;
    tmpSegment.view = [self constructTableView];
    tmpSegment.content.view = tmpSegment.view;
    
    return tmpSegment;
}

- (SocialContactSegmentModel *)sessionSegment {
    SocialContactSegmentModel *tmpSegment = [self constructSegment];
    tmpSegment.title = NSLocalizedString(@"会话", nil);
    tmpSegment.item.title = tmpSegment.title;
    tmpSegment.view.tag = kSocialContactSession;
    ((UITableView *)tmpSegment.view).rowHeight = 60.0f;

    return tmpSegment;
}

- (SocialContactSegmentModel *)friendSegment {
    SocialContactSegmentModel *tmpSegment = [self constructSegment];
    tmpSegment.title = NSLocalizedString(@"通讯录", nil);
    tmpSegment.item.title = tmpSegment.title;
    tmpSegment.view.tag = kSocialContactFriend;
    
    return tmpSegment;
}

- (SocialContactSegmentModel *)circleSegment {
    SocialContactSegmentModel *tmpSegment = [self constructSegment];
    tmpSegment.title = NSLocalizedString(@"圈子", nil);
    tmpSegment.item.title = tmpSegment.title;
    tmpSegment.view.tag = kSocialContactCircle;
    
    return tmpSegment;
}

- (SocialContactSegmentModel *)aadFriendSegment {
    SocialContactSegmentModel *tmpSegment = [self constructSegment];
    tmpSegment.title = NSLocalizedString(@"添加", nil);
    tmpSegment.item.title = tmpSegment.title;
    tmpSegment.view.tag = kSocialContactAddFriend;
    
    return tmpSegment;
}

#pragma mark - UITableViewDatasource UITableViewDelegate

/********************/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(tableView.tag == kSocialContactFriend) {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
        
        return self.lettersIndexSet;//[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if(tableView.tag == kSocialContactFriend) {
        return index;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == kSocialContactFriend) {
        return self.lettersIndexSet.count;
    }
    else if(tableView.tag == kSocialContactCircle) {
        return 2;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView.tag == kSocialContactFriend) {
        if(section == 0) {
            return nil;
        }
        return [self.lettersIndexSet objectAtIndex:section];
    }
    else if(tableView.tag == kSocialContactCircle) {
        if(section == 0) {
            return nil;
        }
        else
            return NSLocalizedString(@"圈子", nil);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView.tag == kSocialContactFriend) {
        if(section == 0) {
            return 0.0f;
        }
        else
            return 22.0f;
    }
    else if(tableView.tag == kSocialContactCircle) {
        if(section == 0) {
            return 0.0f;
        }
        else {
            return 28.0f;
        }
    }
    
    return 0.0f;
}

/**********************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == kSocialContactFriend) {
        if(section == 0) {
            return 1;
        }
        else if(section == 1) {
            return [[self.letterTableContent lastObject] count];
        }
        return ((NSArray *)[self.letterTableContent objectAtIndex:[[self.lettersIndexSet objectAtIndex:section] characterAtIndex:0] - 'A']).count;
    }
    else if(tableView.tag == kSocialContactCircle) {
        if(section == 0) {
            return 1;
        }
        else
            return 2;
    }
    else if(tableView.tag == kSocialContactAddFriend) {
        return 2;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if(tableView.tag == kSocialContactFriend) {
        [tableView registerClass:[FriendCell class] forCellReuseIdentifier:kTableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
        
        NSArray *array = nil;
        if(indexPath.section == 0/*self.lettersIndexSet.count - 1*/) {
            cell.textLabel.text = @"1";
        }
        else if(indexPath.section == 1) {
            array =  [self.letterTableContent lastObject];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
        }
        else {
            array = [self.letterTableContent objectAtIndex:[[self.lettersIndexSet objectAtIndex:indexPath.section] characterAtIndex:0] - 'A'];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
        }
    }
    else if(tableView.tag == kSocialContactCircle) {
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
        if(indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"朋友圈", nil);
        }
        else {
          cell.textLabel.text = @"test";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if(tableView.tag == kSocialContactAddFriend) {
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
        
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"添加好友", nil);
        }
        else {
            cell.textLabel.text = NSLocalizedString(@"附近的人", nil);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
        [tableView registerClass:[SessionCell class] forCellReuseIdentifier:kTableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = @"test";
        cell.detailTextLabel.text = @"test";
        ((SessionCell *)cell).dateLabel.text = @"test";
    }
    
    if([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsMake(2, 3, 2, 3);
    }
    
    NSURL *imageUrl = [NSURL URLWithString:@""];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NewsDefaultIcon.png"] options:SDWebImageProgressiveDownload];
    
    return cell;
}

- (void)deselectRow:(UITableView *)tableView
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    
    if(tableView.tag == kSocialContactAddFriend) {
        if(indexPath.row == 0) {
            SearchStrangerVC *vc = [SearchStrangerVC new];
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
        else {
            NearbyPersonVC *vc = [NearbyPersonVC new];
            [ChangeVCController pushViewControllerByNavigationController:self.navigationController pushVC:vc];
        }
    }
    
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

@end
