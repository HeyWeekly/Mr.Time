//
//  WWAutomaticRotation.m
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAutomaticRotation.h"
#import "WWCollectionViewLayout.h"
#import "WWRotationCell.h"

#define kCell_scrollImage @"kCell_scrollImage"
#define kCell_scrollPage @"kCell_scrollPage"
#define scrollCheckRate 0.2

@interface  WWAutomaticRotation ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, WWCollectionViewLayoutDelegate>
@property (nonatomic, strong) UICollectionView* collection;
@property (nonatomic, strong) WWCollectionViewLayout* flowLayout;
// 当前索引
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) WWRotationPageControl* pageControl;
@property (nonatomic, strong) NSLayoutConstraint* animateConstraint;
@property (nonatomic, assign) CGFloat alph;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UIView*  shadowView;
@property (nonatomic, strong) UIView* navView;
@property (nonatomic, assign) BOOL pageControlHidden;
@end

@implementation WWAutomaticRotation

- (instancetype)initWithModelArray:(NSArray<id>*)modelArray itemIntervel:(CGFloat)itemIntervel {
    if (self = [super init]) {
        self.expectWidth = KWidth;
        [self setSubviews];
        self.modelArray = modelArray;
        self.flowLayout.InteritemSpacing = itemIntervel;
        [self.flowLayout prepareLayout];
        [self.collection reloadData];
        self.collection.contentOffset = [self centerOffset];
        self.currentIndex = 0;
        self.clipsToBounds = YES;
        self.pageWidth = KWidth;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0 , itemIntervel / 2, 0, itemIntervel / 2);
    }
    return self;
}

- (void)pageControlHidden:(BOOL)hidden {
    _pageControlHidden = hidden;
    if (hidden) {
        self.pageControl.hidden = YES;
    }
}
- (instancetype)init {
    if (self = [super init]) {
        NSAssert(0, @"请不要使用init 请使用- (instancetype)initWithModelArray:(NSArray<XER_CarouselModel*>*)modelArray itemIntervel:(CGFloat)itemIntervel");
    }
    return self;
}

- (void)initialOffset {
    self.currentIndex = 0;
    [self.flowLayout prepareLayout];
    [self.collection reloadData];
    self.collection.contentOffset = [self centerOffset];
    [self.pageControl setCurrentIndex:self.currentIndex];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 切勿 打开  会造成频繁刷新阻碍主线程
    //    [self initialOffset];
}

- (void)setNeedAnimation:(BOOL)needAnimation {
    _needAnimation = needAnimation;
    if (!_needAnimation) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }else{
        [self addTimer];
    }
}

- (void)setPageWidth:(CGFloat)pageWidth {
    _pageWidth = pageWidth;
    _pageWidth += self.flowLayout.InteritemSpacing;
    [self.flowLayout prepareLayout];
    [self.collection reloadData];
    self.collection.contentOffset = [self centerOffset];
}

#pragma 定时器
- (void)addTimer {
    if (!_needAnimation) {
        return;
    }
    if (self.timer) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:5 target:weakSelf selector:@selector(carouseling) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma 轮播动画
- (void)carouseling {
    [self.collection setContentOffset:[self centerOffset] animated:NO];
    [self.collection setContentOffset:CGPointMake([self centerOffset].x + self.pageWidth, 0) animated:YES];
}
#pragma mark - 视图布局
- (void)setSubviews {
    self.frame = CGRectMake(0, 0, self.expectWidth, self.expectWidth);
    self.collection.frame = self.bounds;
    self.collection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.collection];
    [self addPageControl];
}
#pragma mark - 添加page
- (void)addPageControl {
    _pageControl = [[WWRotationPageControl alloc] initWithModelArray:self.modelArray];
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    _pageControl.backgroundView = view;
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    self.pageCon = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collection attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-25*screenRate];
    [self addConstraint:self.pageCon];
}

#pragma mark - dataSource
- (CGSize)layout:(WWCollectionViewLayout *)layout sizeForCellAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.pageWidth - self.flowLayout.InteritemSpacing, self.frame.size.height);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.modelArray count] == 0 || self.modelArray == nil) {
        return 0;
    }
    if ([self.modelArray count] == 1) {
        return 1;
    }
    return [self numberOfCell];
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:collection:customCellForIndex:forIndexPath:)]) {
        UICollectionViewCell* cell = [self.delegate carouselView:self collection:collectionView customCellForIndex:[self convertedIndexForIndexPath:indexPath] forIndexPath:indexPath];
        return cell;
    }
    WWRotationCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell_scrollImage forIndexPath:indexPath];
    long index = (long)[self convertedIndexForIndexPath:indexPath];
#warning 设置图片
//    [cell.imageView setImageWithURL:[self.modelArray[index] valueForKey:@"img"]  placeHolder:nil contentModel:0 expectWidth:nil expectHeight:nil Progress:nil completedBlock:nil ];
    return cell;
}

- (NSUInteger)convertedIndexForIndexPath:(NSIndexPath*)indexPath {
    NSInteger centerIndex = [self centerIndex];
    NSInteger untrueIndex = (NSInteger)(indexPath.row - centerIndex + self.currentIndex);
    while (untrueIndex > (NSInteger)(self.modelArray.count - 1)) {
        untrueIndex -= (NSInteger)(self.modelArray.count);
    }
    while (untrueIndex < 0) {
        untrueIndex += (self.modelArray.count);
    }
    return [NSNumber numberWithInteger:untrueIndex].unsignedIntegerValue;
}

- (NSUInteger)numberOfCell {
    NSUInteger cellCount = (self.frame.size.width * 5 - 1) / self.pageWidth + 1;
    if (cellCount % 2 == 0) {
        cellCount++;
    }
    return cellCount;
}

- (NSUInteger)centerIndex {
    return [self numberOfCell] / 2;
}

#pragma mark - 代理方法

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.modelArray.count == 0) {
        return;
    }
    NSInteger currentIndex = self.currentIndex;
    CGFloat offset = (self.collection.contentOffset.x - [self centerOffset].x);
    if (offset > self.pageWidth * scrollCheckRate) {
        currentIndex += floor((offset - self.pageWidth * scrollCheckRate) / self.pageWidth) + 1;
    }else if (offset < -self.pageWidth * scrollCheckRate){
        currentIndex -= floor((-offset - self.pageWidth * scrollCheckRate) / self.pageWidth) + 1;
    }else{
        return;
    }
    while (currentIndex > (NSInteger)(self.modelArray.count - 1)) {
        currentIndex -= (self.modelArray.count);
    }
    while (currentIndex < 0) {
        currentIndex += (self.modelArray.count);
    }
    self.currentIndex = currentIndex;
    [self.collection reloadData];
    [self.collection setContentOffset:[self centerOffset] animated:NO];
    [_pageControl setCurrentIndex:self.currentIndex];
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.modelArray.count == 0) {
        return;
    }
    CGFloat index = (scrollView.contentOffset.x -  [self centerOffset].x)/self.pageWidth + self.currentIndex;
    while (index > (CGFloat)(self.modelArray.count)) {
        index -= (CGFloat)(self.modelArray.count);
    }
    while (index < 0) {
        index += (self.modelArray.count);
    }
    [_pageControl setCurrentIndex:index];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

- (CGPoint)centerOffset {
    return CGPointMake(([self.flowLayout collectionViewContentSize].width - self.frame.size.width) / 2, 0);
}
- (void)updateAnimationWithOffset:(CGFloat)offset {
    if (offset > 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.collection.transform = CGAffineTransformMakeScale((offset*0.2)/self.bounds.size.width, (offset*0.2)/self.bounds.size.height);
        self.animateConstraint.constant = offset;
        [self layoutIfNeeded];
    } else if (offset == 0){
        if (!self.timer) {
            [self addTimer];
        }
        self.animateConstraint.constant = 0;
        [self layoutIfNeeded];
    }else{
        [self.timer invalidate];
        self.timer = nil;
        self.animateConstraint.constant = 0;
        [self layoutIfNeeded];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didClickWithModel:)]) {
        [self.delegate carouselView:self didClickWithModel:self.modelArray[self.currentIndex]];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    *targetContentOffset = scrollView.contentOffset;
    CGPoint offset1 = scrollView.contentOffset;
    offset1.x ++;
    offset1.y ++;
    scrollView.contentOffset = offset1;
    offset1.x --;
    offset1.y --;
    scrollView.contentOffset = offset1;
    CGFloat offset = scrollView.contentOffset.x - [self centerOffset].x;
    if (offset > self.pageWidth / 5) {
        CGPoint target = CGPointMake([self centerOffset].x + self.pageWidth * floor((offset - self.pageWidth / 5) / self.pageWidth + 1), 0);
        [scrollView setContentOffset:target animated:YES];
    }else if (offset < - self.pageWidth / 5){
        CGPoint target =  CGPointMake([self centerOffset].x - self.pageWidth * floor((-offset - self.pageWidth / 5) / self.pageWidth + 1), 0);
        [scrollView setContentOffset:target animated:YES];
    }else{
        CGPoint target =  CGPointMake([self centerOffset].x, 0);
        [scrollView setContentOffset:target animated:YES];
    }
    [self addTimer];
}

- (void)updateCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.flowLayout prepareLayout];
    [self.collection reloadData];
    [self.pageControl setCurrentIndex:_currentIndex];
}
//下标
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
}
- (void)setModelArray:(NSArray<id> *)modelArray {
    _modelArray = modelArray;
    //    if (_modelArray == nil || _modelArray.count == 0) {
    //        return;
    //    }
    if (_modelArray.count <= 1) {
        self.collection.scrollEnabled = NO;
        self.pageControl.hidden = YES;
    }else{
        self.collection.scrollEnabled = YES;
        if (!self.pageControlHidden) {
            self.pageControl.hidden = NO;
        }
    }
    self.pageControl.modelArray = modelArray;
    [self layoutIfNeeded];
    [self.flowLayout prepareLayout];
    [self.collection reloadData];
    self.collection.contentOffset = [self centerOffset];
    if (!self.timer) {
        [self addTimer];
    }
}
#pragma mark - 懒加载
///头图轮播
- (UICollectionView *)collection {
    if (_collection == nil) {
        _collection = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.flowLayout];
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = [UIColor clearColor];
        UIView* backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        _collection.backgroundView = backView;
        [_collection setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_collection registerClass:[WWRotationCell class] forCellWithReuseIdentifier:kCell_scrollImage];
        _collection.bounces = NO;
        _collection.panGestureRecognizer.maximumNumberOfTouches = 1;
        _collection.clipsToBounds = NO;
    }
    return _collection;
}

- (WWCollectionViewLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[WWCollectionViewLayout alloc] init];
        _flowLayout.InteritemSpacing = 0;
        _flowLayout.delegate = self;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}

- (UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc]init];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
    }
    return _shadowView;
}

- (UIView *)navView {
    if (_navView == nil) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor greenColor];
        _navView.alpha = 0;
    }
    return _navView;
}
@end
