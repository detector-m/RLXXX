//
//  RLTableModel.h
//  GlobalVillage
//
//  Created by RivenL on 15/2/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLTableModel : NSObject
@property (nonatomic, readonly, strong) NSMutableArray *datas Description(datas);
@property (nonatomic, assign) BOOL needRefresh;
@end
