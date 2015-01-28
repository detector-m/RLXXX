//
//  RLBaseCollectionViewController.h
//  GlobalVillage
//
//  Created by RivenL on 15/1/19.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLBaseViewController.h"

extern NSString * const reuseCellIdentifier;
extern NSString * const reuseSupplementaryIdentifier;

@interface RLBaseCollectionViewController : RLBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
