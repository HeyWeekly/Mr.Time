//
//  BookViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "BookViewController.h"
#import "WWCardSlide.h"
#import "WWMessageVC.h"
@interface BookViewController ()<WWCardSlideDelegate> {
    WWCardSlide *_cardSlide;
}
@property (nonatomic, strong) WWNavigationVC *nav;
@end

@implementation BookViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.view addSubview:self.nav];
    _cardSlide = [[WWCardSlide alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _cardSlide.delegate = self;
    _cardSlide.selectedIndex = 0;
    [self.view addSubview:_cardSlide];
}
#pragma mark - delegate
- (void)cellWWCardSlideDidSelected {
    WWMessageVC *vc = [[WWMessageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 懒加载
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"人间指南";
    }
    return _nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
