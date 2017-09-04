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
#import "WWErrorView.h"
#import "FMDatabase.h"

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
    
    [self creatBookSq];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess) name:@"userLoginSuccess" object:nil];
    
    [WWErrorView alloc];
    
    [WXApi registerApp:@"wxfaf372338328fa69"];
    
    [self setAppWindows];
    [self setTabbarController]; 
    [self setRootViewController];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)creatBookSq {
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"%@",fileName);
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result)
        {
            NSLog(@"创建成功");
        }
    }
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
        if (resp.errCode == 0) {  //成功
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            [self loadWechatLoginInformation:resp2.code];
        }else{ //失败
        }
    }
}

@end
