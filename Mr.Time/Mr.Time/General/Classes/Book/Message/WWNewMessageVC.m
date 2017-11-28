//
//  WWNewMessageVC.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/11/22.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWNewMessageVC.h"
#import "WWBaseTableView.h"
#import "WWMessageModel.h"
#import "WWCollectButton.h"
#import "WWMessageDetailVCViewController.h"
#import "WWMessageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WWNewMessCell : UITableViewCell
@property (nonatomic, strong) WWMessageDetailModel *model;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) UIImageView *headImage;
@end

@interface WWNewMessageVC ()<UITableViewDelegate,UITableViewDataSource,WWMessageViewDelegate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) WWBaseTableView *tableView;
@property (nonatomic, strong) WWMessageView *tabbarView;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) NSInteger mettoId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *personInfo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *favCount;
@property (nonatomic, copy) NSString *years;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *personInfoLabel;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray<WWMessageDetailModel*> *messageModelArray;
@property (nonatomic, strong) NSMutableArray <WWHotMessageDetailModel *> *hotMessageModelArray;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) UIView *sepLine;
@end

@implementation WWNewMessageVC

- (instancetype)initWithMettoId:(NSInteger)mettoId withContent:(NSString *)content withPersonInfo:(NSString *)personInfo withName:(NSString *)name withFavCount:(NSString *)favCount withYear:(NSString *)years{
    if (self = [super init]) {
        self.index = @(0);
        self.mettoId = mettoId;
        self.content = content;
        self.personInfo = personInfo;
        self.name = name;
        self.favCount = favCount;
        self.years = years;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.view addSubview:self.nav];
    self.contentLabel.text = self.content;
    self.personInfoLabel.text = [NSString stringWithFormat:@"——来自 %@岁 的%@",self.personInfo,self.name];
    self.likeNum.text = self.favCount;
    
    [self.view addSubview:self.containerView];
    self.containerView.top = self.nav.bottom+15*screenRate;
    self.containerView.width = KWidth;
    
    
    [self.contentLabel sizeToFit];
    self.contentLabel.left = 20*screenRate;
    self.contentLabel.top = self.nav.bottom+30*screenRate;
    self.contentLabel.width = KWidth-40*screenRate;
    [self.view addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];
    
    [self.personInfoLabel sizeToFit];
    self.personInfoLabel.left = 20*screenRate;
    self.personInfoLabel.top = self.contentLabel.bottom + 12*screenRate;
    [self.view addSubview:self.personInfoLabel];
    
    [self.likeNum sizeToFit];
    self.likeNum.right = KWidth - 20*screenRate;
    self.likeNum.top = self.personInfoLabel.top;
    [self.view addSubview:self.likeNum];
    
    [self.view addSubview:self.likeImage];
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left - 5*screenRate;
    self.likeImage.top = self.personInfoLabel.top - 8*screenRate;
    if (self.favCount.integerValue > 0) {
        [self.likeImage setFavo:YES withAnimate:NO];
    }else {
        [self.likeImage setFavo:NO withAnimate:NO];
    }
    
    [self.view addSubview:self.sepLine];
    self.sepLine.frame = CGRectMake(20*screenRate, self.personInfoLabel.bottom+20*screenRate, KWidth-40*screenRate, 1);
    self.containerView.height = self.sepLine.bottom;
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, self.sepLine.bottom+20*screenRate, KWidth, KHeight - (self.sepLine.bottom+20*screenRate)-50);
    [self.tableView.mj_header beginRefreshing];
    
    [self.view addSubview:self.tabbarView];
    self.tabbarView.frame = CGRectMake(0, self.tableView.bottom, KWidth, 50);
}

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
                [weakSelf.tableView removeEmptyView];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WWNewMessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWNewMessCell"];
    if (!cell) {
        cell = [[WWNewMessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWNewMessCell"];
    }
    cell.model = self.messageModelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messageModelArray[indexPath.row].cellHeight ? self.messageModelArray[indexPath.row].cellHeight : 44 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWMessageDetailModel *model =self.messageModelArray[indexPath.row];
        WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:model.age.integerValue comment:model.content authAge:model.age authName:model.nickname favoId:model.cid.integerValue favoCount:model.favourCnt source:@"留言列表"];
        [self.navigationController pushViewController:vc animated:YES];
}

//文本消息
- (void)sendDiscuss{
    WEAK_SELF;
    if (self.tabbarView.inputView.text == nil) {
        return;
    }
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = postComment;
        request.parameters = @{@"cmt": self.tabbarView.inputView.text,@"apthmId":@(self.mettoId)};
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
        weakSelf.index = @(0);
        [weakSelf loadHotMessage];
    } onFailure:^(NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"发布失败，请重试！"}];
    } onFinished:nil];
    self.tabbarView.inputView.text = nil;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - cell 出现动画
- (void)keyBoardChange:(NSNotification*)notify{
    NSValue* keyBoardFrameVal = notify.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyBoardFrame;
    [keyBoardFrameVal getValue:(&keyBoardFrame)];
    CGFloat bottom = keyBoardFrame.origin.y - [UIScreen mainScreen].bounds.size.height;
    self.bottom = bottom;
    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
        [UIView setAnimationCurve:7];
        self.tabbarView.frame = (bottom >= 0 ? CGRectMake(0, self.tableView.bottom, KWidth, 50) : CGRectMake(0, KHeight-(-bottom)-50, KWidth, 50));
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark -懒加载
- (WWBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WWBaseTableView alloc] initWithFrame:CGRectMake(0, self.sepLine.bottom+20*screenRate, KWidth, KHeight - (self.sepLine.bottom+20*screenRate))];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.noContentColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = RGBCOLOR(0x39454E);
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (WWMessageView *)tabbarView{
    if (_tabbarView == nil) {
        _tabbarView = [[WWMessageView alloc] init];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        _tabbarView.delegate = self;
    }
    return _tabbarView;
}

- (UILabel *)personInfoLabel {
    if (_personInfoLabel == nil) {
        _personInfoLabel = [[UILabel alloc]init];
        _personInfoLabel.textColor = RGBCOLOR(0x94A3AE);
        _personInfoLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _personInfoLabel.numberOfLines = 1;
    }
    return _personInfoLabel;
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

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.layer.cornerRadius = 10*screenRate;
        _containerView.clipsToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return  _containerView;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = [NSString stringWithFormat:@"TO %@ YEARS OLD",self.years];
    }
    return _nav;
}
@end

@implementation WWNewMessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setModel:(WWMessageDetailModel *)model {
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    [self.headImage sizeToFit];
    self.headImage.left = 20*screenRate;
    self.headImage.top = 20*screenRate;
    self.headImage.width = 30*screenRate;
    self.headImage.height = 30*screenRate;
    [self addSubview:self.headImage];
    
    self.messageLabel.text = model.content;
    [self.messageLabel sizeToFit];
    self.messageLabel.left = self.headImage.right+20*screenRate;
    self.messageLabel.top = 20*screenRate;
    self.messageLabel.width = KWidth-40*screenRate - self.headImage.right;
    [self.messageLabel sizeToFit];
    [self addSubview:self.messageLabel];
    
    self.nameLbael.text = self.nameLbael.text = [NSString stringWithFormat:@"——来自 %@岁 的%@",model.age,model.nickname];
    [self.nameLbael sizeToFit];
    self.nameLbael.left = self.messageLabel.left;
    self.nameLbael.top = self.messageLabel.bottom+10*screenRate;
    [self addSubview:self.nameLbael];
    model.cellHeight = self.nameLbael.bottom+20*screenRate;
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

- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc]init];
        _headImage.backgroundColor = [UIColor lightGrayColor];
        _headImage.layer.cornerRadius = 15*screenRate;
        _headImage.clipsToBounds = YES;
    }
    return _headImage;
}
@end
