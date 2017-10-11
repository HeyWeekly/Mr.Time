//
//  WWRefreshHeaderView.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/10/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRefreshHeaderView.h"
#import "DRFrashLayer.h"

@interface WWRefreshHeaderView ()
@property (nonatomic, strong) DRFrashLayer *frashLayer;
@end

@implementation WWRefreshHeaderView

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    self.frashLayer = [DRFrashLayer layer];
    [self.layer addSublayer:self.frashLayer];
}

- (void)dealloc {
    [self.frashLayer stopAnimation];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.frashLayer.frame = self.bounds;
    self.frashLayer.contentsScale = [UIScreen mainScreen].scale;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change  {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.frashLayer stopAnimation];
        }
            break;
        case MJRefreshStatePulling:
        {
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self.frashLayer beginAnimation];
        }
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    //这里 pullingPercent == 1.0 时 会出错 (备注已经解决)
//    self.mj_y = -self.mj_h * MIN(1.125, MAX(0.0, pullingPercent)); //动手修改一下试试
//    self.mj_y = -self.mj_h * MIN(1.0, MAX(0.0, pullingPercent));
    CGFloat complete = MIN(1.0, MAX(0.0, pullingPercent-0.125));
    self.frashLayer.complete = complete;
}
@end
