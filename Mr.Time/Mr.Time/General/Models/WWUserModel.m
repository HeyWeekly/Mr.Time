//
//  WWUserModel.m
//  Mr.Time
//
//  Created by steaest on 2017/8/16.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWUserModel.h"
#import "NSObject+YYModel.h"

static WWUserModel *instance;

@implementation WWUserModel

+ (instancetype)shareUserModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WWUserModel alloc]init];
        instance = (WWUserModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
    });
    return instance;
}

/// 保存用户信息
- (void) saveAccount {
    [NSKeyedArchiver archiveRootObject:self toFile:ArchiverPath];
}
///  清空用户信息
+ (void)clearUserAccount {
    instance = nil;
    [[NSFileManager defaultManager] removeItemAtPath:ArchiverPath error:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

@end
