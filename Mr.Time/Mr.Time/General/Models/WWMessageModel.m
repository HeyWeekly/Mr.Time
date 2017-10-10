//
//  WWMessageModel.m
//  Mr.Time
//
//  Created by steaest on 2017/9/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWMessageModel.h"

@implementation WWHotMessageDetailModel
@end

@implementation WWMessageDetailModel
@end

@implementation WWMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"lastest_cmts" : [WWMessageDetailModel class],
             @"hot_cmts" : [WWHotMessageDetailModel class] };
}
@end

@implementation WWJsonMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [WWMessageModel class]};
}
@end
