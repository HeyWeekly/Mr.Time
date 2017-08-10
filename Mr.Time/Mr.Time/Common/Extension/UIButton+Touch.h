//
//  UIButton+Touch.h
//  YaoKe
//
//  Created by steaest on 2017/7/27.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Touch)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**用于设置单个按钮不需要被hook*/
@property (nonatomic, assign) BOOL isIgnore;
@end
