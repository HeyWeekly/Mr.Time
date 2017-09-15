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

@interface  CollectCardView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong,readwrite) YYLabel *toLabel;
@property (nonatomic, strong,readwrite) WWLabel *yearNumLabel;
@property (nonatomic, strong,readwrite) YYLabel *yearsLabel;
@property (nonatomic, strong,readwrite) YYLabel *countLabel;
@end

@interface CollectViewController ()<UICollectionViewDataSource>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) CardView *cardView;
@end

@implementation CollectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = viewBackGround_Color;
    [self setupViews];
}
- (void)setupViews {
    [self.view addSubview:self.nav];
    [self.view addSubview:self.cardView];
    NSMutableArray *arr = [self generateCardInfoWithCardCount:10];
    [self.cardView setWithCards:arr];
    [self.cardView showStyleWithStyle:1];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
        NSArray *act1 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act2 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act3 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。"];
        NSArray *act4 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act5 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"此刻正在阅读这封信的你身在何方，在做些什么？十五岁的我，怀揣着无法向任何人述说的烦恼的种子，我有话要对十五岁的你说，是否就能将一切诚实地坦露，问问自己到底自己为什么一定要向着某个目的地前行，只要不停的问终能看到答案，狂风巨浪的青春之海虽然很艰难，但是也请将梦想的小舟驶向明天的岸边。只要相信自己的声音前行就可以了，即使是已成为大人的我，也还是会受伤会有睡不着的夜晚，但是，我仍活在苦涩而又甜蜜的这一刻。最后，谢谢你。活在苦涩而又甜蜜的这。"];
        NSMutableDictionary *actHeader = @{@"flag":@"NO",@"act":act1,@"year":@"TO 21 YEARS OLD",@"count":@"3"}.mutableCopy;
        NSMutableDictionary *actHeader2 = @{@"flag":@"NO",@"act":act2,@"year":@"TO 34 YEARS OLD",@"count":@"3"}.mutableCopy;
        NSMutableDictionary *actHeader3 = @{@"flag":@"NO",@"act":act3,@"year":@"TO 25 YEARS OLD",@"count":@"1"}.mutableCopy;
        NSMutableDictionary *actHeader4 = @{@"flag":@"NO",@"act":act4,@"year":@"TO 29 YEARS OLD",@"count":@"5"}.mutableCopy;
        NSMutableDictionary *actHeader5 = @{@"flag":@"NO",@"act":act5,@"year":@"TO 33 YEARS OLD",@"count":@"2"}.mutableCopy;
        NSMutableDictionary *array = @[actHeader,actHeader2,actHeader3,actHeader4,actHeader5].mutableCopy;
        _listArray = array.mutableCopy;
    }
    return _listArray;
}

#pragma mark - tableView
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
    collView.countLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    view.frame = cell.bounds;
    collView.tag = 2000;
    [cell addSubview:collView];
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)generateCardInfoWithCardCount:(int)cardCount {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arrName = @[@"CardA"];
    for (int i=0; i<cardCount; i++) {
        int value = arc4random_uniform(1);
        [arr addObject:arrName[value]];
    }
    return arr;
}

- (CardView *)cardView {
    if (!_cardView) {
        _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-49)];
        _cardView.collectionView.dataSource = self;
        [_cardView registerCardCellWithC:[CardCell class] identifier:@"CardA"];
    }
    return _cardView;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"收藏";
    }
    return _nav;
}
@end


@implementation CollectCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.toLabel];
    [self.toLabel sizeToFit];
    self.toLabel.left = 20*screenRate;
    self.toLabel.top = 15*screenRate;
    
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
        _yearNumLabel.text = @"25";
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
        _countLabel.text = @"5";
        _countLabel.textColor = RGBCOLOR(0x15C2FF);
        _countLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    }
    return _countLabel;
}
@end
