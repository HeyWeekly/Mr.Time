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
    [self setAppWindows];
    [self setTabbarController]; 
    [self setRootViewController];

    [self.window makeKeyAndVisible];
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
