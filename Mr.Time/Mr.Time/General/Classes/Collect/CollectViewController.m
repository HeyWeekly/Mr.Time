//
//  CollectViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "CollectViewController.h"
#import <YYText/YYText.h>
#import "Mr_Time-Swift.h"
#import "WWLabel.h"
#import "WWCollectionModel.h"
#import "WWMessageDetailVCViewController.h"

@interface  CollectCardViewCell : UITableViewCell
@property (nonatomic, strong) WWCollectionModel *model;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *fifLine;
@end

@protocol CollectCardViewDelagate <NSObject>
- (void)didSelectMetto:(NSInteger)age comment:(NSString *)comment authAge:(NSString *)authAge authName:(NSString *)authName;
@end

@interface  CollectCardView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong,readwrite) YYLabel *toLabel;
@property (nonatomic, copy) NSString *yearNum;
@property (nonatomic, strong,readwrite) WWLabel *yearNumLabel;
@property (nonatomic, strong,readwrite) YYLabel *yearsLabel;
@property (nonatomic, strong,readwrite) YYLabel *countLabel;
@property (nonatomic, strong) NSArray<WWCollectionModel*> *modelArray;
@property (nonatomic,weak) id <CollectCardViewDelagate> delegate;
@end

@interface CollectViewController ()<UICollectionViewDataSource,CollectCardViewDelagate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) CardView *cardView;
@property (nonatomic, strong) NSMutableArray <WWCollectionModel *> *modelArray;
@property (nonatomic, strong) NSMutableArray *dateMutablearray;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) UIImageView *noContentView;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = viewBackGround_Color;
    self.dateMutablearray = [NSMutableArray array];
    self.index = @(0);
    [self.view addSubview:self.noContentView];
    [self.noContentView sizeToFit];
    self.noContentView.centerX_sd = self.view.centerX_sd;
    self.noContentView.centerY_sd = self.view.centerY_sd;
    [self.view addSubview:self.cardView];
    [self.cardView.collectionView.mj_header beginRefreshing];
}

- (void)loadData {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = LikeMettoList;
        request.httpMethod = kXMHTTPMethodGET;
        WWUserModel *model =  [WWUserModel shareUserModel];
        model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
        request.parameters = @{@"page":@(0),@"size":@(2000)};
    } onSuccess:^(id  _Nullable responseObject) {
        WWCollectionJsonModel *model = [WWCollectionJsonModel yy_modelWithJSON:responseObject];
        if ([model.code isEqualToString:@"1"]) {
            [self.cardView.collectionView.mj_header endRefreshing];
            if (model.result.count==0) {
                self.noContentView.hidden = NO;
                return ;
            }
            self.noContentView.hidden = YES;;
            [weakSelf.modelArray removeAllObjects];
            [weakSelf.dateMutablearray removeAllObjects];
            weakSelf.modelArray = model.result;
            [weakSelf setupViews];
        }else {
            [WWHUD showMessage:@"加载失败~" inView:self.view];
        }
    } onFailure:^(NSError * _Nullable error) {
        [weakSelf.cardView.collectionView.mj_header endRefreshing];
        [WWHUD showMessage:@"服务器可能出问题了~" inView:self.view];
    } onFinished:nil];
}

- (void)setupViews {
    NSMutableArray *arr = [self generateCardInfoWithCardCount:self.dateMutablearray.count];
    [self.cardView setWithCards:arr];
    [self.cardView showStyleWithStyle:1];
}

#pragma mark - collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardView.filterArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cardView.filterArr[indexPath.row] forIndexPath:indexPath];
    UIView *view = [cell viewWithTag:2000];
    [view removeFromSuperview];
    cell.collectionV = collectionView;
    cell.reloadBlock = ^{
        if ([collectionView.collectionViewLayout isKindOfClass:[CustomCardLayout class]]) {
            CustomCardLayout *layout = (CustomCardLayout *)collectionView.collectionViewLayout;
            layout.selectIdx = indexPath.row;
        }
    };
    cell.backgroundColor = [UIColor whiteColor];
    CollectCardView *collView = [[CollectCardView alloc]init];
    collView.frame = cell.bounds;
    collView.delegate = self;
    NSArray <WWCollectionModel *>*model = self.dateMutablearray[indexPath.row];
    collView.countLabel.text = [NSString stringWithFormat:@"%ld",model.count];
    collView.yearNum = model[0].age;
    collView.tag = 2000;
    [cell addSubview:collView];
    collView.modelArray = model;
    return cell;
}

- (void)didSelectMetto:(NSInteger)age comment:(NSString *)comment authAge:(NSString *)authAge authName:(NSString *)authName {
    WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:age comment:comment authAge:authAge authName:authName favoId:222 favoCount:@"-222" source:@"收藏列表"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (CardView *)cardView {
    if (!_cardView) {
        _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 30, KWidth, KHeight-30-49)];
        _cardView.collectionView.dataSource = self;
        WEAK_SELF;
        _cardView.collectionView.mj_header = [WWRefreshHeaderView headerWithRefreshingBlock:^{
            weakSelf.index = @(0);
            [weakSelf loadData];
        }];
        [_cardView registerCardCellWithC:[CardCell class] identifier:@"CardA"];
    }
    return _cardView;
}

- (UIImageView *)noContentView {
    if (_noContentView == nil) {
        _noContentView = [[UIImageView alloc]init];
        _noContentView.image = [UIImage imageNamed:@"collNoData"];
        _noContentView.contentMode = UIViewContentModeScaleAspectFit;
        _noContentView.clipsToBounds = YES;
        _noContentView.hidden = YES;
    }
    return _noContentView;
}

- (NSMutableArray *)dateMutablearray {
    if (_dateMutablearray == nil) {
        _dateMutablearray = [NSMutableArray array];
    }
    return _dateMutablearray;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"收藏";
    }
    return _nav;
}

#pragma mark - 排序算法
- (void)setModelArray:(NSMutableArray<WWCollectionModel *> *)modelArray {
    _modelArray = modelArray;
    NSMutableArray *array = [NSMutableArray arrayWithArray:modelArray.mutableCopy];
    for (int i = 0; i < array.count; i ++) {
        WWCollectionModel *model = array[i];
        NSString *string = model.age;
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model];
        for (int j = i+1; j < array.count; j ++) {
            WWCollectionModel *model = array[j];
            NSString *jstring = model.age;
            if([string isEqualToString:jstring]){
                [tempArray addObject:model];
                [array removeObjectAtIndex:j];
                j = j -1;
            }
        }
        [self.dateMutablearray addObject:tempArray];
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.dateMutablearray];
    [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSArray<WWCollectionModel *>  *model1 = (NSArray<WWCollectionModel *> *)obj1;
        NSArray<WWCollectionModel *>  *model2 = (NSArray<WWCollectionModel *> *)obj2;
        if (model1[0].age.integerValue < model2[0].age.integerValue) {
            return NSOrderedAscending;
        } else if (model1[0].age.integerValue > model2[0].age.integerValue) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    self.dateMutablearray = arrM;
}

- (NSMutableArray *)generateCardInfoWithCardCount:(int)cardCount {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arrName = @[@"CardA"];
    for (int i=0; i<cardCount; i++) {
        int value = arc4random_uniform(1);
        [arr addObject:arrName[value]];
    }
    return arr;
}
@end


@implementation CollectCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setYearNum:(NSString *)yearNum {
    _yearNum = yearNum;
    [self addSubview:self.toLabel];
    [self.toLabel sizeToFit];
    self.toLabel.left = 20*screenRate;
    self.toLabel.top = 15*screenRate;
    
    self.yearNumLabel.text = yearNum;
    [self addSubview:self.yearNumLabel];
    [self.yearNumLabel sizeToFit];
    self.yearNumLabel.left = self.toLabel.right+3;
    self.yearNumLabel.top = 15*screenRate;
    
    [self addSubview:self.yearsLabel];
    [self.yearsLabel sizeToFit];
    self.yearsLabel.left = self.yearNumLabel.right+3;
    self.yearsLabel.top = 15*screenRate;
    
    [self addSubview:self.countLabel];
    [self.countLabel sizeToFit];
    self.countLabel.right = KWidth - 20*screenRate;
    self.countLabel.top = 15*screenRate;
    
    [self addSubview:self.sepLine];
    self.sepLine.frame = CGRectMake(20*screenRate, self.yearNumLabel.bottom_sd + 20*screenRate, KWidth - 40*screenRate, 1);
    
    [self addSubview:self.tableView];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCardViewCell"];
    if (!cell) {
        cell = [[CollectCardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollectCardViewCell"];
    }
    cell.model = self.modelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.modelArray[indexPath.row].cellHeight ? self.modelArray[indexPath.row].cellHeight : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWCollectionModel *model = self.modelArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectMetto:comment:authAge:authName:)]) {
        [self.delegate didSelectMetto:model.age.integerValue comment:model.content authAge:model.authorAge authName:model.nickname];
    }
}

#pragma mark - 懒加载
- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = RGBCOLOR(0xC9D4DD);
    }
    return _sepLine;
}

- (YYLabel *)toLabel {
    if (_toLabel == nil) {
        _toLabel = [[YYLabel alloc]init];
        _toLabel.text = @"TO";
        _toLabel.textColor = RGBCOLOR(0x50616E);
        _toLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    }
    return _toLabel;
}

- (WWLabel *)yearNumLabel {
    if (_yearNumLabel == nil) {
        _yearNumLabel = [[WWLabel alloc]init];
        _yearNumLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)RGBCOLOR(0x2EFFB6).CGColor];
        _yearNumLabel.colors =gradientColors;
    }
    return _yearNumLabel;
}

- (YYLabel *)yearsLabel {
    if (_yearsLabel == nil) {
        _yearsLabel = [[YYLabel alloc]init];
        _yearsLabel.textColor = RGBCOLOR(0x50616E);
        _yearsLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _yearsLabel.text = @"YEARS OLD";
    }
    return _yearsLabel;
}

- (YYLabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[YYLabel alloc]init];
        _countLabel.text = @"99";
        _countLabel.textColor = RGBCOLOR(0x15C2FF);
        _countLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    }
    return _countLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sepLine.bottom_sd+1, KWidth, 400*screenRate)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}
@end


@implementation CollectCardViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setModel:(WWCollectionModel *)model {
    _model = model;
    
    self.contentLabel.text = model.content;
    [self addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];
    self.contentLabel.left_sd = 20*screenRate;
    self.contentLabel.width = KWidth - 40*screenRate;
    self.contentLabel.top = 15*screenRate;
    [self.contentLabel sizeToFit];
    
    [self addSubview:self.fifLine];
    self.fifLine.frame =CGRectMake(20*screenRate, self.contentLabel.bottom_sd+15*screenRate, KWidth-40*screenRate, 1);
    
    _model.cellHeight = self.fifLine.bottom_sd;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _contentLabel.textColor =RGBCOLOR(0x39454E);
        _contentLabel.numberOfLines = 0;
//        _contentLabel.adjustsFontSizeToFitWidth = true;
    }
    return _contentLabel;
}

- (UIView *)fifLine {
    if (_fifLine == nil) {
        _fifLine = [[UIView alloc]init];
        _fifLine.backgroundColor = RGBCOLOR(0xC9D4DD);
    }
    return _fifLine;
}
@end
