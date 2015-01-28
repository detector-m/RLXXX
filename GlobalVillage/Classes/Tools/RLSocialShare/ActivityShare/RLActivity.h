//
//  RLActivity.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/26.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLShareMessageModel.h"

//typedef void (^CallbackBlock)(void);
@interface RLActivity : UIActivity
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) RLShareMessageModel *message;
@property (nonatomic, assign) SEL callback;
@property (nonatomic, weak) id delegate;

//@property (nonatomic, strong) CallbackBlock callbackBlock;
@end
