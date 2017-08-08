//
//  WWLoginSettingInfoVC.m
//  Mr.Time
//
//  Created by steaest on 2017/8/8.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWLoginSettingInfoVC.h"

@interface WWLoginSettingInfoVC ()
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UIImageView *thisNickName;
@property (nonatomic, strong) UIImageView *settingHeadImage;
@property (nonatomic, strong) UITextField *nickName;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIButton *backheadImage;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation WWLoginSettingInfoVC

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
}

- (void)setupSubview {
    [self.view addSubview:self.nav];
    [self.view addSubview:self.thisNickName];
    [self.thisNickName sizeToFit];
    self.thisNickName.centerX = self.view.centerX;
    self.thisNickName.top = 85*screenRate;
    
    [self.view addSubview:self.settingHeadImage];
    [self drawRect];
    [self.view addSubview:self.backheadImage];
    [self.backheadImage sizeToFit];
    self.backheadImage.centerX = self.view.centerX;
    self.backheadImage.top = 50*screenRate;
    [self.backheadImage sizeToFit];
}

- (void)drawRect {
    float viewWidth = 55;
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [[UIColor whiteColor] setStroke];
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    [path closePath];
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.lineWidth = 2;
    shapLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapLayer.path = path.CGPath;
    _settingHeadImage.layer.mask = shapLayer;
}

#pragma mark - event
- (void)headImageClick {

}

- (void)nextClick {

}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = nil;
    }
    return _nav;
}

- (UIImageView *)thisNickName {
    if (_thisNickName == nil) {
        _thisNickName = [[UIImageView alloc]init];
        _thisNickName.image = [UIImage imageNamed:@"setingNickName"];
    }
    return _thisNickName;
}

- (UIImageView *)settingHeadImage {
    if (_settingHeadImage == nil) {
        _settingHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(137*screenRate, self.thisNickName.bottom+80*screenRate, 55, 55)];
        _settingHeadImage.image = [UIImage imageNamed:@"dasdasdas"];
        _settingHeadImage.clipsToBounds = YES;
    }
    return _settingHeadImage;
}

- (UIButton *)backheadImage {
    if (_backheadImage == nil) {
        _backheadImage = [[UIButton alloc]init];
        [_backheadImage setImage:[UIImage imageNamed:@"loginsettingheading"] forState:UIControlStateNormal];
        _backheadImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backheadImage addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backheadImage;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setImage:[UIImage imageNamed:@"loginsettingheading"] forState:UIControlStateNormal];
        _nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
@end
