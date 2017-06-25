//
//  WWShareSucceedView.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWShareSucceedView.h"

static CGFloat const kSuccessRadius = 25;

@interface WWShareSucceedView ()
@property (nonatomic) CAShapeLayer *checkMarkLayer;
@end

@implementation WWShareSucceedView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.85;
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)processSucceed {
    self.checkMarkLayer = [CAShapeLayer layer];
    self.checkMarkLayer.frame = self.bounds;
    [self.layer addSublayer:self.checkMarkLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint origenPoint = CGPointMake((self.bounds.size.width - kSuccessRadius) / 2, (self.bounds.size.height - kSuccessRadius) / 2);
    CGPoint firstPoint = CGPointMake(origenPoint.x, origenPoint.y + kSuccessRadius / 2);
    [path moveToPoint:firstPoint];
    CGPoint secondPoint = CGPointMake(origenPoint.x + kSuccessRadius / 3, origenPoint.y + kSuccessRadius * 5 / 6);
    [path addLineToPoint:secondPoint];
    CGPoint thirdPoint = CGPointMake(origenPoint.x + kSuccessRadius,origenPoint.y + kSuccessRadius / 6);
    [path addLineToPoint:thirdPoint];
    
    self.checkMarkLayer.path = path.CGPath;
    self.checkMarkLayer.lineWidth = 2.5;
    self.checkMarkLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.checkMarkLayer.fillColor = nil;
    
    // end status
    CGFloat strokeEnd = 2;
    self.checkMarkLayer.strokeEnd = strokeEnd;
    
    // animation
    CABasicAnimation *step6bAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    step6bAnimation.duration = 0.5;
    step6bAnimation.fromValue = @0;
    step6bAnimation.toValue = @(strokeEnd);
    [self.checkMarkLayer addAnimation:step6bAnimation forKey:nil];
}

@end
