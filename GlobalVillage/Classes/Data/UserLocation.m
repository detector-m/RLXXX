//
//  UserLocation.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/20.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation
- (void)dealloc {
    [self dataClear];
}

- (NSString *)description {
    NSDictionary *descriptionDic = @{
                                     @"latitude":[NSNumber numberWithDouble:self.latitude],
                                     @"longitude":[NSNumber numberWithDouble:self.longitude],
                                     @"country":self.country,
                                     @"city":self.city};
    
    return [NSString stringWithFormat:@"(%@ : %p, %@)",[self class],self, descriptionDic];
}

- (void)dataClear {
    self.latitude = CGFLOAT_MAX;
    self.longitude = CGFLOAT_MAX;
    
    self.country = nil;
    self.city = nil;
}
@end
