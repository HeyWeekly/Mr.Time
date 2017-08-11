//
//  UIView+WWExt.m
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "UIView+WWExt.h"

@implementation UIView (WWExt)

#pragma mark -

- (UITapGestureRecognizer *)addTapGestureRecognizer:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:tap];
    
    return tap;
}

- (UITapGestureRecognizer *)addTapGestureRecognizer:(SEL)action target:(id)target {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:tap];
    
    return tap;
}

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizer:(SEL)action duration:(CGFloat)duration {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:action];
    longPress.minimumPressDuration = duration;
    [self addGestureRecognizer:longPress];
    
    return longPress;
}

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizer:(SEL)action target:(id)target duration:(CGFloat)duration {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    longPress.minimumPressDuration = duration;
    [self addGestureRecognizer:longPress];
    
    return longPress;
}

- (void)showRoundingCornersWithRadiusAt:(CGFloat)radius topLeft:(BOOL)topLeft topRight:(BOOL)topRight bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight {
    if (topLeft && topRight && bottomLeft && bottomRight) {
        self.layer.cornerRadius = radius;
        return;
    }
    UIRectCorner corners = 0;
    if (topLeft)
        corners |= UIRectCornerTopLeft;
    if (topRight)
        corners |= UIRectCornerTopRight;
    if (bottomLeft)
        corners |= UIRectCornerBottomLeft;
    if (bottomRight)
        corners |= UIRectCornerBottomRight;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (BOOL)isVisible {
    return !self.hidden;
}

- (void)setVisible:(BOOL)visible {
    self.hidden = !visible;
}
@end
