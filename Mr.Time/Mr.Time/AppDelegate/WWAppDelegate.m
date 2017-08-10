//
//  WWAppDelegate.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAppDelegate.h"
#import "WWAppDelegate+AppService.h"
#import "WWAppDelegate+AppLifeCircle.h"
#import "WWAppDelegate+RootController.h"
#import "MLTransition.h"
#import "IQKeyboardManager.h"

@interface WWAppDelegate ()
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,assign) NSInteger *imageIndex;
@end

@implementation WWAppDelegate
+ (UINavigationController *)rootNavigationController {
    WWAppDelegate *app = (WWAppDelegate *)[UIApplication sharedApplication].delegate;
    return (UINavigationController *)app.window.rootViewController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES; //默认值为NO.
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//不显示工具条
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;//点空白处收回
    
    [self setAppWindows];
    [self setTabbarController]; 
    [self setRootViewController];

    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess) name:@"userLoginSuccess" object:nil];
//    [self LoginSuccess];
    return YES;
}
- (void)setUpWindows {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    [self.window makeKeyAndVisible];
}

- (void)clearBadgeValue {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
@end
