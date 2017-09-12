//
//  WWHomeBookModel.h
//  Mr.Time
//
//  Created by steaest on 2017/9/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHomeBookModel : NSObject
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pubtime;
@property (nonatomic, copy) NSString *aid;
@end

@interface WWHomeJsonBookModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray <WWHomeBookModel *> *result;
@end
