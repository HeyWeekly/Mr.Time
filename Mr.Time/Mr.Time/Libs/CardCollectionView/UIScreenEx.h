//
//  UIScreenEx.h
//  baseUI
//
//  Created by odie song on 12-9-13.
//  Copyright (c) 2012年 odie song. All rights reserved.
//

#ifndef __baseUI__UIScreenEx__
#define __baseUI__UIScreenEx__

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
    int getScreenWidth();
    
    int getScreenHeight();
    
    int getScreenScale();
    
    CGRect getScreenBounds();
    
    CGSize getScreenSize();
    
    
    // 获取状态栏竖边高度
    int getStatusBarHeight();
    
    void setStatusBarHeight(int newH);
    
    CGFloat fitScreenW(CGFloat value);
    CGFloat fitScreenWidthBy6(CGFloat value);
    CGFloat fitScreenHeightBy6(CGFloat value);
    CGFloat fontfitScreenWidthBy6(CGFloat value);
    CGFloat getPTbyPX(CGFloat value);
    CGFloat fitScreenH(CGFloat value);
    CGFloat fitScaleScreen(CGFloat value);
    CGFloat fitScaleFontScreen(CGFloat value);
    CGFloat screenScale();
    CGFloat screenFontSize();
    CGFloat screeniPhone6PlusScale(CGFloat value, CGFloat replaceValue);
#ifdef __cplusplus
}
#endif

#define SCREEN_WIDTH            getScreenWidth()
#define SCREEN_HEIGHT           getScreenHeight()
#define SCREEN_WIDTH_2          (SCREEN_WIDTH << 1)
#define SCREEN_HEIGHT_2         (SCREEN_HEIGHT << 1)

/**返回float*/
#define OPEN_AUTO_SCALE
#define _size_W(value)    fitScreenW(value)
#define _size_H(value)    fitScreenH(value)
#define _size_S(value)    fitScaleScreen(value)
#define _size_F(value)    fitScaleFontScreen(value)        //note by erwinkuang:手机系统设置字号缩放
#define _sizeScale        screenScale()

#define _size_W_6(value)  fitScreenWidthBy6(value)              //add by erwinkuang
#define _size_H_6(value)  fitScreenHeightBy6(value)             //add by peterhchen
#define _size_F_6(value)  fontfitScreenWidthBy6(value)          //add by erwinkuang：屏幕适配字号，设计提出：不按屏幕比例缩放 字号，故内部实现直接返回fitScaleFontScreen(value);
#define _getPTbyPX(value) getPTbyPX(value)                      //px转pt
//针对AIO当前切换字体时候自动退出方案做处理添加方案切换宏方便后面及时改动
//#define OPEN_AIO_AUTO_SCALE

// 这是竖屏的
#define APPLICATION_FRAME_WIDTH       ([UIScreen mainScreen].applicationFrame.size.width)
#define APPLICATION_FRAME_HEIGHT      ([UIScreen mainScreen].applicationFrame.size.height)

#define STATUSBAR_HEIGHT        getStatusBarHeight()
#define APPLICATION_WIDTH       (SCREEN_WIDTH)
#define APPLICATION_HEIGHT      (SCREEN_HEIGHT - STATUSBAR_HEIGHT)

#ifndef IS_IPHONE5
#define IS_IPHONE5   (SCREEN_HEIGHT > 480 ? TRUE:FALSE)
#endif

#ifndef IS_IPHONE_6P
#define IS_IPHONE_6P (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 736.0)
#endif

#define FontScreenSize screenFontSize()
#define PLUSSCALE(value,replaceValue) screeniPhone6PlusScale(value,replaceValue)

#endif /* defined(__baseUI__UIScreenEx__) */

