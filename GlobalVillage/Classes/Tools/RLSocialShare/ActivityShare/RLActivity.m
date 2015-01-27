//
//  RLActivity.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLActivity.h"

@implementation RLActivity
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (instancetype)init {
    if(self = [super init]) {
        self.message = [[RLShareMessageModel alloc] init];
        
        [self.message fillDefaultData];
    }
    
    return self;
}

- (NSString *)activityType {
    return NSStringFromClass(self.class);
}

- (NSString *)activityTitle {
    return self.title;
}

- (UIImage *)activityImage {
    return self.icon;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)performActivity {
    if(self.callback && self.delegate) {
        [self.delegate performSelectorOnMainThread:self.callback withObject:self.message waitUntilDone:NO];
    }
    
    [self activityDidFinish:YES];
//    else if(self.callbackBlock) {
//        self.callbackBlock();
//    }
}
@end
