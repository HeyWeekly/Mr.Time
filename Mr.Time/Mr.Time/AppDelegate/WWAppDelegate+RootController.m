//
//  WWAppDelegate+RootController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAppDelegate+RootController.h"
#import "VTGeneralTool.h"
#import "RDVTabBar.h"
#import "RDVTabBarItem.h"

@interface WWAppDelegate ()<RDVTabBarControllerDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>
@end

@implementation WWAppDelegate (RootController)
- (void)setRootViewController
{
        [self setRoot];
}
- (void)setRoot
{
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    navc.navigationBar.barTintColor = [UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0];
    
    navc.navigationBar.shadowImage = [[UIImage alloc] init];
    [navc.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [navc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navc.navigationBar.tintColor = [UIColor whiteColor];
    self.window.rootViewController = navc;
}
#pragma mark - Windows
- (void)setTabbarController
{
    HomeViewController *home = [[HomeViewController alloc]init];
//        UINavigationController *schoolNav = [[UINavigationController alloc]initWithRootViewController:home];
    
    BookViewController *book  = [[BookViewController alloc]init];
//        UINavigationController *chidNav = [[UINavigationController alloc]initWithRootViewController:book];
    
    CollectViewController *coll = [[CollectViewController alloc]init];
//        UINavigationController *eduNav = [[UINavigationController alloc]initWithRootViewController:coll]
    
    UserViewController *user = [[UserViewController alloc]init];
//        UINavigationController *aboutNav = [[UINavigationController alloc]initWithRootViewController:user];
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[home,book,coll,coll,user]];
    self.viewController = tabBarController;
    tabBarController.delegate = self;
    [self customizeTabBarForController:tabBarController];
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[HomeViewController class]])
    {
        tabBarController.navigationItem.title = @"人生进度";
    }
    if ([viewController isKindOfClass:[BookViewController class]])
    {
        tabBarController.navigationItem.title = @"人间指南";
    }
    if ([viewController isKindOfClass:[CollectViewController class]])
    {
        tabBarController.navigationItem.title = @"收藏";
    }
    if ([viewController isKindOfClass:[UserViewController class]])
    {
        tabBarController.navigationItem.title = @"";
    }
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *finishedImage = [VTGeneralTool createImageWithColor:[UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0]];
    UIImage *unfinishedImage = [VTGeneralTool createImageWithColor:[UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0]];
    NSArray *tabBarItemImages = @[@"homeNormal",@"bookNormal",@"collectNormal",@"",@"userNormal"];
    NSArray *selectedImages = @[@"homeSelect",@"bookSelect",@"collectSelect",@"",@"userSelect"];
    NSInteger index = 0;
    [[tabBarController tabBar] setTranslucent:YES];
    for (RDVTabBarItem *item in [[tabBarController tabBar] items])
    {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[selectedImages objectAtIndex:index]];
        UIImage *unselectedimage = [UIImage imageNamed:[tabBarItemImages objectAtIndex:index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}
- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)goToMain
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isOne" forKey:@"isOne"];
    [user synchronize];
    [self setRoot];
}
@end
