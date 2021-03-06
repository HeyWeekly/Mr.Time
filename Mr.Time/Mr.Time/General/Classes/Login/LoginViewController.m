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
#import "WWLabel.h"
#import <YYText/YYText.h>
#import "WWRegisVC.h"

@interface LoginViewController ()
@property (nonatomic, strong) WWLabel *furture;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *settingLabel;
@property (nonatomic, strong) YYLabel *regisBtn;
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
    [self.view addSubview:self.centerImage];
    [self.centerImage sizeToFit];
    self.centerImage.centerX = self.view.centerX;
    self.centerImage.top = 60*screenRate;
    
    [self.view addSubview:self.furture];
    [self.furture sizeToFit];
    self.furture.centerX = self.view.centerX;
    self.furture.top = self.centerImage.bottom+36*screenRate;
    
    [self.view addSubview:self.settingLabel];
    [self.settingLabel sizeToFit];
    self.settingLabel.centerX_sd = self.view.centerX_sd;
    self.settingLabel.bottom_sd = self.view.bottom_sd - 16*screenRate  - 49;
    
    [self.view addSubview:self.weChatBtn];
    [self.weChatBtn sizeToFit];
    self.weChatBtn.centerX = self.view.centerX;
    self.weChatBtn.bottom = self.view.bottom - 16*screenRate  - 49;
    if (![WXApi isWXAppInstalled]) {
        self.settingLabel.hidden = NO;
        self.weChatBtn.hidden = YES;
    }else {
        self.settingLabel.hidden = YES;
        self.weChatBtn.hidden = NO;
    }
    [self.view addSubview:self.regisBtn];
    [self.regisBtn sizeToFit];
    self.regisBtn.centerX_sd = self.view.centerX_sd;
    self.regisBtn.bottom = self.view.bottom  - 49;
}

#pragma mark - event
- (void)settingLabelClick {
    WWLoginSettingInfoVC *vc = [[WWLoginSettingInfoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)weChatBtnClick {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
    [WWHUD showProgress:nil inView:self.view];
}

//微信回调通知
- (void)weChatCompltion:(NSNotification*)notify {
    NSDictionary *user = notify.object;
    WWUserModel *userModel = [WWUserModel shareUserModel];
     userModel = [WWUserModel yy_modelWithDictionary:[user valueForKey:@"result"]];
    [userModel saveAccount];
    dispatch_sync(dispatch_get_main_queue(), ^(){
        [WWHUD hide];
         if ([[user valueForKey:@"code"] integerValue] == 1) {
             WWLoginSettingInfoVC *vc = [[WWLoginSettingInfoVC alloc]init];
             [self.navigationController pushViewController:vc animated:YES];
         }else {
             [WWHUD showMessage:@"登录失败，请重试" inView:self.view];
         }
    });
}
//微信失败回调
- (void)weChatFailureCompltion:(NSNotification*)notify {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [WWHUD showMessage:@"微信回调失败，请重试" inView:self.view];
    });
}

#pragma mark - lazy
- (UIButton *)settingLabel {
    if (_settingLabel == nil) {
        _settingLabel = [[UIButton alloc]init];
        [_settingLabel setTitle:@"下一步" forState:UIControlStateNormal];
        _settingLabel.titleLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
//        _settingLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
//        _settingLabel.text = @"下一步";
//        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)RGBCOLOR(0x2EFFB6).CGColor];
//        _settingLabel.colors =gradientColors;
        [_settingLabel setTitleColor:RGBCOLOR(0x15C2FF) forState:UIControlStateNormal];
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingLabelClick)];
//        [_settingLabel addGestureRecognizer:singleTap];
        [_settingLabel addTarget:self action:@selector(settingLabelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingLabel;
}

- (WWLabel *)furture {
    if (_furture == nil) {
        _furture = [[WWLabel alloc]init];
        _furture.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _furture.text = @"上帝知道何时开始，何时结束，人只知道中间";
        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)RGBCOLOR(0x2EFFB6).CGColor];
        _furture.colors =gradientColors;
    }
    return _furture;
}

- (UIImageView *)centerImage {
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.image = [UIImage imageNamed:@"Onboarding"];
    }
    return _centerImage;
}

- (UIButton *)weChatBtn {
    if (_weChatBtn == nil) {
        _weChatBtn = [[UIButton alloc]init];
        [_weChatBtn setImage:[UIImage imageNamed:@"weChatLogin"] forState:UIControlStateNormal];
        if (![WXApi isWXAppInstalled]) {
            self.weChatBtn.hidden = YES;
        }
        [_weChatBtn addTarget:self action:@selector(weChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatBtn;
}

- (YYLabel *)regisBtn {
    if (_regisBtn == nil) {
        _regisBtn = [[YYLabel alloc]init];
        NSMutableAttributedString *text;
        NSInteger loc;
        WEAK_SELF;
        if (![WXApi isWXAppInstalled]) {
            text = [[NSMutableAttributedString alloc] initWithString:@"点击下一步代表您同意《使用协议》"];
            loc = 10;
        }else {
             text = [[NSMutableAttributedString alloc] initWithString:@"注册代表您同意《使用协议》"];
            loc = 7;
        }
        text.yy_font = [UIFont fontWithName:kFont_Light size:12];
        text.yy_color = RGBCOLOR(0xe5e5e5);
        [text yy_setTextHighlightRange:NSMakeRange(loc, 6)
                                 color:RGBCOLOR(0x0076FF)
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 [weakSelf regisClick];
                             }];
        _regisBtn.attributedText = text;
    }
    return _regisBtn;
}

- (void)regisClick {
    WWRegisVC *vc = [[WWRegisVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
