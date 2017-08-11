//
//  WWActionSheet.m
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. AWW rights reserved.
//

#import "WWActionSheet.h"

static UIView *actionSheetContainer;

typedef NS_ENUM(NSInteger, WWActionItemType) {
    kWWActionItemTypeTitle,
    kWWActionItemTypeAction,
    kWWActionItemTypeCancel
};

#define TITLE_FONT_SIZE 13
#define TITLE_FONT_COLOR [UIColor lightGrayColor]
#define TITLE_BAR_HEIGHT 65

#define ACTION_FONT_SIZE 17
#define ACTION_FONT_DEFAULT_COLOR [UIColor blackColor]
#define ACTION_FONT_DESTRUCTIVE_COLOR [UIColor redColor];
#define ACTION_BAR_HEIGHT 55

#define CANCEL_FONT_SIZE 17
#define CANCEL_FONT_COLOR [UIColor blackColor]
#define CANCEL_BAR_HEIGHT 55

#define CANCEL_BAR_GAP 7

WWActionSheetAction *WW_ActionSheetSeperator = nil;


@implementation WWActionSheetAction

+ (void)load {
    if (!WW_ActionSheetSeperator)
        WW_ActionSheetSeperator = [[WWActionSheetAction alloc] init];
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(WWActionSheetAction *action))handler {
    return [self actionWithTitle:title handler:handler style:kWWActionStyleDefault];
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(ACTION_BLOCK)handler style:(WWActionStyle)style {
    
    WWActionSheetAction * action = [[WWActionSheetAction alloc] init];
    action.title = title;
    action.handler = handler;
    action.style = style;
    
    return action;
}

@end


@interface WWActionSheet ()

@property (nonatomic, copy) NSString *title;

@property (nonatomic) UIView *contentView;

@property (nonatomic) NSMutableArray<WWActionSheetAction *> *actions;

@end

@implementation WWActionSheet{
    CGRect _windowBounds;
}
- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.title = title;
        self.backgroundColor = [UIColor clearColor];
        self.actions = [NSMutableArray array];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = RGBCOLOR(0xD2D2D2);
        [self addSubview:_contentView];
        
        [self addTapGestureRecognizer:@selector(tapHandler:)];
    }
    
    return self;
}

- (void)addAction:(WWActionSheetAction *)action {
    [self.actions addObject:action];
}

- (void)addActions:(NSArray<WWActionSheetAction *> *)actions {
    [self.actions addObjectsFromArray:actions];
}

- (void)showInWindow:(UIWindow *)window {
    if (!actionSheetContainer) {
        actionSheetContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        actionSheetContainer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    }
    
    if (!actionSheetContainer.superview){
        if (!window || window == [WWGeneric popOverWindow]) {
            [WWGeneric addViewToPopOverWindow:actionSheetContainer];
        }else {
            [window addSubview:actionSheetContainer];
        }
    }
    
    _windowBounds = [UIScreen mainScreen].bounds;
    actionSheetContainer.frame = _windowBounds;
    
    [self setupViews];
    [actionSheetContainer addSubview:self];
    
    self.contentView.top = CGRectGetHeight(_windowBounds);
    if (actionSheetContainer.subviews.count == 1) {
        actionSheetContainer.alpha = 0;
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.contentView.bottom = CGRectGetHeight(_windowBounds);
                         actionSheetContainer.alpha = 1;
                     }
                     completion:nil];
    
    
}


- (void)setupViews {
    CGFloat _y = 0;
    if (self.title && self.title.length > 0) {
        UIView *titleView = [self createItemWithType:kWWActionItemTypeTitle
                                                data:nil];
        [self.contentView addSubview:titleView];
        _y = CGRectGetMaxY(titleView.frame);
    }
    
    for (WWActionSheetAction *action in self.actions) {
        if (action == WW_ActionSheetSeperator) {
            _y += CANCEL_BAR_GAP;
        }else {
            UIView *actionButton = [self createItemWithType:kWWActionItemTypeAction
                                                       data:action];
            [self.contentView addSubview:actionButton];
            actionButton.top = _y;
            _y += CGRectGetHeight(actionButton.frame);
        }
    }
    
    UIView *cancelButton = [self createItemWithType:kWWActionItemTypeCancel
                                               data:nil];
    [self.contentView addSubview:cancelButton];
    _y += CANCEL_BAR_GAP;
    cancelButton.top = _y;
    _y += CGRectGetHeight(cancelButton.frame);
    
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(_windowBounds), _y);
}

- (CGFloat)barHeightForType:(WWActionItemType)type {
    switch(type) {
        case kWWActionItemTypeTitle:
            return TITLE_BAR_HEIGHT;
        case kWWActionItemTypeAction:
            return ACTION_BAR_HEIGHT;
        case kWWActionItemTypeCancel:
            return CANCEL_BAR_HEIGHT;
    }
}


- (UIView *)createItemWithType:(WWActionItemType)type data:(WWActionSheetAction *)data {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_windowBounds), [self barHeightForType:type]);
    
    if (type == kWWActionItemTypeTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = TITLE_FONT_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        return titleLabel;
    }else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]] forState:UIControlStateHighlighted];
        
        if (type == kWWActionItemTypeAction) {
            [button setTitle:data.title forState:UIControlStateNormal];
            button.tag = [self.actions indexOfObject:data];
            [button addTarget:self action:@selector(tapAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            UIColor *buttonTitleColor = data.style == kWWActionStyleDefault ? ACTION_FONT_DEFAULT_COLOR : ACTION_FONT_DESTRUCTIVE_COLOR;
            [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:ACTION_FONT_SIZE];
            
            CALayer *line = [CALayer layer];
            line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
            line.frame = CGRectMake(0, 0, KWidth, 1/[UIScreen mainScreen].scale);
            [button.layer addSublayer:line];
        }else if (type == kWWActionItemTypeCancel) {
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapCancel:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:CANCEL_FONT_COLOR forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:CANCEL_FONT_SIZE];
        }
        
        return button;
    }
    
    return nil;
}

- (void)tapCancel:(id)sender {
    [self close];
}

- (void)tapAction:(UIButton *)sender {
    WWActionSheetAction *action = self.actions[sender.tag];
    if (action.handler) {
        action.handler(action);
        [self close];
    }
}

- (void)tapHandler:(id)sender {
    [self close];
}

- (void)hideInWindow:(UIWindow *)window {
    [self close];
}

- (void)close {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.top = CGRectGetHeight(_windowBounds);
        
        if (actionSheetContainer.subviews.count == 1){
            actionSheetContainer.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (actionSheetContainer.subviews.count == 0){
            if (actionSheetContainer.window == [WWGeneric popOverWindow])
                [WWGeneric removeViewFromPopOverWindow:actionSheetContainer];
            else {
                [actionSheetContainer removeFromSuperview];
            }
        }
    }];
}

@end
