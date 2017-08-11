//
//  UIView+WWExt.h
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WWExt)

@property (nonatomic, getter=isVisible) BOOL visible;

- (UITapGestureRecognizer *)addTapGestureRecognizer:(SEL)action;

- (UITapGestureRecognizer *)addTapGestureRecognizer:(SEL)action target:(id)target;

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizer:(SEL)action duration:(CGFloat)duration;

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizer:(SEL)action target:(id)target duration:(CGFloat)duration;

- (void)removeAllSubviews;

@end
