//
//  QQEngine.m
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/12.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import "QQEngine.h"

@interface QQEngine()
@property(nonatomic,assign) NSUInteger cardCount;
@end

@implementation QQEngine

+(instancetype) sharedInstance {
    static QQEngine* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QQEngine alloc] init];
    });
    
    return instance;
}

-(instancetype)init {
    if(self = [super init]){
        self.cardCount = REAL_CELL_COUNT;//顶部多2张，底部多2张
    }
    return self;
}

-(NSUInteger) getCardCount {
    return self.cardCount;
}

-(BOOL) isAlphaViewrow:(NSUInteger) row {
//    if( (row == self.cardCount - 1) || row == 0 || row == 1)
//            return YES;
    
     return NO;
}

@end
