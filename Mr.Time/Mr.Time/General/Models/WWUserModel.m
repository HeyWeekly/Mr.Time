//
//  WWUserModel.m
//  Mr.Time
//
//  Created by steaest on 2017/8/16.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWUserModel.h"
#import "NSObject+YYModel.h"

static WWUserModel *instance = nil;

@implementation WWUserModel

+ (instancetype)shareUserModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[WWUserModel alloc]init];
            instance = (WWUserModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
        }
    });
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (instance == nil) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}

-(id)copy {
    return self;
}

-(id)mutableCopy {
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return self;
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
