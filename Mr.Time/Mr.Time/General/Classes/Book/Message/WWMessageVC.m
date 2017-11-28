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
#import "WWHomeBookModel.h"
#import "WWCollectButton.h"
#import "WWNewMessageVC.h"

@interface MessageHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *backImage;
@end

@protocol MessageCellDelegate <NSObject>
- (void)moreClickAid:(NSString *)aid withContnet:(NSString *)content andOpenid:(NSString *)openid;
- (void)yearsBookCellLikeIndex:(NSInteger)index;
@end

@interface MessageCell : UITableViewCell
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) WWHomeBookModel *model;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic,weak) id <MessageCellDelegate> delegate;
@property (nonatomic, assign) BOOL islike;
@end

@interface WWMessageVC ()<UITableViewDelegate,UITableViewDataSource,MessageCellDelegate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) WWBaseTableView *tableView;
@property (nonatomic, assign) NSInteger mettoId;
@property (nonatomic, strong) NSMutableArray<WWHomeBookModel*> *messageModelArray;
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
- (void)loadData {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getYearsMetto;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"age":@(self.mettoId),@"page":weakSelf.index,@"size":@(20)};
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
                [weakSelf.messageModelArray removeAllObjects];
            }
            if (!weakSelf.messageModelArray || [weakSelf.index isEqual:@0] || !weakSelf.messageModelArray.count) {
                weakSelf.messageModelArray = model.result;
            }else {
                [weakSelf.messageModelArray addObjectsFromArray:model.result];
            }
            if (weakSelf.messageModelArray.count == 0 && [weakSelf.index isEqual:@(0)]) {
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
    cell.delegate = self;
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
    WWHomeBookModel *model =self.messageModelArray[indexPath.row];
    WWNewMessageVC *vc = [[WWNewMessageVC alloc]initWithMettoId:model.aid.integerValue withContent:model.content withPersonInfo:model.authorAge withName:model.nickname withFavCount:model.enshrineCnt withYear:model.age];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreClickAid:(NSString *)aid withContnet:(NSString *)content andOpenid:(NSString *)openid{
    WWUserModel *model = [WWUserModel shareUserModel];
    model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
    NSString *text = @"举报";
    NSString *uid = model.uid;
    if ([openid isEqualToString:model.openid]) {
        text = @"删除";
    }
    if ([openid isEqualToString:@"oDPUU1JCynfSGI8bUasATxPAwo9E"] && model.openid == nil) {
        text = @"删除";
        openid = @"oDPUU1JCynfSGI8bUasATxPAwo9E";
        uid = @"life15078000081469261";
    }
    WWActionSheet *actionSheet = [[WWActionSheet alloc] initWithTitle:nil];
    WEAK_SELF;
    WWActionSheetAction *action = [WWActionSheetAction actionWithTitle:text
                                                               handler:^(WWActionSheetAction *action) {
                                                                   [weakSelf  messageId:aid content:content openid:openid andDel:[text isEqualToString:@"删除"] ? YES:NO andUid:uid];
                                                               }];
    
    WWActionSheetAction *action2 = [WWActionSheetAction actionWithTitle:@"复制"
                                                                handler:^(WWActionSheetAction *action) {
                                                                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                    pasteboard.string = content;
                                                                    [WWHUD showMessage:@"已复制" inView:weakSelf.view];
                                                                }];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    
    [actionSheet showInWindow:[WWGeneric popOverWindow]];
}

- (void)messageId:(NSString *)aid content:(NSString *)content openid:(NSString*)openid andDel:(BOOL)isDel andUid:(NSString *)uid{
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        if (isDel) {
            request.api = delMessage;
            request.parameters = @{@"cid" : aid,@"uid":uid};
        }else {
            request.api = conReport;
            request.parameters = @{@"content" : content, @"tid" : aid, @"type" : @"2"};
        }
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
        [weakSelf loadData];
        [WWHUD showMessage:@"操作成功！" inView:self.view];
    } onFailure:^(NSError * _Nullable error) {
        [WWHUD showMessage:@"操作失败，请重试~" inView:self.view];
    } onFinished:nil];
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

- (void)setModel:(WWHomeBookModel *)model {
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
    
    [self addSubview:self.moreBtn];
    [self.moreBtn sizeToFit];
    self.moreBtn.right = KWidth - 20*screenRate;
    self.moreBtn.top = self.nameLbael.top-2*screenRate;
    
    self.likeNum.text = model.enshrineCnt;
    [self.likeNum sizeToFit];
    self.likeNum.right = self.moreBtn.left - 15*screenRate;
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

- (void)moreClick {
    if ([self.delegate respondsToSelector:@selector(moreClickAid:withContnet:andOpenid:)]) {
        [self.delegate moreClickAid:self.model.aid withContnet:self.model.content andOpenid:nil];
//        [self.delegate moreClickAid:self.model.cid withContnet:self.model.content andOpenid:self.model.userOpenid];
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

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc]init];
        [_moreBtn setImage:[UIImage imageNamed:@"More"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
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
