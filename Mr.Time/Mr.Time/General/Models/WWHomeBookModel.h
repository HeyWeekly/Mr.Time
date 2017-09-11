//
//  WWHomeBookModel.h
//  Mr.Time
//
//  Created by steaest on 2017/9/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHomeBookModel : NSObject
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *pubtime;
@property (nonatomic, strong) NSString *id;
@end

@interface WWHomeJsonBookModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray <WWHomeBookModel *> *result;
@end
