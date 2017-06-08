//
//  CollectViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "CollectViewController.h"
#import "Mr_Time-Swift.h"
@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) CardView *card;
@end

@implementation CollectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self setupViews];
    
}
- (void)setupViews {
    [self.view addSubview:self.nav];
    [self.view addSubview:self.card];
    self.card.frame = CGRectMake(0, 0, KWidth, KHeight);
    
}


#pragma mark - 懒加载
- (CardView *)card {
    if (_card == nil) {
        _card = [[CardView alloc]init];
        _card.backgroundColor = [UIColor redColor];
    }
    return _card;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = viewBackGround_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"收藏";
    }
    return _nav;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
