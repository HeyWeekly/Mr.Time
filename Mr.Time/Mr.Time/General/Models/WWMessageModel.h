//
//  WWMessageModel.h
//  Mr.Time
//
//  Created by steaest on 2017/9/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHotMessageDetailModel : NSObject
@property (nonatomic, copy) NSString *apothegmId;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pubTime;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface WWMessageDetailModel : NSObject
@property (nonatomic, copy) NSString *apothegmId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *favourCnt;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pubTime;
@property (nonatomic, copy) NSString *userOpenid;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface WWMessageModel : NSObject
@property (nonatomic, strong) NSArray<WWMessageDetailModel *> *lastest_cmts;
@property (nonatomic, strong) NSArray<WWHotMessageDetailModel *> *hot_cmts;
@end

@interface WWJsonMessageModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) WWMessageModel *result;
@end
