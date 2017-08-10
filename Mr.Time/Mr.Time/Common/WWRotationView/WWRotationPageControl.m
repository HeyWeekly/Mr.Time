//
//  WWRotationPageControl.m
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRotationPageControl.h"
#import "WWCollectionViewLayout.h"

#define Circle @"circleCellIdenty"
#define SquareWhite @"SquareWhiteCellIdenty"
#define SquareBlack @"SquareBlackCellIdenty"

@interface WWRotationPageControlCellCircle : UICollectionViewCell
- (void)setBlackAlpha:(CGFloat)alpha;
@end


@interface WWRotationPageControlCellSquareWhite : UICollectionViewCell
- (void)setBlackAlpha:(CGFloat)alpha;
@end


@interface WWRotationPageControlCellSquareBlack : UICollectionViewCell
- (void)setBlackAlpha:(CGFloat)alpha;
@end


@interface WWRotationPageControl ()<UICollectionViewDataSource, WWCollectionViewLayoutDelegate>
@property (nonatomic, strong) WWCollectionViewLayout* flowLayout;
@property (nonatomic, strong) NSLayoutConstraint* wCon;
@property (nonatomic, strong) NSLayoutConstraint* hCon;
@property (nonatomic, assign) double currentIndexNum;
@end

@implementation WWRotationPageControl

- (instancetype)initWithModelArray:(NSArray*)modelArray {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.flowLayout]) {
        [self registerClass:[WWRotationPageControlCellCircle class] forCellWithReuseIdentifier:Circle];
        [self registerClass:[WWRotationPageControlCellSquareWhite class] forCellWithReuseIdentifier:SquareWhite];
        [self registerClass:[WWRotationPageControlCellSquareBlack class] forCellWithReuseIdentifier:SquareBlack];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.hCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:5*screenRate];
        [self addConstraint:self.hCon];
        self.wCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        [self addConstraint:self.wCon];
        self.dataSource = self;
        self.currentIndexNum = 0;
        self.modelArray = modelArray;
        self.style = 0;
    }
    return self;
}

- (void)setStyle:(WWRotationPageControlStyle)style {
    _style = style;
    [self setModelArray:_modelArray];
}

- (void)setCurrentIndex:(CGFloat)index {
    //    NSLog(@" ------ page control index change : %f",index);
    CGFloat oldIndex = index;
    self.currentIndexNum = (double)index;
    //    index+=0.01;
    NSInteger ceilIndex = ceilf(index) > self.modelArray.count - 1 ? 0 : (NSInteger)ceilf(index);
    NSInteger floorIndex = floorf(index) < 0 ? self.modelArray.count - 1 : (NSInteger)floorf(index);
    for (NSInteger i = 0; i < [self.modelArray count]; i ++) {
        if (i == floorIndex) {
            WWRotationPageControlCellCircle* cell = (WWRotationPageControlCellCircle*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if ((long)oldIndex != (long)index) {
                [cell setBlackAlpha:1];
                //                NSLog(@" ------- floor alpha : 1   (%ld)", (long)i);
            }else{
                if (ceilIndex == floorIndex) {
                    [cell setBlackAlpha:1];
                }else{
                    [cell setBlackAlpha:(ceil(index) - index)];
                }
                //                NSLog(@" ------- floor alpha : %f   (%ld)",(ceil(index) - index), (long)i);
            }
        }else if (i == ceilIndex){
            WWRotationPageControlCellCircle* cell = (WWRotationPageControlCellCircle*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if ((long)oldIndex != (long)index) {
                if (ceilIndex < floorIndex) {
                    [cell setBlackAlpha:1];
                    //                    NSLog(@" ------- ceil alpha : 1  (%ld)", (long)i);
                }else{
                    [cell setBlackAlpha:0];
                    //                    NSLog(@" ------- ceil alpha : 0  (%ld)", (long)i);
                }
            }else{
                [cell setBlackAlpha:(index - floor(index))];
                //                NSLog(@" ------- ceil alpha : %f  (%ld)",(index - floor(index)), (long)i);
            }
        }else{
            WWRotationPageControlCellCircle* cell = (WWRotationPageControlCellCircle*)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell setBlackAlpha:0];
        }
    }
    self.currentIndexNum = index;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == 0) {
        WWRotationPageControlCellCircle* cell = [collectionView dequeueReusableCellWithReuseIdentifier:Circle forIndexPath:indexPath];
        if (indexPath.item != floor(self.currentIndexNum)) {
            [cell setBlackAlpha:0];
        }else{
            [cell setBlackAlpha:1];
        }
        cell.layer.cornerRadius = 5.0/2*screenRate;
        cell.clipsToBounds = YES;
        return cell;
    }else if(self.style == 1){
        WWRotationPageControlCellSquareWhite* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SquareWhite forIndexPath:indexPath];
        if (indexPath.item != floor(self.currentIndexNum)) {
            [cell setBlackAlpha:0];
        }else{
            [cell setBlackAlpha:1];
        }
        return cell;
    }else{
        WWRotationPageControlCellSquareBlack* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SquareBlack forIndexPath:indexPath];
        if (indexPath.item != floor(self.currentIndexNum)) {
            [cell setBlackAlpha:0];
        }else{
            [cell setBlackAlpha:1];
        }
        return cell;
    }
}

- (CGSize)layout:(WWCollectionViewLayout *)layout sizeForCellAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == 0) {
        return CGSizeMake(5.0*screenRate, 5.0* screenRate);
    }else if(self.style == 1){
        return CGSizeMake(12.0*screenRate, 3.0* screenRate);
    }else{
        return CGSizeMake(10.0*screenRate, 2.0* screenRate);
    }
}
- (CGFloat)layout:(WWCollectionViewLayout *)layout absoluteSideForSection:(NSUInteger)section {
    if (self.style == 0) {
        return 5.0*screenRate;
    }else if(self.style == 1){
        return 3.0*screenRate;
    }else{
        return 2.0*screenRate;
    }
}

- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    [self.flowLayout prepareLayout];
    [self reloadData];
    UICollectionViewLayoutAttributes* attr = [self.flowLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:self.modelArray.count - 1 inSection:0]];
    self.wCon.constant = attr.frame.size.width + attr.frame.origin.x;
    if (self.superview) {
        
    }
}

- (WWCollectionViewLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[WWCollectionViewLayout alloc] init];
        _flowLayout.InteritemSpacing = 5*screenRate;
        _flowLayout.delegate = self;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end


@interface WWRotationPageControlCellCircle ()
@property (nonatomic, strong) UIView* blackView;
@end

@implementation WWRotationPageControlCellCircle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    [self addSubview:self.blackView];
    self.blackView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"view":self.blackView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
}

- (void)setBlackAlpha:(CGFloat)alpha {
    self.blackView.alpha = alpha/2 + 0.3;
}

- (UIView *)blackView {
    if (_blackView == nil) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [UIColor whiteColor];
    }
    return _blackView;
}

@end


@interface WWRotationPageControlCellSquareWhite ()
@property (nonatomic, strong) UIView* blackView;
@end

@implementation WWRotationPageControlCellSquareWhite

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    [self addSubview:self.blackView];
    self.blackView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"view":self.blackView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
}

- (void)setBlackAlpha:(CGFloat)alpha {
    self.blackView.alpha = alpha/10.0*7.0 + 0.3;
}

- (UIView *)blackView {
    if (_blackView == nil) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [UIColor whiteColor];
    }
    return _blackView;
}

@end


@interface WWRotationPageControlCellSquareBlack ()
@property (nonatomic, strong) UIView* blackView;
@end

@implementation WWRotationPageControlCellSquareBlack

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    [self addSubview:self.blackView];
    self.blackView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"view":self.blackView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:dict]];
}

- (void)setBlackAlpha:(CGFloat)alpha {
    self.blackView.alpha = alpha/10.0*6.0 + 0.2;
}

- (UIView *)blackView {
    if (_blackView == nil) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = RGBCOLOR(0x000000);
    }
    return _blackView;
}

@end
