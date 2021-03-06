//
//  WWPublishVC.m
//  Mr.Time
//
//  Created by steaest on 2017/6/18.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWPublishVC.h"
#import <YYText/YYText.h>
#import "WWShareSucceedView.h"

@interface WWPublishVC ()<YYTextViewDelegate,UITextFieldDelegate>
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
@property (nonatomic, strong) WWShareSucceedView *sucView;
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

- (void)setMettoId:(NSInteger)mettoId {
    _mettoId = mettoId;
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
    
    [self.pubLish sizeToFit];
    if (UIScreen.mainScreen.bounds.size.height == 812) {
        self.pubLish.bottom = self.containerView.bottom -50*screenRate;
    }else {
        self.pubLish.bottom = self.containerView.bottom -25*screenRate;
    }
    self.pubLish.centerX = self.containerView.centerX-20*screenRate;
    [self.containerView addSubview:self.pubLish];
    
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

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.yearsField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - event
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishClick {
    WEAK_SELF;
    if (self.isPublish) {
        if (self.yearsField.text.length <= 0 && self.inputTextView.text.length <= 0) {
            [WWHUD showMessage:@"请填写年龄和箴言" inView:self.view];
            return;
        }
    }
    if (self.isPublish) {
        if (self.yearsField.text.length <= 0) {
            [WWHUD showMessage:@"请填写年龄" inView:self.view];
            return;
        }else {
            NSString *yearStr = self.yearsField.text;
            NSString *firstStr = [yearStr substringToIndex:1];
            if ([firstStr isEqualToString:@"0"]) {
                [WWHUD showMessage:@"年龄不能用0开头" inView:self.view];
                self.yearsField.text = nil;
                return;
            }
            if ([yearStr isEqualToString:@"0"]) {
                [WWHUD showMessage:@"怎么可能是0岁呢~" inView:self.view];
                self.yearsField.text = nil;
                return;
            }
            if (yearStr.integerValue > 100) {
                [WWHUD showMessage:@"让我们先祈祷活到99岁吧" inView:self.view];
                self.yearsField.text = @"100";
                return;
            }
        }
    }
        if (self.inputTextView.text.length <= 0) {
            [WWHUD showMessage:@"请填写箴言" inView:self.view];
            return;
        }
    
    if (self.inputTextView.text.length > 119) {
        [WWHUD showMessage:@"内容限制119以内" inView:self.view];
        return;
    }
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = postMotto;
        request.parameters = @{@"content": self.inputTextView.text,@"age": self.isPublish ? @(self.yearsField.text.integerValue) : @(self.yearsNum)};
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postMetto" object:nil userInfo:nil];
        weakSelf.sucView = [[WWShareSucceedView alloc]init];
        weakSelf.sucView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2,([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80);
        [weakSelf.view addSubview:weakSelf.sucView];
        [weakSelf.sucView processSucceed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.sucView removeFromSuperview];
            for (UIView* view in weakSelf.view.subviews) {
                if ([[view class] isSubclassOfClass:[WWShareSucceedView class]]) {
                    [view removeFromSuperview];
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } onFailure:^(NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil userInfo:@{kUserInfo_MainNavRecommentMsg:@"发布失败，服务器可能挂了~"}];
    } onFinished:nil];
    
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

#pragma mark - lazyload
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KWidth, 44)];
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
        _inputTextView.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    return _inputTextView;
}

- (UITextField *)yearsField {
    if (!_yearsField) {
        _yearsField = [[UITextField alloc]init];
        _yearsField.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _yearsField.textColor = RGBCOLOR(0x15C2FF);
        _yearsField.keyboardType = UIKeyboardTypeNumberPad;
        _yearsField.keyboardAppearance = UIKeyboardAppearanceDark;
        _yearsField.returnKeyType = UIReturnKeyDone;
        _yearsField.delegate = self;
    }
    return _yearsField;
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
        _mineLook.hidden = YES;
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

@end
