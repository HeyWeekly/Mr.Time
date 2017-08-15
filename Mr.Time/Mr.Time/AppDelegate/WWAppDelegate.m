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
#import "WXApi.h"

@interface WWAppDelegate ()<WXApiDelegate>
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
    
    [WXApi registerApp:@"wxfaf372338328fa69"];
    
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

#pragma mark - App挑选回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp*)resp {
    //微信登录
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            [self loadWechatLoginInformation:resp2.code];
        }else{ //失败
        }
    }
}

@end
