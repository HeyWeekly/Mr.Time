//
//  WWAppDelegate+RootController.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAppDelegate.h"

@interface WWAppDelegate (RootController)

///首次启动轮播图
- (void)createLoadingScrollView;

///tabbar实例
- (void)setTabbarController;

///window实例
- (void)setAppWindows;

///根视图
- (void)setRootViewController;

- (void)LoginSuccess;

@end
