//
//  WWCollectButton.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCollectButton.h"
#import "WWCollectBtnCircleView.h"

@implementation WWCollectButton
- (instancetype)init{
    if (self = [super init]) {
        self.clipsToBounds = NO;
        [self setupSubviews];
    }
    return self;
}

- (void)setFavo:(BOOL)favo withAnimate:(BOOL)animate{
    if (favo) {
        if (self.favoImg.alpha == 1 && self.unfavoImg.alpha == 0.0) {
            return;
        }
    }
    if (!favo) {
        if (self.favoImg.alpha == 0 && self.unfavoImg.alpha == 1.0) {
            return;
        }
    }
    if (!animate) {
        if (favo) {
            self.favoImg.alpha = 1.0;
            self.unfavoImg.alpha = 0.0;
        }else{
            self.favoImg.alpha = 0.0;
            self.unfavoImg.alpha = 1.0;
        }
    }else{
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.imgContainer.transform = CGAffineTransformMakeScale(0.6, 0.6);
            if (favo) {
                self.favoImg.alpha = 1.0;
                self.unfavoImg.alpha = 0.0;
            }else{
                self.favoImg.alpha = 0.0;
                self.unfavoImg.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.imgContainer.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.imgContainer.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            if (favo) {
                CGFloat pointH = 2.5*screenRate;
                UIView* point1 = [WWCollectBtnCircleView new];
                point1.frame = CGRectMake((self.frame.size.width - pointH)/2.0, (self.frame.size.height - pointH)/2.0, 2.5*1.5, 2.5*1.5);
                UIView* point2 = [WWCollectBtnCircleView new];
                point2.frame = CGRectMake((self.frame.size.width - pointH)/2.0, (self.frame.size.height - pointH)/2.0, 2.5*1.7, 2.5*1.7);
                UIView* point3 = [WWCollectBtnCircleView new];
                point3.frame = CGRectMake((self.frame.size.width - pointH)/2.0, (self.frame.size.height - pointH)/2.0, 2.5*1.3, 2.5*1.3);
                UIView* point4 = [WWCollectBtnCircleView new];
                point4.frame = CGRectMake((self.frame.size.width - pointH)/2.0, (self.frame.size.height - pointH)/2.0, 2.5*1.0, 2.5*1.0);
                UIView* point5 = [WWCollectBtnCircleView new];
                point5.frame = CGRectMake((self.frame.size.width - pointH)/2.0, (self.frame.size.height - pointH)/2.0, 2.5*2.2, 2.5*2.2);
                point1.layer.cornerRadius = point1.frame.size.width / 2.0;
                point1.clipsToBounds = YES;
                point2.layer.cornerRadius = point2.frame.size.width / 2.0;
                point2.clipsToBounds = YES;
                point3.layer.cornerRadius = point3.frame.size.width / 2.0;
                point3.clipsToBounds = YES;
                point4.layer.cornerRadius = point4.frame.size.width / 2.0;
                point4.clipsToBounds = YES;
                point5.layer.cornerRadius = point5.frame.size.width / 2.0;
                point5.clipsToBounds = YES;
                [self addSubview:point1];
                [self addSubview:point2];
                [self addSubview:point3];
                [self addSubview:point4];
                [self addSubview:point5];
                //                CGFloat scaleRate = 1.0;
                CGFloat duration = 0.18;
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    // 左下
                    point1.frame = CGRectOffset(point1.frame, -self.favoImg.frame.size.width/2.0 + 0*screenRate, self.favoImg.frame.size.height/2.0 - 0*screenRate);
                    // 右下
                    point2.frame = CGRectOffset(point2.frame, self.favoImg.frame.size.width/2.0 + 1*screenRate, self.favoImg.frame.size.height/2.0 - 3*screenRate);
                    // 左上
                    point3.frame = CGRectOffset(point3.frame, -self.favoImg.frame.size.width/2.0 - 1.5*screenRate, -self.favoImg.frame.size.height/2.0 - 1.5*screenRate);
                    // 右上偏小2
                    point4.frame = CGRectOffset(point4.frame, self.favoImg.frame.size.width/2.0 - 0*screenRate, -self.favoImg.frame.size.height/2.0 - 0*screenRate);
                    // 右上最大
                    point5.frame = CGRectOffset(point5.frame, self.favoImg.frame.size.width/2.0 + 3*screenRate , -self.favoImg.frame.size.height/2.0 + 0*screenRate);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        point1.alpha = 0.0;
                        point2.alpha = 0.0;
                        point3.alpha = 0.0;
                        point4.alpha = 0.0;
                        point5.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        [point1 removeFromSuperview];
                        [point2 removeFromSuperview];
                        [point3 removeFromSuperview];
                        [point4 removeFromSuperview];
                        [point5 removeFromSuperview];
                    }];
                });
            }
        }];
    }
}

- (void)setupSubviews{
    [self addSubview:self.imgContainer];
    [self.imgContainer addSubview:self.unfavoImg];
    [self.imgContainer addSubview:self.favoImg];
    self.imgContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.unfavoImg.translatesAutoresizingMaskIntoConstraints = NO;
    self.favoImg.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"con":self.imgContainer,@"unfavo":self.unfavoImg,@"favo":self.favoImg};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[con]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[con]-0-|" options:0 metrics:nil views:dict]];
    [self.imgContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.favoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imgContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.imgContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.favoImg attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imgContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.imgContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.unfavoImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imgContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.imgContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.unfavoImg attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imgContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)setFavoType:(NSInteger)favoType {
    _favoType = favoType;
    if (favoType == 1) {
        self.unfavoImg.image = [UIImage imageNamed:@"bookLike"];
        self.favoImg.image = [UIImage imageNamed:@"boolRedLike"];
    }else if(favoType == 2){
        self.unfavoImg.image = [UIImage imageNamed:@"userNoCollect"];
        self.favoImg.image = [UIImage imageNamed:@"userCollect"];
    }
}

- (UIImageView *)unfavoImg{
    if (_unfavoImg == nil) {
        _unfavoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeLookCellDisFavoBtn"]];
        _unfavoImg.contentMode = UIViewContentModeCenter;
        _unfavoImg.userInteractionEnabled = NO;
    }
    return _unfavoImg;
}
- (UIImageView *)favoImg{
    if (_favoImg == nil) {
        _favoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeLookCell_favoBtn"]];
        _favoImg.contentMode = UIViewContentModeCenter;
        _favoImg.userInteractionEnabled = NO;
        _favoImg.alpha = 0.0;
    }
    return _favoImg;
}
- (UIView *)imgContainer{
    if (_imgContainer == nil) {
        _imgContainer = [UIView new];
        _imgContainer.userInteractionEnabled = NO;
        _imgContainer.opaque = NO;
    }
    return _imgContainer;
}
@end
