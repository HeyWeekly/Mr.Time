//
//  WWRootViewController.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWRootViewController : UIViewController
///是否显示tabbar
@property (nonatomic,assign)Boolean isShowTabbar;
///
- (void)messageBar;
///
- (void)createNavBar;
///显示没有数据页面
-(void)showNoDataImage;
///移除无数据页面
-(void)removeNoDataImage;
///需要登录
- (void)showShouldLoginPoint;
///加载视图
- (void)showLoadingAnimation;
///停止加载
- (void)stopLoadingAnimation;

/**
 *  分享页面
 *
 *  @param url   url
 *  @param title 标题
 */
- (void)shareUrl:(NSString *)url andTitle:(NSString *)title;
///
- (void)goLogin;

///状态栏
- (void)initStatusBar;
///
- (void)showStatusBarWithTitle:(NSString *)title;
///
- (void)changeStatusBarTitle:(NSString *)title;
///
- (void)hiddenStatusBar;
@end
