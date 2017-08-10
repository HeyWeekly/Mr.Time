//
//  WWAutomaticRotation.h
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWRotationPageControl.h"

@class WWAutomaticRotation;

@protocol WWAutomaticRotationDelegate <NSObject>
- (void)carouselView:(WWAutomaticRotation*)carouselView didClickWithModel:(id)model;
/// 自定义cell
- (UICollectionViewCell*)carouselView:(WWAutomaticRotation*)carouselView collection:(UICollectionView*)collection customCellForIndex:(NSUInteger)index forIndexPath:(NSIndexPath*)indexPath;
@end

@interface WWAutomaticRotation : UIView
/// 用来regist自定义cell
@property (nonatomic, strong, readonly) UICollectionView* collection;
@property (nonatomic, strong, readonly) WWRotationPageControl* pageControl;
///page约束
@property (nonatomic,strong) NSLayoutConstraint *pageCon;
/// 翻页大小 默认为屏幕宽度 (cell的宽 不包括itemIntervel)
@property (nonatomic, assign) CGFloat pageWidth;
/// 数据源 读取count使用
@property (nonatomic, strong) NSArray<id>* modelArray;
/// 如果要自动轮播 打开这个键值 否则无动画
@property (nonatomic, assign) BOOL needAnimation;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign) float expectWidth;
/// 点击或自定义cell代理
@property (nonatomic, weak) id <WWAutomaticRotationDelegate> delegate;

/// 必须要在控制器 viewdidlayoutsubviews 中调用，否则不会自动初始化
- (void)initialOffset;
- (void)pageControlHidden:(BOOL)hidden;
- (void)updateCurrentIndex:(NSInteger)currentIndex;
/// 如果模型为XER_CarouselModel 类型 那么传入 否则传nil
/// itemIntervel 是每一个cell的距离
- (instancetype)initWithModelArray:(NSArray<id>*)modelArray itemIntervel:(CGFloat)itemIntervel;
@end
