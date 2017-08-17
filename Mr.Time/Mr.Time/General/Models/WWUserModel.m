//
//  WWUserModel.m
//  Mr.Time
//
//  Created by steaest on 2017/8/16.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWUserModel.h"
#import "NSObject+YYModel.h"

@implementation WWUserModel

+ (instancetype)shareUserModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareUserModel = (WWUserModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
    });
    return shareUserModel;
}

/// 保存用户信息
- (void) saveAccount {
    [NSKeyedArchiver archiveRootObject:self toFile:ArchiverPath];
}
///  清空用户信息
+ (void)clearUserAccount {
    shareUserModel = nil;
    [[NSFileManager defaultManager] removeItemAtPath:ArchiverPath error:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

@end
