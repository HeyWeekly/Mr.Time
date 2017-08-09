//
//  WWLoginSettingInfoVC.m
//  Mr.Time
//
//  Created by steaest on 2017/8/8.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWLoginSettingInfoVC.h"
#import "WWLoginBirthdaySetting.h"

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
    
    [self.view addSubview:self.backheadImage];
    [self.backheadImage sizeToFit];
    self.backheadImage.centerX = self.view.centerX;
    self.backheadImage.top = self.thisNickName.bottom + 80*screenRate;
    [self.backheadImage sizeToFit];
    
    [self.view addSubview:self.settingHeadImage];
    [self drawRect];
    
    [self.view addSubview:self.sepView];
    [self.sepView sizeToFit];
    self.sepView.left = 120*screenRate;
    self.sepView.top = self.backheadImage.bottom + 68*screenRate;
    self.sepView.width = 135*screenRate;
    self.sepView.height = 2;
    
    [self.view addSubview:self.nickName];
    [self.nickName sizeToFit];
    self.nickName.centerX = self.view.centerX;
    self.nickName.width = self.sepView.width;
    self.nickName.left = self.sepView.left;
    self.nickName.top = self.backheadImage.bottom+35*screenRate;
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn sizeToFit];
    self.nextBtn.bottom = self.view.bottom - 60*screenRate;
    self.nextBtn.centerX = self.view.centerX;
}

- (void)drawRect {
    float viewWidth = 98;
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
    WWLoginBirthdaySetting *vc = [[WWLoginBirthdaySetting alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
        _settingHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(KWidth/2 - self.backheadImage.width/2 + 6, self.thisNickName.bottom+90*screenRate, 98, 98)];
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
        [_nextBtn setImage:[UIImage imageNamed:@"nextBirthday"] forState:UIControlStateNormal];
        _nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc]init];
        _sepView.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepView;
}

- (UITextField *)nickName {
    if (_nickName == nil) {
        _nickName = [[UITextField alloc]init];
        _nickName.font = [UIFont fontWithName:kFont_SemiBold size:20*screenRate];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.placeholder = @"请填写昵称";
        _nickName.textAlignment = NSTextAlignmentCenter;
        _nickName.keyboardType = UIKeyboardTypeDefault;
        _nickName.keyboardAppearance = UIKeyboardAppearanceDark;
        _nickName.returnKeyType = UIReturnKeyDone;
        _nickName.tintColor = RGBCOLOR(0x15C2FF);
    }
    return _nickName;
}
@end
