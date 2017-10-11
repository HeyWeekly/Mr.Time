//
//  WWCardSlide.h
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWHomeBookModel.h"


@protocol WWCardSlideDelegate <NSObject>
@optional
-(void)WWCardSlideDidSelectedAt:(NSInteger)index;
- (void)cellWWCardSlideDidSelected:(NSInteger)selectIndex;
@end

@interface WWCardSlide : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
//当前选中位置
@property (nonatomic ,assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<WWHomeBookModel *> *models;
@property (nonatomic, weak) id<WWCardSlideDelegate>delegate;
//构造方法
-(instancetype)initWithFrame:(CGRect)frame andModel:(NSArray <WWHomeBookModel* > *)models;
@end
