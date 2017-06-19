//
//  QQEngine.h
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/12.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PAGECOUNT          5     //每一页有的数目
#define REAL_CELL_COUNT    25    //总共的数目


@interface QQEngine : NSObject

+(instancetype) sharedInstance;

-(NSUInteger) getCardCount;

-(BOOL) isAlphaViewrow:(NSUInteger) row;

@end
