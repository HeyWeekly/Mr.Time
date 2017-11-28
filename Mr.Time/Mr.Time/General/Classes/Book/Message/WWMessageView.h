//
//  WWMessageView.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/11/28.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

@protocol WWMessageViewDelegate <NSObject>
- (void)sendDiscuss;
- (void)addSendImage;
- (void)removeAddView;
@end

@interface WWMessageView : UIView
@property (nonatomic, weak) id <WWMessageViewDelegate> delegate;
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) YYTextView* inputView;
@property (nonatomic, strong) UIButton* sendBtn;

- (void)startInputWithReplyName:(NSString*)replyName;
- (void)endInput;
@end
