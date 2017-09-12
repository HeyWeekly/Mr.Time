//
//  WWMessageModel.m
//  Mr.Time
//
//  Created by steaest on 2017/9/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWMessageModel.h"

@implementation WWMessageDetailModel
@end

@implementation WWMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cmts" : [WWMessageDetailModel class]};
}
@end

@implementation WWJsonMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [WWMessageModel class]};
}
@end
