//
//  RLLocationManager.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/21.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLLocationManager : NSObject
@property (nonatomic, readwrite, weak) UserLocation *location;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
@end
