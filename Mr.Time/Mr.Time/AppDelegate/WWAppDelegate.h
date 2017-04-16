//
//  WWAppDelegate.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UIViewController * viewController;

+ (UINavigationController *)rootNavigationController;

@end
