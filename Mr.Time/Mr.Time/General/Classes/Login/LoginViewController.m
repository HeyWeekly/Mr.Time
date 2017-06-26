//
//  LoginViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIImageView *furture;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIButton *weChatBtn;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)weChatBtnClick {
    
}
- (UIImageView *)furture {
    if (_furture == nil) {
        _furture = [[UIImageView alloc]init];
        _furture.image = [UIImage imageNamed:@""];
    }
    return _furture;
}
- (UIImageView *)centerImage {
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.image = [UIImage imageNamed:@""];
    }
    return _centerImage;
}
- (UIButton *)weChatBtn {
    if (_weChatBtn) {
        _weChatBtn = [[UIButton alloc]init];
        [_weChatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_weChatBtn addTarget:self action:@selector(weChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
