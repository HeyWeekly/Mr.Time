//
//  HomeViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UILabel *tipsLabel2;
@property (nonatomic,strong) UILabel *navLabel;
@property (nonatomic,strong) UILabel *yearsNum;
@property (nonatomic,strong) UILabel *yearLbael;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0];
    [self setupSubViews];
    
}
- (void)setupSubViews {
    [self.view addSubview:self.navLabel];
    [self.navLabel sizeToFit];
    self.navLabel.centerX = self.view.centerX;
    self.navLabel.top = 30*screenRate;
    [self.navLabel sizeToFit];
    [self.view addSubview:self.yearsNum];
    [self.yearsNum sizeToFit];
    self.yearsNum.centerX = self.view.centerX;
    self.yearsNum.top = self.navLabel.bottom+26*screenRate;
    [self.yearsNum sizeToFit];
    [self.view addSubview:self.yearLbael];
    [self.yearLbael sizeToFit];
    self.yearLbael.centerX = self.view.centerX;
    self.yearLbael.top = self.yearsNum.bottom;
    [self.yearLbael sizeToFit];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel sizeToFit];
    self.tipsLabel.centerX = self.view.centerX;
    self.tipsLabel.top = 548*screenRate;
    [self.tipsLabel sizeToFit];
    [self.view addSubview:self.tipsLabel2];
    [self.tipsLabel2 sizeToFit];
    self.tipsLabel2.centerX = self.view.centerX;
    self.tipsLabel2.top = self.tipsLabel.bottom;
    [self.tipsLabel2 sizeToFit];
}
#pragma mark - lazyLoad
- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.text = @"如果我们能活到 100 岁";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _tipsLabel.textColor = RGBCOLOR(0x545454);
    }
    return _tipsLabel;
}
- (UILabel *)tipsLabel2 {
    if (_tipsLabel2 == nil) {
        _tipsLabel2 = [[UILabel alloc]init];
        _tipsLabel2.text = @"并把我们的人生分散成 100 个方格";
        _tipsLabel2.textAlignment = NSTextAlignmentCenter;
        _tipsLabel2.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _tipsLabel2.textColor = RGBCOLOR(0x545454);
    }
    return _tipsLabel2;
}
- (UILabel *)navLabel {
    if (_navLabel == nil) {
        _navLabel = [[UILabel alloc]init];
        _navLabel.text = @"人生进度";
        _navLabel.textAlignment = NSTextAlignmentCenter;
        _navLabel.font = [UIFont fontWithName:kFont_Medium size:17*screenRate];
        _navLabel.textColor = [UIColor whiteColor];
    }
    return _navLabel;
}
- (UILabel *)yearLbael {
    if (_yearLbael == nil) {
        _yearLbael = [[UILabel alloc]init];
        _yearLbael.text = @"YEARS OLD";
        _yearLbael.textAlignment = NSTextAlignmentCenter;
        _yearLbael.font = [UIFont fontWithName:kFont_Medium size:24*screenRate];
        _yearLbael.textColor = RGBCOLOR(0x545454);
    }
    return _yearLbael;
}
- (UILabel *)yearsNum {
    if (_yearsNum == nil) {
        _yearsNum = [[UILabel alloc]init];
        _yearsNum.text = @"30";
        _yearsNum.textAlignment = NSTextAlignmentCenter;
        _yearsNum.font = [UIFont fontWithName:@"DINAlternate-Bold" size:66*screenRate];
        _yearsNum.textColor = [UIColor whiteColor];
    }
    return _yearsNum;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
