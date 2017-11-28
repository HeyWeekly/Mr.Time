//
//  WWNewMessageVC.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/11/22.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRootViewController.h"

@interface WWNewMessageVC : WWRootViewController
- (instancetype)initWithMettoId:(NSInteger)mettoId withContent:(NSString *)content withPersonInfo:(NSString *)personInfo withName:(NSString *)name withFavCount:(NSString *)favCount withYear:(NSString *)years;
@end
