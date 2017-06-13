//
//  WWCardSlide.h
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWCardSlideDelegate <NSObject>
@optional
//滚动代理方法
-(void)WWCardSlideDidSelectedAt:(NSInteger)index;
- (void)cellWWCardSlideDidSelected;
@end

@interface WWCardSlide : UIView
//当前选中位置
@property (nonatomic ,assign, readwrite) NSInteger selectedIndex;
//设置数据源
@property (nonatomic, strong) NSArray *models;
//代理
@property (nonatomic, weak) id<WWCardSlideDelegate>delegate;
//手动滚动到某个卡片位置
- (void)slideToIndex:(NSInteger)index animated:(BOOL)animated;
@end
