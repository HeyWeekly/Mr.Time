//
//  WWCollectionModel.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/30.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWCollectionModel : NSObject
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *enshrineCnt;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *pubtime;
@property (nonatomic, copy) NSString *userOpenid;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *authorAge;
@end

@interface WWCollectionJsonModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray <WWCollectionModel *> *result;
@end
