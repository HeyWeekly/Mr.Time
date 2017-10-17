//
//  WWCardSlide.m
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCardSlide.h"
#import "WWCardSlideLayout.h"
#import "WWCardSlideCell.h"
#import "WWLabel.h"

//居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = 0.8f;
static float CardHeightScale = 0.7f;

@interface WWCardSlide ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WWCardSlideCellDelagate> {
    
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}

@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *hundrandLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *yearsView;
@property (nonatomic, strong) WWLabel *oneTipLabel;
@end

@implementation WWCardSlide

-(instancetype)initWithFrame:(CGRect)frame andModel:(NSArray <WWHomeBookModel* > *)models {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI {
    [self addCollectionView];
    [self.oneLabel sizeToFit];
    self.oneLabel.left = 25*screenRate;
    self.oneLabel.top = 25*screenRate;
    [self addSubview:self.oneLabel];
    [self.backView sizeToFit];
    self.backView.left = self.oneLabel.right + 20*screenRate;
    self.backView.top = 29*screenRate;
    self.backView.width = 265*screenRate;
    self.backView.height = 8*screenRate;
    [self addSubview:self.backView];
    [self.hundrandLabel sizeToFit];
    self.hundrandLabel.left = self.backView.right+20*screenRate;
    self.hundrandLabel.top = 25*screenRate;
    [self addSubview:self.hundrandLabel];
    [self.yearsView sizeToFit];
    self.yearsView.left = self.oneLabel.right + 20*screenRate;
    self.yearsView.top = 27*screenRate;
    self.yearsView.width = 0;
    self.yearsView.height = 12*screenRate;
    [self addSubview:self.yearsView];
    
    [self addSubview:self.oneTipLabel];
    [self.oneTipLabel sizeToFit];
    self.oneTipLabel.centerX_sd = self.centerX_sd;
    self.oneTipLabel.top = self.yearsView.bottom+15*screenRate;
}

-(void)addCollectionView {
    WWCardSlideLayout *flowLayout = [[WWCardSlideLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake([self cellWidth],self.bounds.size.height * CardHeightScale)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:[self cellMargin]];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WWCardSlideCell class] forCellWithReuseIdentifier:@"WWCardSlideCell"];
    [_collectionView setUserInteractionEnabled:YES];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
}

#pragma mark Setter
- (void)setModels:(NSArray<WWHomeBookModel *> *)models {
    _models = models;
}

#pragma mark - CollectionDelegate
//配置cell居中
-(void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    
    [self scrollToCenter];
}

-(void)scrollToCenter {
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self performDelegateMethod];
}

#pragma mark CollectionDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cellWWCardSlideDidSelected:)]) {
        [self.delegate cellWWCardSlideDidSelected:indexPath.row];
    }
    _selectedIndex = indexPath.row;
    [self scrollToCenter];
}

#pragma mark CollectionDataSource
//卡片宽度
-(CGFloat)cellWidth {
    return self.bounds.size.width * CardWidthScale;
}

//卡片间隔
-(float)cellMargin {
    return (self.bounds.size.width - [self cellWidth])/4;
}

//设置左右缩进
-(CGFloat)collectionInset {
    return self.bounds.size.width/2.0f - [self cellWidth]/2.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"WWCardSlideCell";
    WWCardSlideCell* card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    card.model = self.models[indexPath.row];
    card.delegate = self;
    return  card;
}

- (void)bookCellLikeIndex:(NSInteger)index {
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = likeMetto;
        request.parameters = @{@"apthmId":@(index)};
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
    } onFailure:^(NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"收藏失败，请稍后再试~"}];
    } onFinished:nil];
}

#pragma mark 功能方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
//    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self performDelegateMethod];
}

- (void)performDelegateMethod {
    if ([_delegate respondsToSelector:@selector(WWCardSlideDidSelectedAt:)]) {
        [_delegate WWCardSlideDidSelectedAt:_selectedIndex];
    }
    [self yearsChangeYearsOld:self.models[_selectedIndex].age.integerValue];
}

- (void)yearsChangeYearsOld:(NSInteger)years {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.yearsView.width = 265*screenRate/100*years;
        [self.yearsView sizeToFit];
        [self.yearsView layoutIfNeeded];
        if (years == 1) {
            self.oneTipLabel.hidden = NO;
        }else {
            self.oneTipLabel.hidden = YES;
        }
    } completion:nil];
}

#pragma mark - 懒加载
- (WWLabel *)oneTipLabel {
    if (_oneTipLabel == nil) {
        _oneTipLabel = [[WWLabel alloc]init];
        _oneTipLabel.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _oneTipLabel.text = @"上帝知道何时开始，何时结束，人只知道中间";
        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)RGBCOLOR(0x2EFFB6).CGColor];
        _oneTipLabel.colors =gradientColors;
        _oneTipLabel.hidden = YES;
    }
    return _oneTipLabel;
}

- (UILabel *)oneLabel {
    if (_oneLabel == nil) {
        _oneLabel = [[UILabel alloc]init];
        _oneLabel.text = @"1";
        _oneLabel.textColor = [UIColor whiteColor];
        _oneLabel.font = [UIFont fontWithName:kFont_DINAlternate size:15*screenRate];
    }
    return _oneLabel;
}

- (UILabel *)hundrandLabel {
    if (_hundrandLabel == nil) {
        _hundrandLabel = [[UILabel alloc]init];
        _hundrandLabel.text = @"100";
        _hundrandLabel.textColor = [UIColor whiteColor];
        _hundrandLabel.font = [UIFont fontWithName:kFont_DINAlternate size:15*screenRate];
    }
    return _hundrandLabel;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = RGBCOLOR(0x363333);
        _backView.layer.cornerRadius = 4*screenRate;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIView *)yearsView {
    if (_yearsView == nil) {
        _yearsView = [[UIView alloc]init];
        _yearsView.backgroundColor = RGBCOLOR(0x2EE3FF);
        _yearsView.layer.cornerRadius = 6*screenRate;
        _yearsView.layer.masksToBounds = YES;
    }
    return _yearsView;
}
@end
