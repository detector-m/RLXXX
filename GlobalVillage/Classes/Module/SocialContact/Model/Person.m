//
//  Person.m
//  GlobalVillage
//
//  Created by RivenL on 15/3/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)dealloc {
    self.nickname = nil;
    self.abstract = nil;
    self.distance = nil;
    self.date = nil;
    self.pic = nil;
}
@end
