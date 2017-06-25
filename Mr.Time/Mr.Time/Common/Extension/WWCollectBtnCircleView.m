//
//  WWCollectBtnCircleView.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCollectBtnCircleView.h"

@implementation WWCollectBtnCircleView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddArc(ref, self.frame.size.width /2.0, self.frame.size.height/2.0, self.frame.size.width / 2.0, 0, M_PI * 2.0, 0);
    CGContextClosePath(ref);
    CGContextSetFillColorWithColor(ref, RGBCOLOR(0xFF6175).CGColor);
    CGContextFillPath(ref);
}
@end
