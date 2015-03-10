//
//  Person.h
//  GlobalVillage
//
//  Created by RivenL on 15/3/7.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, assign) GenderType gender;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *pic;
@end
