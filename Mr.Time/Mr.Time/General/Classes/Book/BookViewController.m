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

@interface BookViewController ()<WWCardSlideDelegate>
@property (nonatomic, strong) WWCardSlide *cardSlide;
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) NSArray <WWHomeBookModel *> *modelArray;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSMutableArray *dateMutablearray;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    self.dateMutablearray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMettoData) name:@"postMetto" object:nil];
    self.index = @(0);
    [self.view addSubview:self.nav];
    [self.view addSubview:self.cardSlide];
    [self loadMettoData];
}

#pragma mark - delegate
- (void)cellWWCardSlideDidSelected:(NSInteger)selectIndex {
    WWMessageVC *vc = [[WWMessageVC alloc]initWithMettoId:self.modelArray[selectIndex].age.integerValue];
    vc.year = self.modelArray[selectIndex].age.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - netWork
- (void)loadMettoData {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getAllMotto;
        request.httpMethod = kXMHTTPMethodGET;
        request.parameters = @{@"page":self.index,@"size":@(500)};
    } onSuccess:^(id  _Nullable responseObject) {
        WWHomeJsonBookModel *model = [WWHomeJsonBookModel yy_modelWithJSON:responseObject];
        [self.cardSlide.collectionView.mj_header endRefreshing];
        if ([model.code isEqualToString:@"1"]) {
            [weakSelf.dateMutablearray removeAllObjects];
            weakSelf.modelArray = model.result;
            weakSelf.cardSlide.models = weakSelf.modelArray;
            _cardSlide.selectedIndex = 0;
            WWUserModel *model = [WWUserModel shareUserModel];
            model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
            for (int i = 0; i<weakSelf.modelArray.count; i++) {
                if ([weakSelf.modelArray[i].age isEqualToString:model.yearDay]) {
                    [UIView animateWithDuration:1 animations:^{
                        weakSelf.cardSlide.selectedIndex = i;
                    }];
                    break;
                }
            }
        }else {
            [WWHUD showMessage:@"加载失败~" inView:weakSelf.view];
        }
    } onFailure:^(NSError * _Nullable error) {
        [WWHUD showMessage:@"服务器可能出问题了~" inView:weakSelf.view];
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
    }];
}

#pragma mark - 排序算法
- (void)setModelArray:(NSMutableArray<WWHomeBookModel *> *)modelArray {
    _modelArray = modelArray;
    NSMutableArray<WWHomeBookModel *> *arrM = [NSMutableArray arrayWithArray:modelArray];
    [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WWHomeBookModel  *model1 = (WWHomeBookModel  *)obj1;
        WWHomeBookModel  *model2 = (WWHomeBookModel  *)obj2;
        if (model1.age.integerValue < model2.age.integerValue) {
            return NSOrderedAscending;
        } else if (model1.age.integerValue > model2.age.integerValue) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    _modelArray = arrM;
}

- (void)swapWithData:(NSMutableArray *)arrData index1:(NSUInteger)index1  index2:(NSUInteger)index2 {
    NSNumber *temp = [arrData objectAtIndex:index1];
    [arrData replaceObjectAtIndex:index1 withObject:[arrData objectAtIndex:index2]];
    [arrData replaceObjectAtIndex:index2 withObject:temp];
}

#pragma mark - 懒加载
- (WWCardSlide *)cardSlide {
    if (_cardSlide == nil) {
        _cardSlide = [[WWCardSlide alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) andModel:nil];
        //分页切换
        _cardSlide.pagingEnabled = false;
        _cardSlide.delegate = self;
    }
    return _cardSlide;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"中间";
    }
    return _nav;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
