//
//  WWHomeBookModel.m
//  Mr.Time
//
//  Created by steaest on 2017/9/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWHomeBookModel.h"

@implementation WWHomeBookModel
@end

@implementation WWHomeJsonBookModel : NSObject
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [WWHomeBookModel class]};
}
@end
