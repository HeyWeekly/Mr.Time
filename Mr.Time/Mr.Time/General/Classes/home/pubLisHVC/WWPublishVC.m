//
//  WWPublishVC.m
//  Mr.Time
//
//  Created by steaest on 2017/6/18.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWPublishVC.h"

@interface WWPublishVC ()
@property (nonatomic, strong) WWNavigationVC *nav;
@end

@implementation WWPublishVC
- (instancetype)initWithYear:(NSInteger )years{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.view addSubview:self.nav];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"发布";
    }
    return _nav;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
