//
//  WWErrorView.m
//  YaoKe
//
//  Created by steaest on 2017/3/15.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import "WWErrorView.h"

typedef NS_ENUM(NSInteger, MainNavErrorType) {
    MainNavErrorTypeDefualt = 0,
    MainNavErrorTypeSmall = 1
};

@interface WWErrorView ()
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UILabel* recommentView;
@end

@implementation WWErrorView

static WWErrorView* instance = nil;

+ (void)initialize{
    if (self == [WWErrorView class]) {
        instance = [[WWErrorView alloc] init];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showErrorView:) name:kNotify_MainNavShowError object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecomment:) name:kNotify_MainNavShowRecomment object:nil];
    }
    return self;
}

- (void)showErrorView:(NSNotification*)notify {
    [self startErrorViewWithText:notify.userInfo[kUserInfo_MainNavErrorMsg] type:notify.userInfo[kUserInfo_MainNavErrorType]];
}

- (void)showRecomment:(NSNotification*)notify {
    if (!self.recommentView) {
        NSString* msg = notify.userInfo[kUserInfo_MainNavRecommentMsg];
        [self showAttention:msg];
    }
}

- (void)showAttention:(NSString *)showLabel {
    self.recommentView = [[UILabel alloc]init];
    self.recommentView.backgroundColor = [UIColor blackColor];
    self.recommentView.alpha = 0.75;
    self.recommentView.layer.cornerRadius = 5;
    self.recommentView.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString* mAttr = [[NSMutableAttributedString alloc] initWithString:showLabel attributes:@{NSFontAttributeName:[UIFont fontWithName:kFont_Regular size:14*screenRate],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.recommentView.attributedText = mAttr.copy;
    CGSize size = [mAttr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    size = CGSizeMake(size.width + 30*screenRate, size.height + 20*screenRate);
    self.recommentView.frame = CGRectMake((KWidth - size.width) / 2.0, (KHeight - size.height) / 2.0 - KHeight * 0.1, size.width, size.height);
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.recommentView];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.recommentView.alpha=0;
        } completion:^(BOOL finished) {
            weakSelf.recommentView = nil;
            [weakSelf.recommentView removeFromSuperview];
        }];
    });
}

#pragma mark - 关于errorView
- (void)startErrorViewWithText:(NSString*)content type:(NSNumber*)type {
    if (!self.errorView) {
        UIView *errorView = [[UIView alloc]init];
        UILabel *errorLabel = [[UILabel alloc]init];
        errorLabel.text = content;
        errorLabel.textColor = [UIColor whiteColor];
        if (type && type.integerValue == MainNavErrorTypeSmall) {
            errorView.frame = CGRectMake(0, -20, KWidth, 20);
            errorView.backgroundColor = RGBCOLOR(0x414449);
            errorLabel.frame = CGRectMake(0, 0, errorView.frame.size.width, errorView.frame.size.height);
            errorLabel.font = [UIFont fontWithName:kFont_Regular size:12];
        }else{
            errorLabel.font = [UIFont fontWithName:kFont_Regular size:12*screenRate];
            errorView.frame = CGRectMake(0, -20, KWidth, 20);
            errorView.backgroundColor = [UIColor greenColor];
            errorLabel.frame = CGRectMake(0, 0, errorView.frame.size.width, errorView.frame.size.height);
        }
        [errorView addSubview:errorLabel];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        self.errorView = errorView;
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.errorView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.errorView.frame = CGRectMake(0, 0, KWidth, self.errorView.frame.size.height);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeErrorViewOK];
            });
        }];
    }
}

- (void)removeErrorViewOK {
    if (self.errorView) {
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.errorView.frame = CGRectMake(0, -self.errorView.frame.size.height, self.errorView.frame.size.width, self.errorView.frame.size.height);
        } completion:^(BOOL finished) {
            [self.errorView removeFromSuperview];
            self.errorView = nil;
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
