//
//  LoginViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "LoginViewController.h"
#import "WWLoginSettingInfoVC.h"
#import "WXApi.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIImageView *furture;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIButton *weChatBtn;
@end

@implementation LoginViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatCompltion:) name:@"WeChatLoginSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatFailureCompltion:) name:@"WeChatLoginFailure" object:nil];
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.furture];
    [self.furture sizeToFit];
    self.furture.centerX = self.view.centerX;
    self.furture.top = 100*screenRate;
    
    [self.view addSubview:self.centerImage];
    [self.centerImage sizeToFit];
    self.centerImage.centerX = self.view.centerX;
    self.centerImage.top = self.furture.bottom+56*screenRate;
    
    [self.view addSubview:self.weChatBtn];
    [self.weChatBtn sizeToFit];
    self.weChatBtn.centerX = self.view.centerX;
    self.weChatBtn.bottom = self.view.bottom - 16*screenRate  - 49;
}

#pragma mark - event
- (void)weChatBtnClick {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
}

//微信回调通知
- (void)weChatCompltion:(NSNotification*)notify {
    NSDictionary *user = notify.object;
    WWUserModel *userModel = [WWUserModel shareUserModel];
     userModel = [WWUserModel yy_modelWithDictionary:[user valueForKey:@"result"]];
    NSLog(@"%@",[user valueForKey:@"result"]);
    [userModel saveAccount];
    dispatch_sync(dispatch_get_main_queue(), ^(){
        if ([[user valueForKey:@"code"] integerValue] == 1) {
            WWLoginSettingInfoVC *vc = [[WWLoginSettingInfoVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"登录失败，请重试"}];
        }
    });
}
//微信失败回调
- (void)weChatFailureCompltion:(NSNotification*)notify {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"登录失败，请重试"}];
}

#pragma mark - lazy
- (UIImageView *)furture {
    if (_furture == nil) {
        _furture = [[UIImageView alloc]init];
        _furture.image = [UIImage imageNamed:@"qianmuFurture"];
    }
    return _furture;
}

- (UIImageView *)centerImage {
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.image = [UIImage imageNamed:@"Onboarding@2x"];
    }
    return _centerImage;
}

- (UIButton *)weChatBtn {
    if (_weChatBtn == nil) {
        _weChatBtn = [[UIButton alloc]init];
        [_weChatBtn setImage:[UIImage imageNamed:@"weChatLogin"] forState:UIControlStateNormal];
        [_weChatBtn addTarget:self action:@selector(weChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatBtn;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
