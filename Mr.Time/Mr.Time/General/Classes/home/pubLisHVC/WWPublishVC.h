//
//  WWPublishVC.h
//  Mr.Time
//
//  Created by steaest on 2017/6/18.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRootViewController.h"

@interface WWPublishVC : WWRootViewController
@property (nonatomic, assign) NSInteger mettoId;
- (instancetype)initWithYear:(NSInteger )years andIsPublish:(BOOL)isPublish;
@end
