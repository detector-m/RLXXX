//
//  UserLocation.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject
@property (nonatomic, readwrite, assign) CGFloat latitude;
@property (nonatomic, readwrite, assign) CGFloat longitude;

@property (nonatomic, readwrite, copy) NSString *country;
@property (nonatomic, readwrite, copy) NSString *city;

- (void)dataClear;
@end
