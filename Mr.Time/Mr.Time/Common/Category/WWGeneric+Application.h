//
//  WWGeneric+Application.h
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWGeneric.h"
#import "WWAppDelegate.h"

@interface WWGeneric (Application)
+ (UIViewController *)rootViewController;

+ (UIWindow *)currentWindow;

+ (UIWindow *)popOverWindow;

+ (void)addViewToPopOverWindow:(UIView *)view;

+ (void)removeViewFromPopOverWindow:(UIView *)view;

+ (WWAppDelegate *)appDelegate;

+ (UIViewController *)viewControllerForView:(UIView *)view;

+ (void)removeViewControllerFromParentViewController:(UIViewController *)viewController;

+ (void)addViewController:(UIViewController *)viewController  toViewController:(UIViewController *)parentViewController;

+ (void)startObserveRunLoop;

+ (void)stopObserveRunLoop;
@end
