//
//  AddFriendController.h
//  GlobalVillage
//
//  Created by RivenL on 15/3/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ModuleController.h"
@protocol AddFriendControllerDelegate <ModuleControllerDelegate>
@optional
- (void)nearbyPersonResponse:(GVResponse *)response;
@end

@interface AddFriendController : ModuleController
- (void)nearbyPersonRequest:(NSString *)accessToken longitude:(double)longitude latitude:(double)latitude radius:(NSInteger)radius pageCount:(NSInteger)pageCount currentCount:(NSInteger)currentCount;

@end
