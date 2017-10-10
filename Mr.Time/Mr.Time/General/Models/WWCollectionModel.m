//
//  WWCollectionModel.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/30.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCollectionModel.h"

@implementation WWCollectionModel
@end


@implementation WWCollectionJsonModel : NSObject
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [WWCollectionModel class]};
}
@end
