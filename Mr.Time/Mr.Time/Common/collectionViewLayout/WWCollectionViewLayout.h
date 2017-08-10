//
//  WWCollectionViewLayout.h
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWCollectionViewLayout;

@protocol WWCollectionViewLayoutDelegate <NSObject>
- (CGSize)layout:(WWCollectionViewLayout*)layout sizeForCellAtIndexPath:(NSIndexPath*)indexPath;
@optional
- (CGSize)layout:(WWCollectionViewLayout*)layout sizeForHeaderForSection:(NSUInteger)section;
- (CGSize)layout:(WWCollectionViewLayout*)layout sizeForFooterForSection:(NSUInteger)section;
// 绝对itemSize  适用于希望横向滚动定高 或者竖向滚动定宽的情况
// 如果有多个section的时候 会多次调用来获取各个section的高度
- (CGFloat)layout:(WWCollectionViewLayout*)layout absoluteSideForSection:(NSUInteger)section;
// 首行缩进
- (CGFloat)layout:(WWCollectionViewLayout *)layout firstLinendentation:(NSUInteger)section;
// 可替代collectionview  datasource
- (NSInteger)layoutNumberOfSection:(WWCollectionViewLayout *)layout;
- (NSInteger)layout:(WWCollectionViewLayout *)layout numberOfItemsForSection:(NSInteger)section;
@end

@interface WWCollectionViewLayout : UICollectionViewLayout
///item之间的间距
@property (nonatomic, assign) CGFloat InteritemSpacing;
///行间距
@property (nonatomic, assign) CGFloat LineSpacing;
///组间距
@property (nonatomic, assign) CGFloat sectionSpacing;
///整个collectionView的contentSize的上左下右
@property (nonatomic, assign) UIEdgeInsets sectionInset;
///排布方向
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
///当内容很少时的滚动效果
@property (nonatomic, assign) BOOL bounces;
// 用于section 到collectionView边缘的时候换行，这里的思路跟其他的不一样，滚动方向和排布方向逻辑是跟其他的有区别的，没有看明白源码慎用,如果想要加header和footer慎用  如果打开该属性 则建议实现absoluteSideForSection的代理
// 换行
@property (nonatomic, assign) BOOL lineBreak;
// 这个size 可以替代collectionView的size
@property (nonatomic, strong) NSValue* expectSize;
// 在换行的开启的情况下开启这个属性 可以使所有的item按照滚动方向居中
@property (nonatomic, assign) BOOL alignCenter;
// 同样是在换行的情况下开启 可以按照滚动方向的另外一个方向居中
@property (nonatomic, assign) BOOL verticleAlignCenter;
@property (nonatomic, weak) id <WWCollectionViewLayoutDelegate> delegate;
@end
