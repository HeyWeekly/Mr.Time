//
//  Permissions.h
//  YaoKe
//
//  Created by steaest on 17/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Permissions : NSObject

/// 相机权限
+ (BOOL)isGetCameraPermission;
/// 跳转相机权限
+ (void)getCameraPerMissionWithViewController:(WWRootViewController *)viewController;
/// 相册权限
+ (BOOL)isGetPhotoPermission;
/// 跳转相册权限
+ (void)getPhonePermissionWithViewController:(WWRootViewController *)viewController;
@end
