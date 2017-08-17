//
//  WWUserModel.h
//  Mr.Time
//
//  Created by steaest on 2017/8/16.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWUserModel : NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *dataStr;
@property (nonatomic, copy) NSString *yearDay;
@property (nonatomic, strong) UIImage *headimg;
+ (instancetype)shareUserModel;
- (void) saveAccount;
+ (void)clearUserAccount;
@end
