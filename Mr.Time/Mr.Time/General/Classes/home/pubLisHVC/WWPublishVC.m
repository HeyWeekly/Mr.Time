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
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UITextField *yearsField;
@property (nonatomic, assign) NSUInteger yearsNum;
@end

@implementation WWPublishVC
- (instancetype)initWithYear:(NSInteger )years andIsPublish:(BOOL)isPublish{
    if (self = [super init]) {
        self.isPublish = isPublish;
        self.isSelect = NO;
        self.yearsNum = years;
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
        self.yearsLbale.font = [UIFont fontWithName:kFont_Medium size:19*screenRate];
        self.yearsLbale.text = @"写给多少岁：";
        [self.containerView addSubview:self.yearsLbale];
        [self.yearsLbale sizeToFit];
        self.yearsLbale.left = 20*screenRate;
        self.yearsLbale.top = 20*screenRate;
        
        [self.containerView addSubview:self.yearsField];
        [self.yearsField sizeToFit];
        self.yearsField.left = self.yearsLbale.right;
        self.yearsField.top = self.yearsLbale.top - 2;
        self.yearsField.width = self.containerView.width - self.yearsLbale.width - 40*screenRate;
    }else {
        NSString *str = [NSString stringWithFormat:@"%ld",self.yearsNum];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"TO %@  YEARS OLD",str]];
        [text yy_setTextHighlightRange:NSMakeRange(3, str.length)
                                 color:RGBCOLOR(0x15C2FF)
                       backgroundColor:[UIColor whiteColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                             }];
        self.yearsLbale.attributedText = text;
        self.yearsLbale.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        [self.containerView addSubview:self.yearsLbale];
        [self.yearsLbale sizeToFit];
        self.yearsLbale.centerX = self.containerView.centerX-20*screenRate;
        self.yearsLbale.top = 20*screenRate;
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
    self.mineLook.width = 250*screenRate;
    
    [self.containerView addSubview:self.inputTextView];
    [self.inputTextView sizeToFit];
    self.inputTextView.left = 20*screenRate;
    self.inputTextView.top = 68*screenRate;
    self.inputTextView.width = self.containerView.width-40*screenRate;
    self.inputTextView.height = 363*screenRate;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)publishClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)minlookclick {
    self.isSelect = !self.isSelect;
    if (self.isSelect == YES) {
        [_mineLook setImage:[UIImage imageNamed:@"selectLock"] forState:UIControlStateNormal];
        [_mineLook setTitleColor:RGBCOLOR(0x50616E) forState:UIControlStateNormal];
    }else {
        [_mineLook setImage:[UIImage imageNamed:@"normalLock"] forState:UIControlStateNormal];
        [_mineLook setTitleColor:RGBCOLOR(0xA6B1BA) forState:UIControlStateNormal];
    }
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
        [_mineLook setTitle:@"仅自己可见" forState:UIControlStateNormal];
        _mineLook.titleLabel.font = [UIFont fontWithName:kFont_Medium size:14*screenRate];
        _mineLook.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_mineLook setImage:[UIImage imageNamed:@"normalLock"] forState:UIControlStateNormal];
        [_mineLook setTitleColor:RGBCOLOR(0xA6B1BA) forState:UIControlStateNormal];
        _mineLook.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
        _mineLook.titleEdgeInsets = UIEdgeInsetsMake(0,12*screenRate,0,0);
        [_mineLook addTarget:self action:@selector(minlookclick) forControlEvents:UIControlEventTouchUpInside];
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
- (UITextField *)yearsField {
    if (!_yearsField) {
        _yearsField = [[UITextField alloc]init];
        _yearsField.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _yearsField.textColor = RGBCOLOR(0x15C2FF);
    }
    return _yearsField;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
