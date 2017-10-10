//
//  WWRootViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRootViewController.h"
#import "WWAppDelegate.h"
@interface WWRootViewController ()<UIGestureRecognizerDelegate>
{
    UIImageView *_barImage;
    
    NSTimer * _flashMessageBtnTimer;
}
@property (nonatomic,strong) UIImageView* noDataView;
@end

@implementation WWRootViewController
//做全局loading与全局消息推送
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count>1) {
        return YES;
    }else {
        return NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
