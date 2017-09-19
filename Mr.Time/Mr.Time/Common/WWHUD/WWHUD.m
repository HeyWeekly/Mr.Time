//
//  WWHUD.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/16.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWHUD.h"

static WWHUD *instance = nil;

@implementation WWHUD

+(instancetype)shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WWHUD alloc] init];
    });
    return instance;
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(WWProgressMode *)myMode {
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(WWProgressMode *)myMode customImgView:(UIImageView *)customImgView {
    
    if ([WWHUD shareinstance].hud != nil) {
        [[WWHUD shareinstance].hud hideAnimated:YES];
        [WWHUD shareinstance].hud = nil;
    }
    
    [WWHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //这里设置是否显示遮罩层
    //[WWHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [WWHUD shareinstance].hud.bezelView.color = [UIColor blackColor];
    [WWHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    
    [[WWHUD shareinstance].hud setMargin:10];
    [[WWHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [WWHUD shareinstance].hud.detailsLabel.text = msg;
    
    [WWHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch ((NSInteger)myMode) {
            case WWProgressModeOnlyText:
            [WWHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;
            
            case WWProgressModeLoading:
            [WWHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
            case WWProgressModeCircle:{
                [WWHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                animation.toValue = [NSNumber numberWithFloat:M_PI*2];
                animation.duration = 1.0;
                animation.repeatCount = 100;
                [img.layer addAnimation:animation forKey:nil];
                [WWHUD shareinstance].hud.customView = img;
            
                break;
            }
            case WWProgressModeCustomerImage:
            [WWHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [WWHUD shareinstance].hud.customView = customImgView;
            break;
            
            case WWProgressModeCustomAnimation:
            //这里设置动画的背景色
            [WWHUD shareinstance].hud.bezelView.color = [UIColor yellowColor];
            
            [WWHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [WWHUD shareinstance].hud.customView = customImgView;
            
            break;
            
            case WWProgressModeSuccess:
            [WWHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [WWHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
}


+(void)hide {
    if ([WWHUD shareinstance].hud != nil) {
        [[WWHUD shareinstance].hud hideAnimated:YES];
    }
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view {
    [self show:msg inView:view mode:WWProgressModeOnlyText];
    [[WWHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay {
    [self show:msg inView:view mode:WWProgressModeOnlyText];
    [[WWHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view {
    [self show:msg inView:view mode:WWProgressModeSuccess];
    [[WWHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+(void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:WWProgressModeCustomerImage customImgView:img];
    [[WWHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view {
    [self show:msg inView:view mode:WWProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
}

+(void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view {
    [self show:msg inView:view mode:WWProgressModeCircle];
}

+(void)showMsgWithoutView:(NSString *)msg {
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:WWProgressModeOnlyText];
    [[WWHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view {
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:WWProgressModeCustomAnimation customImgView:showImageView];
}
@end
