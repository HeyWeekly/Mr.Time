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
@property (nonatomic, strong) NSArray<WWHomeBookModel*> *modelArray;
@end

@implementation WWYearsBook

- (instancetype)initWithYears:(NSInteger)years {
    if (self = [super init]) {
        self.years = years;
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getYearsMetto;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"age":@(self.years),@"page":@(0),@"size":@(20)};
    } onSuccess:^(id  _Nullable responseObject) {
        WWHomeJsonBookModel *model = [WWHomeJsonBookModel yy_modelWithJSON:responseObject];
        if ([model.code isEqualToString:@"1"]) {
            self.modelArray = model.result;
            if (model.result.count == 0) {
                [self.tableView showEmptyViewWithType:1];
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
#warning 提示信息
    } onFinished:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, KWidth, KHeight- 64);
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
    WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:self.years comment:model.content authAge:model.authorAge authName:model.nickname favoId:model.aid.integerValue favoCount:model.enshrineCnt source:@"个人列表"];
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
        _tableView = [[WWBaseTableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 10*screenRate;
        _tableView.layer.masksToBounds = YES;
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
    if (model.enshrineCnt.integerValue > 0) {
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
