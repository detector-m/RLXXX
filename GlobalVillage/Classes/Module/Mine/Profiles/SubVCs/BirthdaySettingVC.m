//
//  BirthdaySettingVC.m
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BirthdaySettingVC.h"

@interface BirthdaySettingVC ()
@property (strong, nonatomic) UIDatePicker *birthdayPicker;
@end

@implementation BirthdaySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"生日", nil);
    [self birthdayPickerDoLoad];
//    self.birthday.date = [PrivateInfo shardedInstance].birthday;
}

- (void)birthdayPickerDoLoad {
    if (!self.birthdayPicker)
    {
        self.birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width -  2 * 15, 280)];
        self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:self.birthdayPicker];
        self.birthdayPicker.date = [NSDate date];
    }
}

- (void)clickCommitBtn:(UIBarButtonItem *)item {

}
@end
