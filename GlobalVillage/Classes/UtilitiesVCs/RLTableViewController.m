//
//  RLTableViewController.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTableViewController.h"

@interface RLTableViewController ()

@end

@implementation RLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableCellIdentifier];
    }
    
    return cell;
}

- (UIImage *)iconImage:(UIImage *)oriImage {
    if(oriImage == nil)
        return nil;
    CGFloat cellHeight = 70;
    CGSize iconSize = CGSizeMake(cellHeight-10,cellHeight-10);
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, iconSize.width, iconSize.height);
    [oriImage drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)deselectRow:(UITableView *)tableView
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    tableView.userInteractionEnabled = NO;
    
    [self performSelector:@selector(deselectRow:) withObject:tableView afterDelay:0.5];
}

@end
