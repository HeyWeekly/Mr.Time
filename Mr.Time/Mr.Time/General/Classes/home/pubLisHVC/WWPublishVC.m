//
//  WWPublishVC.m
//  Mr.Time
//
//  Created by steaest on 2017/6/18.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWPublishVC.h"
#import <YYText/YYText.h>

@interface WWPublishVC ()<YYTextViewDelegate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) YYLabel *yearsLbale;
@property (nonatomic, strong) YYTextView *inputTextView;
@property (nonatomic, strong) UIButton *mineLook;
@property (nonatomic, strong) UIButton *pubLish;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL isPublish;
@end

@implementation WWPublishVC
- (instancetype)initWithYear:(NSInteger )years andIsPublish:(BOOL)isPublish{
    if (self = [super init]) {
        self.isPublish = isPublish;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self.view addSubview:self.nav];
    [self setupSubview];
}
- (void)setupSubview {
    [self.view addSubview:self.containerView];
    self.containerView.top = self.nav.bottom+10*screenRate;
    self.containerView.left = 20*screenRate;
    self.containerView.width = KWidth - 40*screenRate;
    self.containerView.height = 542*screenRate;
    
    if (self.isPublish) {
        
    }
    
    
    
    [self.containerView addSubview:self.pubLish];
    [self.pubLish sizeToFit];
    self.pubLish.bottom = self.containerView.bottom -25*screenRate;
    self.pubLish.centerX = self.containerView.centerX-20*screenRate;
    
    [self.containerView addSubview:self.sepLine];
    [self.sepLine sizeToFit];
    self.sepLine.top = self.containerView.top+350*screenRate;
    self.sepLine.left = 20*screenRate;
    self.sepLine.width = self.containerView.width - 40*screenRate;
    self.sepLine.height = 1;
    [self.sepLine sizeToFit];
    
    [self.containerView addSubview:self.mineLook];
    [self.mineLook sizeToFit];
    self.mineLook.top = self.sepLine.bottom + 20*screenRate;
    self.mineLook.left = 20*screenRate;
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)publishClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"发布";
    }
    return _nav;
}
- (YYLabel *)yearsLbale {
    if (!_yearsLbale) {
        _yearsLbale = [[YYLabel alloc]init];
        _yearsLbale.textColor = RGBCOLOR(0x50616E);
        _yearsLbale.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    }
    return _yearsLbale;
}
- (YYTextView *)inputTextView {
    if (_inputTextView == nil) {
        _inputTextView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        _inputTextView.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _inputTextView.textColor = RGBCOLOR(0x39454E);
        _inputTextView.placeholderText = @"留下些什么？";
        _inputTextView.placeholderTextColor = RGBCOLOR(0xCCCCCC);
        _inputTextView.placeholderFont = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType = UIReturnKeyDone;
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = RGBCOLOR(0xC9D4DD);
    }
    return _sepLine;
}
- (UIButton *)mineLook {
    if (!_mineLook) {
        _mineLook = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mineLook setTitle:@"仅自己可见" forState:UIControlStateSelected];
        _mineLook.titleLabel.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
//        _mineLook.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_mineLook setImage:[UIImage imageNamed:@"normalLock"] forState:UIControlStateNormal];
//        [_mineLook setImage:[UIImage imageNamed:@"selectLock"] forState:UIControlStateHighlighted];
        [_mineLook setTitleColor:RGBCOLOR(0xA6B1BA) forState:UIControlStateNormal];
        [_mineLook setTitleColor:RGBCOLOR(0x50616E) forState:UIControlStateSelected];
//        _mineLook.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
//        _mineLook.titleEdgeInsets = UIEdgeInsetsMake(0,12*screenRate,0,0);
    }
    return _mineLook;
}
- (UIButton *)pubLish {
    if (!_pubLish) {
        _pubLish = [[UIButton alloc]init];
        [_pubLish setImage:[UIImage imageNamed:@"homePublish"] forState:UIControlStateNormal];
        [_pubLish addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pubLish;
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.opaque = NO;
        _containerView.layer.cornerRadius = 10;
    }
    return _containerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
