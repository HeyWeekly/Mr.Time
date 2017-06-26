//
//  WWSettingVC.m
//  Mr.Time
//
//  Created by steaest on 2017/6/26.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWSettingVC.h"

@interface SettingSwitchCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UISwitch *switchLbale;
@end

@interface SettingNormalCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UILabel *clearLbale;
@property (nonatomic, strong) UIView *sepLine;
@end

@interface WWSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation WWSettingVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:self.tableView];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.modelArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSwitchCell"];
        if (!cell) {
            cell = [[SettingSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingSwitchCell"];
        }
        return cell;
    }else {
        NSDictionary* dict = self.modelArray[indexPath.row];
        SettingNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingNormalCell"];
        if (!cell) {
            cell = [[SettingNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingNormalCell"];
        }
        cell.iconView.image = [UIImage imageNamed:dict[@"iconImage"]];
        cell.titleNameLabel.text = dict[@"title"];;
        if (indexPath.row == self.modelArray.count-1) {
            cell.clearLbale.hidden = NO;
            cell.sepLine.hidden = YES;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
//高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*screenRate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 15*screenRate)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.nav.bottom, KWidth, KHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        [_tableView registerClass:[SettingSwitchCell class] forCellReuseIdentifier:@"SettingSwitchCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = viewBackGround_Color;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
- (NSArray *)modelArray {
    if (_modelArray == nil) {
        _modelArray = @[@{@"title":@"关于我们",@"iconImage":@"aboutus"},
                        @{@"title":@"意见反馈",@"iconImage":@"suggestion"},
                        @{@"title":@"清理缓存",@"iconImage":@"cleardelete"}];
    }
    return _modelArray;
}
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"设置";
    }
    return _nav;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


@implementation SettingNormalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBCOLOR(0x373737);
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self addSubview:self.iconView];
    [self.iconView sizeToFit];
    self.iconView.left = 20*screenRate;
    self.iconView.centerY = self.centerY;
    
    [self addSubview:self.titleNameLabel];
    [self.titleNameLabel sizeToFit];
    self.titleNameLabel.left = self.iconView.right + 10*screenRate;
    self.titleNameLabel.centerY = self.iconView.centerY;
    
    [self addSubview:self.clearLbale];
    [self.clearLbale sizeToFit];
    self.clearLbale.right = KWidth - 20*screenRate;
    self.clearLbale.centerY = self.iconView.centerY;
    
    [self addSubview:self.sepLine];
    [self.sepLine sizeToFit];
    self.sepLine.left = 20*screenRate;
    self.sepLine.bottom = self.bottom;
    self.sepLine.width = KWidth - 40*screenRate;
    self.sepLine.height = 1;
}
- (UILabel *)clearLbale {
    if (_clearLbale == nil) {
        _clearLbale = [[UILabel alloc]init];
        _clearLbale.textColor = RGBCOLOR(0x94A3AD);
        _clearLbale.text = @"2.99M";
        _clearLbale.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _clearLbale.hidden = YES;
    }
    return _clearLbale;
}
- (UILabel *)titleNameLabel {
    if (_titleNameLabel == nil) {
        _titleNameLabel = [[UILabel alloc]init];
        _titleNameLabel.textColor = RGBCOLOR(0xffffff);
        _titleNameLabel.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _titleNameLabel.text = @"被点赞的通知";
    }
    return _titleNameLabel;
}
- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"settingSwtch"];
    }
    return _iconView;
}
- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = RGBCOLOR(0x292929);
    }
    return _sepLine;
}
@end


@implementation SettingSwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBCOLOR(0x373737);
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self addSubview:self.iconView];
    [self.iconView sizeToFit];
    self.iconView.left = 20*screenRate;
    self.iconView.centerY = self.centerY;
    
    [self addSubview:self.titleNameLabel];
    [self.titleNameLabel sizeToFit];
    self.titleNameLabel.left = self.iconView.right + 10*screenRate;
    self.titleNameLabel.centerY = self.iconView.centerY;
    
    [self addSubview:self.switchLbale];
    [self.switchLbale sizeToFit];
    self.switchLbale.right = KWidth - 20*screenRate;
    self.switchLbale.centerY = self.iconView.centerY;
    self.switchLbale.width = 50*screenRate;
    self.switchLbale.height = 30*screenRate;
}
- (UISwitch *)switchLbale {
    if (_switchLbale == nil) {
        _switchLbale = [[UISwitch alloc]init];
        _switchLbale.onTintColor = RGBCOLOR(0x292929);
        _switchLbale.thumbTintColor = RGBCOLOR(0xA6B1BA);
        _switchLbale.tintColor = RGBCOLOR(0x292929);
        _switchLbale.layer.cornerRadius = 16*screenRate;
        _switchLbale.backgroundColor = RGBCOLOR(0x292929);
        _switchLbale.on = YES;
        _switchLbale.transform = CGAffineTransformScale(_switchLbale.transform, 48.0*screenRate / _switchLbale.frame.size.width, 48.0*screenRate / _switchLbale.frame.size.width);
    }
    return _switchLbale;
}
- (UILabel *)titleNameLabel {
    if (_titleNameLabel == nil) {
        _titleNameLabel = [[UILabel alloc]init];
        _titleNameLabel.textColor = RGBCOLOR(0xffffff);
        _titleNameLabel.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _titleNameLabel.text = @"被点赞的通知";
    }
    return _titleNameLabel;
}
- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"settingSwtch"];
    }
    return _iconView;
}
@end
