//
//  WWActionSheet.h
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WWActionStyle) {
    kWWActionStyleDefault = 0,
    kWWActionStyleDestructive
};


@class WWActionSheetAction;

typedef void (^ACTION_BLOCK)(WWActionSheetAction *action);

@interface WWActionSheetAction  : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic) WWActionStyle style;

@property (nonatomic, copy) ACTION_BLOCK handler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(ACTION_BLOCK)handler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(ACTION_BLOCK)handler style:(WWActionStyle)style;

@end

extern WWActionSheetAction *WW_ActionSheetSeperator;

@interface WWActionSheet : UIView
- (instancetype)initWithTitle:(NSString *)title;

- (void)addAction:(WWActionSheetAction *)action;

- (void)addActions:(NSArray<WWActionSheetAction *> *)actions;

- (void)showInWindow:(UIWindow *)window;

- (void)hideInWindow:(UIWindow *)window;
@end

