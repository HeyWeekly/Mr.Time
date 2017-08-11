//
//  WWGeneric.m
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWGeneric.h"

@implementation WWGeneric
+ (instancetype)sharedUtils {
    static WWGeneric *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WWGeneric alloc] init];
    });
    
    return _instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSTimeInterval)adjustTimestampFromServer:(long long)timestamp {
    if (timestamp > 140000000000) {
        timestamp /= 1000;
    }
    return timestamp;
}

@end
