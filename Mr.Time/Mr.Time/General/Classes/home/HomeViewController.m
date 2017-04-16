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
    [self.view addSubview:self.tipsLabel];
//    self.tipsLabel.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}
#pragma mark - lazyLoad
- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.text = @"如果我们能活到 100 岁并把我们的人生分散成 100 个方格";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
//        _tipsLabel.backgroundColor =
        _tipsLabel.font = [UIFont fontWithName:kFont_Medium size:28*screenRate];
    }
    return _tipsLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
