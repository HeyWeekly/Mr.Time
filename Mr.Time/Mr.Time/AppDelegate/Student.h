//
//  Student.h
//  Mr.Time
//
//  Created by steaest on 2017/9/4.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property (nonatomic, assign) int id;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,strong)NSString* name;
@property (nonatomic, assign) int age;
@end
