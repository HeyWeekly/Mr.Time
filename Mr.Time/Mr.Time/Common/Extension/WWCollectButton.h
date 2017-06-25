//
//  WWCollectButton.h
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCollectButton : UIButton
@property (nonatomic, strong) UIImageView* unfavoImg;
@property (nonatomic, strong) UIImageView* favoImg;
@property (nonatomic, strong) UIView* imgContainer;
@property (nonatomic, assign) NSInteger favoType;
- (void)setFavo:(BOOL)favo withAnimate:(BOOL)animate;
@end
