//
//  ProfleModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, ProfileMode) {
    kProfileModeDefault,
    kProfileModePic,
    kProfileModeBirthday,
    kProfileModeGroup,
    kProfileModeCircle,
    kProfileModeReadonly,
};

@interface ProfileModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ProfileMode mode;
@end
