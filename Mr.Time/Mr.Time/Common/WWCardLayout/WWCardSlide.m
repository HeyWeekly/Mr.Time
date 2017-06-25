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

//居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = 0.8f;
static float CardHeightScale = 0.7f;

@interface WWCardSlide ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WWCardSlideCellDelagate> {
    
    UICollectionView *_collectionView;
    
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *hundrandLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *yearsView;
@end

@implementation WWCardSlide
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = viewBackGround_Color;
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
}
- (void)yearsChangeYearsOld:(NSInteger)years {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.yearsView.width = 286/100*years;
        [self.yearsView sizeToFit];
        [self.yearsView layoutIfNeeded];
    } completion:nil];
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

#pragma mark -
#pragma mark Setter
-(void)setModels:(NSArray *)models
{
//    _models = models;
//    if (_models.count) {
//        XLCardModel *model = _models.firstObject;
//        _imageView.image = [UIImage imageNamed:model.imageName];
//    }
}

#pragma mark - CollectionDelegate

//配置cell居中
-(void)fixCellToCenter
{
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

-(void)scrollToCenter
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    XLCardModel *model = _models[_selectedIndex];
//    _imageView.image = [UIImage imageNamed:model.imageName];
    
    [self performDelegateMethod];
}

#pragma mark -
#pragma mark CollectionDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cellWWCardSlideDidSelected)]) {
        [self.delegate cellWWCardSlideDidSelected];
    }
    _selectedIndex = indexPath.row;
    [self scrollToCenter];
}

#pragma mark -
#pragma mark CollectionDataSource

//卡片宽度
-(CGFloat)cellWidth
{
    return self.bounds.size.width * CardWidthScale;
}

//卡片间隔
-(float)cellMargin
{
    return (self.bounds.size.width - [self cellWidth])/4;
}

//设置左右缩进
-(CGFloat)collectionInset
{
    return self.bounds.size.width/2.0f - [self cellWidth]/2.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"WWCardSlideCell";
    WWCardSlideCell* card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    card.model = _models[indexPath.row];
    card.delegate = self;
    return  card;
}

- (void)bookCellLike {
    
}

#pragma mark -
#pragma mark 功能方法

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self performDelegateMethod];
}

- (void)performDelegateMethod {
    if ([_delegate respondsToSelector:@selector(WWCardSlideDidSelectedAt:)]) {
        [_delegate WWCardSlideDidSelectedAt:_selectedIndex];
    }
    [self yearsChangeYearsOld:_selectedIndex*5];
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
