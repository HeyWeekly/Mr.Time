//
//  WWBaseTableView.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/15.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBaseTableView : UITableView
@property (nonatomic, copy) void (^noContentViewTapedBlock)();
- (void)showEmptyViewWithType:(NSInteger)emptyViewType andFrame:(CGRect)frame;
- (void)removeEmptyView;
@end
