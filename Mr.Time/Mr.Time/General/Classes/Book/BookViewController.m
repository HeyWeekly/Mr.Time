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
#import "WWHomeBookModel.h"

@interface BookViewController ()<WWCardSlideDelegate> {
    WWCardSlide *_cardSlide;
}
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) NSArray <WWHomeBookModel *> *modelArray;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self loadMettoData];
    [self.view addSubview:self.nav];
    
}

#pragma mark - delegate
- (void)cellWWCardSlideDidSelected {
    WWMessageVC *vc = [[WWMessageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - netWork
- (void)loadMettoData {
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getAllMotto;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"page":@(0),@"pagesize":@(20)};
    } onSuccess:^(id  _Nullable responseObject) {
            WWHomeJsonBookModel *model = [WWHomeJsonBookModel yy_modelWithJSON:responseObject];
        if ([model.code isEqualToString:@"1"]) {
            self.modelArray = model.result;
            _cardSlide = [[WWCardSlide alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) andModel:self.modelArray];
            _cardSlide.models = self.modelArray;
            _cardSlide.delegate = self;
            _cardSlide.selectedIndex = 0;
            [self.view addSubview:_cardSlide];
        }else {
#warning 提示
        }
    } onFailure:^(NSError * _Nullable error) {
#warning 提示信息
    } onFinished:nil];
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

@end
