//
//  WWErrorView.h
//  YaoKe
//
//  Created by steaest on 2017/3/15.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  error 上弹窗（严重error）  中弹窗（轻度）
 *  接受两个通知
 kNotify_MainNavShowError (严重error)
 UserInfo:
 // String
 kUserInfo_MainNavErrorMsg
 // NSNumber  <MainNavErrorType>
 kUserInfo_MainNavErrorType
 
 kNotify_MainNavShowRecomment  (轻度提示)
 UserInfo:
 // String
 kUserInfo_MainNavRecommentMsg
 */
@interface WWErrorView : NSObject

@end
