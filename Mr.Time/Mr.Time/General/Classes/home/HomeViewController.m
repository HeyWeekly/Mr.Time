//
//  HomeViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "HomeViewController.h"
#import "WWSimpleVC.h"
@interface HomeViewController ()
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UILabel *tipsLabel2;
@property (nonatomic,strong) UILabel *navLabel;
@property (nonatomic,strong) UILabel *yearsNum;
@property (nonatomic,strong) UILabel *yearLbael;
@property (nonatomic, strong) UIButton *dayLabel;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
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
    [self.view addSubview:self.dayLabel];
    self.dayLabel.frame = CGRectMake(100, 100, 100,100);
    
    int totalColumns = 10;
    CGFloat cellW = 12*screenRate;
    CGFloat cellH = 12*screenRate;
    CGFloat margin =19*screenRate;
    
    for(int index = 0; index< 100; index++) {
        UIView *cellView = [[UIView alloc ]init ];
        cellView.backgroundColor = RGBCOLOR(0x404040);
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = 44*screenRate + col * (cellW + margin);
        CGFloat cellY = self.yearLbael.bottom+30*screenRate+row * (cellH + margin);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        // 添加到view 中  
        [self.view addSubview:cellView];  
    }
    
    CGFloat cellW2 = 22*screenRate;
    CGFloat cellH2 = 22*screenRate;
    CGFloat margin2 =9*screenRate;
    
    for(int index = 0; index< self.yearsNum.text.integerValue; index++) {
        UIView *cellView = [[UIView alloc ]init ];
        cellView.backgroundColor = RGBCOLOR(0x00FFD5);
        cellView.layer.shadowColor = RGBCOLOR(0x27ECCC).CGColor;
        cellView.layer.shadowOpacity = 0.35;
        cellView.layer.shadowRadius = 6;
        cellView.layer.shadowOffset = CGSizeMake(1, 1);
        cellView.layer.cornerRadius = 4;
        cellView.clipsToBounds = YES;
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = 39*screenRate + col * (cellW2 + margin2);
        CGFloat cellY = self.yearLbael.bottom+25*screenRate+row * (cellH2 + margin2);
        cellView.frame = CGRectMake(cellX, cellY, cellW2, cellH2);
        // 添加到view 中
        [self.view addSubview:cellView];
    }
    
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
        _yearsNum.text = @"26";
        _yearsNum.textAlignment = NSTextAlignmentCenter;
        _yearsNum.font = [UIFont fontWithName:kFont_DINAlternate size:66*screenRate];
        _yearsNum.textColor = [UIColor whiteColor];
        _yearsNum.layer.shadowColor = [UIColor blackColor].CGColor;
        _yearsNum.layer.shadowOpacity = 0.5;
        _yearsNum.layer.shadowRadius = 10;
        _yearsNum.layer.shadowOffset = CGSizeMake(0, 8*screenRate);
    }
    return _yearsNum;
}
- (UIButton *)dayLabel {
    if (_dayLabel == nil) {
        _dayLabel = [[UIButton alloc]init];
        [_dayLabel setBackgroundColor:[UIColor redColor]];
        [_dayLabel addTarget:self action:@selector(dsada) forControlEvents:UIControlEventTouchUpInside];
        _dayLabel.hidden = YES;
    }
    return _dayLabel;
}
- (void)dsada {
    WWSimpleVC *vc = [[WWSimpleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
