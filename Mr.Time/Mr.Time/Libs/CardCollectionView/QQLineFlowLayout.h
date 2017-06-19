//
//  QQLineFlowLayout.h
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/12.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScreenEx.h"

#define ITEM_SIZE_WIDTH  ((SCREEN_WIDTH) * 0.87466)          //328.f
#define ITEM_SIZE_HEIGHT ((SCREEN_HEIGHT- 64 - 44) * 0.4042) //226.f

@interface QQLineFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSUInteger cellCount;

@property (nonatomic, strong) NSMutableArray    *arrayVisibleAttributes;

@end
