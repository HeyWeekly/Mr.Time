//
//  WWYearsBook.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/10/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWYearsBook.h"
#import "WWBaseTableView.h"
#import "WWHomeBookModel.h"
#import "WWCollectButton.h"
#import "WWMessageDetailVCViewController.h"

@protocol WWYearsBookCellDelagate <NSObject>
- (void)yearsBookCellLikeIndex:(NSInteger)index;
@end

@interface WWYearsBookCell : UITableViewCell
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, strong) WWHomeBookModel* model;
@property (nonatomic,weak) id <WWYearsBookCellDelagate> delegate;
@end


@interface WWYearsBook ()<UITableViewDelegate,UITableViewDataSource,WWYearsBookCellDelagate>
@property (nonatomic, assign) NSInteger years;
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) WWBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray<WWHomeBookModel*> *modelArray;
@property (nonatomic, strong) NSNumber *index;
@end

@implementation WWYearsBook

- (instancetype)initWithYears:(NSInteger)years {
    if (self = [super init]) {
        self.index = @(0);
        self.years = years;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.view addSubview:self.nav];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, KWidth, KHeight- 64);
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getYearsMetto;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"age":@(self.years),@"page":weakSelf.index,@"size":@(20)};
    } onSuccess:^(id  _Nullable responseObject) {
        WWHomeJsonBookModel *model = [WWHomeJsonBookModel yy_modelWithJSON:responseObject];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([model.code isEqualToString:@"1"]) {
            if (model.result.count==0 && ![weakSelf.index isEqual:@(0)]) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf.tableView reloadData];
                return ;
            }
            if ([weakSelf.index isEqual:@0]) {
                [weakSelf.modelArray removeAllObjects];
            }
            if (!weakSelf.modelArray || [weakSelf.index isEqual:@0] || !weakSelf.modelArray.count) {
                weakSelf.modelArray = model.result;
            }else {
                [weakSelf.modelArray addObjectsFromArray:model.result];
            }
            if (weakSelf.modelArray.count == 0 && [weakSelf.index isEqual:@(0)]) {
                [weakSelf.tableView showEmptyViewWithType:1 andFrame:CGRectMake(0, 0, KWidth, KHeight)];
            }
            [weakSelf.tableView reloadData];
        }else {
            [WWHUD showMessage:@"加载失败~" inView:weakSelf.view];
        }
    } onFailure:^(NSError * _Nullable error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [WWHUD showMessage:@"服务器可能出问题了~" inView:weakSelf.view];
    } onFinished:nil];
}

- (void)setYears:(NSInteger)years {
    _years = years;
    self.nav.navTitle.text = [NSString stringWithFormat:@"%ld YEARS OLD",(long)years];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WWYearsBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWYearsBookCell"];
    if (!cell) {
        cell = [[WWYearsBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWYearsBookCell"];
    }
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.modelArray[indexPath.row].cellHeight ? self.modelArray[indexPath.row].cellHeight : 44 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWHomeBookModel *model =self.modelArray[indexPath.row];
    WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:self.years comment:model.content authAge:model.authorAge authName:model.nickname favoId:model.aid.integerValue favoCount:model.enshrined source:@"个人列表"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)yearsBookCellLikeIndex:(NSInteger)index {
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = likeMetto;
        request.parameters = @{@"apthmId":@(index)};
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
    } onFailure:^(NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"收藏失败，请稍后再试~"}];
    } onFinished:nil];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (WWBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WWBaseTableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 10*screenRate;
        _tableView.layer.masksToBounds = YES;
        WEAK_SELF;
        _tableView.mj_header = [WWRefreshHeaderView headerWithRefreshingBlock:^{
            weakSelf.index = @(0);
            [weakSelf loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSInteger tempIndex = weakSelf.index.integerValue;
            tempIndex ++;
            weakSelf.index = [NSNumber numberWithInteger:tempIndex];
            [weakSelf loadData];
        }];
    }
    return _tableView;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"25 YEARS OLD";
    }
    return _nav;
}
@end


@implementation WWYearsBookCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setModel:(WWHomeBookModel* )model {
    _model = model;
    self.messageLabel.text = model.content;
    self.messageLabel.left = 20*screenRate;
    self.messageLabel.top = 10 *screenRate;
    self.messageLabel.width = KWidth - 40*screenRate;
    [self addSubview:self.messageLabel];
    [self.messageLabel sizeToFit];
    
    self.nameLbael.text = [NSString stringWithFormat:@"——来自 %@岁 的%@",model.authorAge,model.nickname];
    [self.nameLbael sizeToFit];
    self.nameLbael.left = 20*screenRate;
    self.nameLbael.top = self.messageLabel.bottom + 12*screenRate;
    [self addSubview:self.nameLbael];
    
    self.likeNum.text = model.enshrineCnt;
    [self.likeNum sizeToFit];
    self.likeNum.right = KWidth - 20*screenRate;
    self.likeNum.top = self.nameLbael.top;
    [self addSubview:self.likeNum];
    
    [self addSubview:self.likeImage];
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left - 5*screenRate;
    self.likeImage.top = self.nameLbael.top - 8*screenRate;
    if (model.enshrined.integerValue > 0) {
        [self.likeImage setFavo:YES withAnimate:NO];
        self.islike = YES;
    }else {
        [self.likeImage setFavo:NO withAnimate:NO];
        self.islike = NO;
    }
    [self.likeImage addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sepLine sizeToFit];
    self.sepLine.left = 20 *screenRate;
    self.sepLine.top = self.nameLbael.bottom+15*screenRate;
    self.sepLine.width = KWidth - 40*screenRate;
    self.sepLine.height = 0.5;
    [self addSubview:self.sepLine];
    model.cellHeight = self.sepLine.bottom;
}

- (void)likeClick {
    self.islike = !self.islike;
    if (self.islike) {
        [self.likeImage setFavo:YES withAnimate:YES];
        self.likeNum.text = [NSString stringWithFormat:@"%ld",self.likeNum.text.integerValue+1];
    }else {
        [WWHUD showMessage:@"暂不支持取消哟~" inView:self];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(yearsBookCellLikeIndex:)]) {
        [self.delegate yearsBookCellLikeIndex:self.model.aid.integerValue];
    }
}

#pragma mark - 懒加载
- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = RGBCOLOR(0x39454E);
        _messageLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)nameLbael {
    if (_nameLbael == nil) {
        _nameLbael = [[UILabel alloc]init];
        _nameLbael.textColor = RGBCOLOR(0x94A3AE);
        _nameLbael.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _nameLbael.numberOfLines = 1;
    }
    return _nameLbael;
}

- (WWCollectButton *)likeImage {
    if (!_likeImage) {
        _likeImage = [[WWCollectButton alloc] init];
        _likeImage.imageView.contentMode = UIViewContentModeCenter;
        _likeImage.favoType = 2;
    }
    return _likeImage;
}

- (UILabel *)likeNum {
    if (_likeNum == nil) {
        _likeNum = [[UILabel alloc]init];
        _likeNum.textColor = RGBCOLOR(0x94A3AD);
        _likeNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
    }
    return _likeNum;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = RGBCOLOR(0xC9D4DD);
    }
    return _sepLine;
}

@end
