//
//  WWRotationPageControl.h
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WWRotationPageControlStyle) {
    // 圆
    WWRotationPageControlStyleCircle = 0,
    // 方形 白色
    WWRotationPageControlStyleSquare   = 1,
    // 方形 黑色
    WWRotationPageControlStyleSquareBlack = 2
};

@interface WWRotationPageControl : UICollectionView
@property (nonatomic, assign) WWRotationPageControlStyle style;
@property (nonatomic, strong) NSArray* modelArray;
- (instancetype)initWithModelArray:(NSArray*)modelArray;

- (void)setCurrentIndex:(CGFloat)index;
@end
