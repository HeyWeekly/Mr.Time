//
//  WWMessageVC.m
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWMessageVC.h"
#import "WWPublishVC.h"
#import "WWMessageDetailVCViewController.h"
#import "WWMessageModel.h"
#import "WWBaseTableView.h"

@interface MessageHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *backImage;
@end


@interface MessageCell : UITableViewCell
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) WWMessageDetailModel *model;
@end

@interface WWMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) WWBaseTableView *tableView;
@property (nonatomic, assign) NSInteger mettoId;
@property (nonatomic, strong) NSMutableArray <WWMessageDetailModel *> *messageModelArray;
@property (nonatomic, strong) NSMutableArray <WWHotMessageDetailModel *> *hotMessageModelArray;
@property (nonatomic, strong) NSNumber *index;
@end

@implementation WWMessageVC

- (instancetype)initWithMettoId:(NSInteger)mettoId {
    if (self = [super init]) {
        self.index = @(0);
        self.mettoId = mettoId;
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

- (void)setYear:(NSInteger)year {
    _year = year;
    self.nav.navTitle.text = [NSString stringWithFormat:@"TO %ld YEARS OLD",(long)year];
}

#pragma mark - network
- (void)loadHotMessage {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getNewMessage;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"apthmId":@(self.mettoId),@"page":weakSelf.index,@"size":@(200)};
    } onSuccess:^(id  _Nullable responseObject) {
        WWJsonMessageModel *model = [WWJsonMessageModel yy_modelWithJSON:responseObject];
        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
        if ([model.code isEqualToString:@"1"]) {
//            if (model.result.lastest_cmts==0) {
//                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                [weakSelf.tableView reloadData];
//                return ;
//            }
            if ([weakSelf.index isEqual:@0]) {
                [weakSelf.messageModelArray removeAllObjects];
                [weakSelf.hotMessageModelArray removeAllObjects];
            }
            if (!weakSelf.messageModelArray || [weakSelf.index isEqual:@0] || !weakSelf.messageModelArray.count) {
                weakSelf.messageModelArray = model.result.lastest_cmts;
                weakSelf.hotMessageModelArray = model.result.hot_cmts;
            }
//            }else {
//                [weakSelf.messageModelArray addObjectsFromArray:model.result.lastest_cmts];
//            }
            if (weakSelf.messageModelArray.count == 0) {
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

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hotMessageModelArray.count ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hotMessageModelArray.count > 0) {
        if (section == 0) {
            return self.hotMessageModelArray.count;
        } else {
            return self.messageModelArray.count;
        }
    }else {
        return self.messageModelArray.count ? self.messageModelArray.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    }
    cell.model = self.messageModelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MessageHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (self.hotMessageModelArray.count > 0) {
            if (section == 0) {
                    headView.backImage.image = [UIImage imageNamed:@"hotMessage"];
            }else {
                headView.backImage.image = [UIImage imageNamed:@"newMessage"];
            }
        return headView;
    }
    if (self.messageModelArray.count > 0) {
        headView.backImage.image = [UIImage imageNamed:@"newMessage"];
        return headView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messageModelArray[indexPath.row].cellHeight ? self.messageModelArray[indexPath.row].cellHeight : 44 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWMessageDetailModel *model =self.messageModelArray[indexPath.row];
    WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:self.year comment:model.content authAge:model.age authName:model.nickname favoId:model.cid.integerValue favoCount:model.favourCnt source:@"留言列表"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messageto {
    WWPublishVC *publishVC = [[WWPublishVC alloc]initWithYear:self.year andIsPublish:NO];
    publishVC.mettoId = self.mettoId;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (WWBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WWBaseTableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 45*screenRate;
        _tableView.layer.cornerRadius = 10*screenRate;
        _tableView.layer.masksToBounds = YES;
        [_tableView registerClass:[MessageHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        WEAK_SELF;
        _tableView.mj_header = [WWRefreshHeaderView headerWithRefreshingBlock:^{
            weakSelf.index = @(0);
            [weakSelf loadHotMessage];
        }];
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            NSInteger tempIndex = weakSelf.index.integerValue;
//            tempIndex ++;
//            weakSelf.index = [NSNumber numberWithInteger:tempIndex];
//            [weakSelf loadHotMessage];
//        }];
    }
    return _tableView;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"TO 25 YEARS OLD";
        _nav.rightBtn.hidden = NO;
        [_nav.rightBtn addTarget:self action:@selector(messageto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav;
}
@end


@implementation MessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setModel:(WWMessageDetailModel *)model {
    _model = model;
    self.messageLabel.text = model.content;
    self.messageLabel.left = 20*screenRate;
    self.messageLabel.top = 10 *screenRate;
    self.messageLabel.width = KWidth - 40*screenRate;
    [self addSubview:self.messageLabel];
    [self.messageLabel sizeToFit];
    
    self.nameLbael.text = [NSString stringWithFormat:@"——来自 %@岁 的%@",model.age,model.nickname];
    [self.nameLbael sizeToFit];
    self.nameLbael.left = 20*screenRate;
    self.nameLbael.top = self.messageLabel.bottom + 12*screenRate;
    [self addSubview:self.nameLbael];
    
    self.likeNum.text = model.favourCnt;
    [self.likeNum sizeToFit];
    self.likeNum.right = KWidth - 20*screenRate;
    self.likeNum.top = self.nameLbael.top;
    [self addSubview:self.likeNum];
    
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left - 5*screenRate;
    self.likeImage.top = self.nameLbael.top + 2*screenRate;
    [self addSubview:self.likeImage];
    
    [self.sepLine sizeToFit];
    self.sepLine.left = 20 *screenRate;
    self.sepLine.top = self.nameLbael.bottom+15*screenRate;
    self.sepLine.width = KWidth - 40*screenRate;
    self.sepLine.height = 0.5;
    [self addSubview:self.sepLine];
    model.cellHeight = self.sepLine.bottom;
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

- (UIImageView *)likeImage {
    if (_likeImage == nil) {
        _likeImage = [[UIImageView alloc]init];
        _likeImage.image = [UIImage imageNamed:@"userLike"];
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


@implementation MessageHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifie {
    if (self == [super initWithReuseIdentifier:reuseIdentifie]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    [self.backImage sizeToFit];
    self.backImage.left = 20*screenRate;
    self.backImage.top = 15*screenRate;
    self.backImage.width = 56*screenRate;
    self.backImage.height = 20*screenRate;
    [self addSubview:self.backImage];
}

- (UIImageView *)backImage {
    if (_backImage == nil) {
        _backImage = [[UIImageView alloc]init];
        _backImage.image = [UIImage imageNamed:@"newMessage"];
        _backImage.contentMode = UIViewContentModeScaleAspectFit;
        _backImage.layer.masksToBounds = YES;
    }
    return _backImage;
}
@end
