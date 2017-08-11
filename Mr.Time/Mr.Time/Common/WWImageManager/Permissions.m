//
//  Permissions.m
//  YaoKe
//
//  Created by steaest on 17/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "Permissions.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Permissions

+ (BOOL)isGetCameraPermission {
    AVAuthorizationStatus authStaus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStaus != AVAuthorizationStatusDenied) {
        return YES;
    }else {
        return NO;
    }
}

+ (void)getCameraPerMissionWithViewController:(WWRootViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机授权" message:@"没有权限访问您的相机，请在“设置－隐私－相机”中允许使" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=com.Offape.Mr-Time"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action2];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (BOOL)isGetPhotoPermission {
    
    BOOL bResult = NO;
    if ((int)[[UIDevice currentDevice] systemVersion] < 8.0) {
        if ([ALAssetsLibrary authorizationStatus] != AVAuthorizationStatusDenied) {
            bResult = YES;
        }
    }else {
        if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied) {
            bResult = YES;
        }
    }
    return bResult;
}

+ (void)getPhonePermissionWithViewController:(WWRootViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册授权" message:@"请到个人设置中给予访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=com.Offape.Mr-Time"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action2];
    [viewController presentViewController:alert animated:YES completion:nil];
}
@end
