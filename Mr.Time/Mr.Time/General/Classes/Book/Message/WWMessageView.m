//
//  WWMessageView.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/11/28.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWMessageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WWMessageView () <YYTextViewDelegate>
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, strong) UIView* gestureView;
@property (nonatomic, assign) CGFloat lastHeight;
@property (nonatomic, strong) UILabel* placerHolderLabel;
@property (nonatomic, strong) NSLayoutConstraint* headImageLeftConstrant;
@property (nonatomic, strong) NSLayoutConstraint* sendBtnRightConstrant;
@property (nonatomic, strong) NSLayoutConstraint* animationConstraint;
@property (nonatomic, strong) UIImageView *addImage;
@end

@implementation WWMessageView

- (instancetype)init{
    if (self = [super init]) {
        [self setSubviews];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSubviews{
    [self addSubview:self.inputView];
    [self addSubview:self.maskView];
    [self addSubview:self.addImage];
    [self.inputView addSubview:self.placerHolderLabel];
    [self addSubview:self.sendBtn];
    self.addImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
    self.placerHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"input":self.inputView,@"mask":self.maskView,@"holder":self.placerHolderLabel,@"send":self.sendBtn,@"add":self.addImage};
    NSDictionary *metrics1 = @{@"Hinput":@(15*screenRate),@"Vinput":@(10*screenRate),@"intH":@(275*screenRate),@"www":@(30*screenRate),@"qqq":@(7*screenRate)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mask]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mask(==0.5)]" options:0 metrics:nil views:dict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Hinput-[add(==www)]-Vinput-[input(==intH)]-qqq-[send]" options:0 metrics:metrics1 views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Vinput-[input]-Vinput-|" options:0 metrics:metrics1 views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[add(==www)]" options:0 metrics:metrics1 views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Vinput-[send]-Vinput-|" options:0 metrics:metrics1 views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Vinput-[add]-Vinput-|" options:0 metrics:metrics1 views:dict]];
    self.animationConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30*screenRate];
    [self addConstraint:self.animationConstraint];
    [self.inputView addConstraint:[NSLayoutConstraint constraintWithItem:self.placerHolderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.inputView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10*screenRate]];
    [self.inputView addConstraint:[NSLayoutConstraint constraintWithItem:self.placerHolderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.inputView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5*screenRate]];
}

#pragma mark - input method
- (void)sendMessage {
    if ([self.delegate respondsToSelector:@selector(sendDiscuss)]) {
        [self.delegate sendDiscuss];
        [self.inputView resignFirstResponder];
        [self textViewDidEndEditing:self.inputView];
    }
}

- (void)addClick {
    if ([self.delegate respondsToSelector:@selector(addSendImage)]) {
        [self.delegate addSendImage];
    }
}

- (void)startInputWithReplyName:(NSString*)replyName{
    if (replyName) {
        [self setPlacerHolderLabelAttrStrWithReplyName:replyName];
    }
    [self.inputView becomeFirstResponder];
}

- (void)endInput{
    if ([self.delegate respondsToSelector:@selector(removeAddView)]) {
        [self.delegate removeAddView];
    }
    [self.inputView resignFirstResponder];
    [self textViewDidEndEditing:self.inputView];
}

- (void)setPlacerHolderLabelAttrStrWithReplyName:(NSString*)replyName{
    if (replyName.length == 0 || replyName == nil) {
        replyName = @"自己";
    }
    NSString* str = [NSString stringWithFormat:@"回复%@",replyName];
    NSMutableAttributedString* mtAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [mtAttrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_Regular size:14*screenRate] range:range];
    [mtAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.placerHolderLabel.attributedText = mtAttrStr;
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.attributedText.string isEqualToString:@"添加评论..."]) {
        textView.attributedText = nil;
        self.placerHolderLabel.alpha = 1;
        self.sendBtn.enabled = NO;
    }
    [self.superview insertSubview:self.gestureView belowSubview:self];
}
#define DISMAX_STARWORDS_LENGTH 140
- (void)textViewDidChange:(UITextView *)textView{
    NSString* str = textView.text;
    NSInteger length = str.length;
    __block NSInteger count = 0;
    if (length > 0) {
        self.placerHolderLabel.alpha = 0;
        self.sendBtn.enabled = YES;
    }else{
        self.placerHolderLabel.alpha = 1;
        self.sendBtn.enabled = NO;
    }
    
    [textView.text enumerateSubstringsInRange:NSMakeRange(0, length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         char commitChar = [str characterAtIndex:0];
         NSString *temp = [str substringWithRange:NSMakeRange(0,1)];
         const char *u8Temp = [temp UTF8String];
         if ([self stringContainsEmoji:substring]) {
             count += 1;
         }else if (u8Temp && 3==strlen(u8Temp)) {
             count += 2;
         }else if(commitChar >= 0 && commitChar <= 127){
             count++;
         }
     }];
    
    CGFloat height = textView.contentSize.height;
    if (self.lastHeight == height || (self.lastHeight >= 140 && height >= 140)) {
        return;
    }
    self.lastHeight = height;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.gestureView removeFromSuperview];
    self.gestureView = nil;
    if (textView.text.length != 0) {
        return;
    }
    NSString* str = @"添加评论...";
    NSMutableAttributedString* mtAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [mtAttrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_Regular size:14*screenRate] range:range];
    [mtAttrStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x39454E) range:range];
    textView.attributedText = mtAttrStr;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.animationConstraint.constant = 30*screenRate;
        [self layoutIfNeeded];
        self.inputView.contentOffset = CGPointMake(0, 0);
    }];
    self.placerHolderLabel.alpha = 1;
    self.placerHolderLabel.text = @"";
    self.sendBtn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(removeAddView)]) {
        [self.delegate removeAddView];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\r"] || [text isEqualToString:@"\n"] || [text isEqualToString:@"\r\n"]) {
        NSString* str = textView.text;
        NSInteger length = str.length;
        __block NSInteger count = 0;
        [textView.text enumerateSubstringsInRange:NSMakeRange(0, length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             char commitChar = [str characterAtIndex:0];
             NSString *temp = [str substringWithRange:NSMakeRange(0,1)];
             const char *u8Temp = [temp UTF8String];
             if ([self stringContainsEmoji:substring]) {
                 count += 1;
             }else if (u8Temp && 3==strlen(u8Temp)) {
                 count += 2;
             }else if(commitChar >= 0 && commitChar <= 127){
                 count++;
             }else{
                 count++;
             }
         }];
        if (count > 280) {
            return NO;
        }
        //        if ([self.delegate respondsToSelector:@selector(sendDiscuss)]) {
        //            [self.delegate sendDiscuss];
        [self.inputView resignFirstResponder];
        [self textViewDidEndEditing:self.inputView];
        //        }
        return NO;
    }
    return YES;
}

//表情判断
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

#pragma mark - lazyLoad
- (YYTextView *)inputView {
    if (_inputView == nil) {
        _inputView = [[YYTextView alloc]init];
        _inputView.layer.borderColor = RGBCOLOR(0x27EBCD).CGColor;
        _inputView.layer.borderWidth = 1;
        _inputView.layer.cornerRadius = 15;
        _inputView.clipsToBounds = YES;
        _inputView.font = [UIFont fontWithName:kFont_Regular size:14*screenRate];
        _inputView.textColor = RGBCOLOR(0x39454E);
        _inputView.placeholderText = @"添加评论...";
        _inputView.placeholderTextColor = RGBCOLOR(0xCCCCCC);
        _inputView.placeholderFont = [UIFont fontWithName:kFont_Regular size:14*screenRate];
        _inputView.keyboardType = UIKeyboardTypeDefault;
        _inputView.returnKeyType = UIReturnKeyDone;
        _inputView.delegate = self;
    }
    return _inputView;
}
- (UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _maskView;
}
- (UILabel *)placerHolderLabel{
    if (_placerHolderLabel == nil) {
        _placerHolderLabel = [[UILabel alloc] init];
        _placerHolderLabel.textAlignment = NSTextAlignmentCenter;
        _placerHolderLabel.textColor = RGBCOLOR(0xcccccc);
        _placerHolderLabel.font = [UIFont fontWithName:kFont_Regular size:14*screenRate];
        _placerHolderLabel.text = @"添加评论...";
    }
    return _placerHolderLabel;
}

- (UIView *)gestureView{
    if (_gestureView == nil) {
        _gestureView = [[UIView alloc] init];
        _gestureView.frame = CGRectMake(0, 0, KWidth, KHeight);
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endInput)];
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endInput)];
        [_gestureView addGestureRecognizer:panGesture];
        [_gestureView addGestureRecognizer:gesture];
    }
    return _gestureView;
}

- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        [_sendBtn setTitleColor:RGBCOLOR(0x15C2FF) forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.enabled = NO;
    }
    return _sendBtn;
}

- (UIImageView *)addImage {
    if (_addImage == nil) {
        _addImage = [[UIImageView alloc]init];
        WWUserModel *model = [WWUserModel shareUserModel];
        model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
        if (model.headimgurl) {
            [_addImage sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
        } else if (model.headimg) {
            _addImage.image = model.headimg;
        }
        _addImage.layer.cornerRadius = 15*screenRate;
        _addImage.clipsToBounds = YES;
    }
    return _addImage;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
