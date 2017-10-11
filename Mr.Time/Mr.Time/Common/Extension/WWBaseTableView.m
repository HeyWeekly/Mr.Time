//
//  WWBaseTableView.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/15.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWBaseTableView.h"
#import "WWNoContentView.h"

@interface WWBaseTableView (){
    WWNoContentView *_noContentView;
}
@end

@implementation WWBaseTableView

- (void)showEmptyViewWithType:(NSInteger)emptyViewType andFrame:(CGRect)frame {
    if (_noContentView) {
        [_noContentView removeFromSuperview];
        _noContentView = nil;
    }
    
    _noContentView = [[WWNoContentView alloc]initWithFrame:frame];
    [self addSubview:_noContentView];
    _noContentView.type = emptyViewType;
    
    [_noContentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noContentViewDidTaped:)]];
}


- (void)removeEmptyView{
    [_noContentView removeFromSuperview];
    _noContentView = nil;
}

// 无数据占位图点击
- (void)noContentViewDidTaped:(WWNoContentView *)noContentView{
    
    if (self.noContentViewTapedBlock) {
        self.noContentViewTapedBlock();//调用回调函数
    }
}
@end
