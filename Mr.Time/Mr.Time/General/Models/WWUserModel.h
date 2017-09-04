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
@property (nonatomic, copy) NSString *dataStr;
//年龄
@property (nonatomic, copy) NSString *yearDay;
@property (nonatomic, strong) UIImage *headimg;
@property (nonatomic, assign) BOOL isNewUser;
+ (instancetype)shareUserModel;
- (void) saveAccount;
+ (void)clearUserAccount;
@end
