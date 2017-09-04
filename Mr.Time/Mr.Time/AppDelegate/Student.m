//
//  Student.m
//  Mr.Time
//
//  Created by steaest on 2017/9/4.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "Student.h"

@implementation Student
- (instancetype)init {
    if (self = [super init]) {
        self.id = 2;
        self.name = @"王二黑";
        self.sex = @"男";
        self.age = 25;
    }
    return self;
}
@end
