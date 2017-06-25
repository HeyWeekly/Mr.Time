//
//  WWShareView.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWShareView.h"

@interface WWShareView ()

@end

@implementation WWShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews {
    [self addSubview:self.weChat];
    [self.weChat sizeToFit];
    self.weChat.left = 20*screenRate;
    self.weChat.bottom = self.bounds.size.height - 16*screenRate;
    
    [self addSubview:self.moment];
    [self.moment sizeToFit];
    self.moment.left = self.weChat.right+46*screenRate;
    self.moment.bottom = self.weChat.bottom;
    
    [self addSubview:self.weibo];
    [self.weibo sizeToFit];
    self.weibo.left = self.moment.right+46*screenRate;
    self.weibo.bottom = self.weChat.bottom;
    
    [self addSubview:self.QQZone];
    [self.QQZone sizeToFit];
    self.QQZone.left = self.weibo.right+46*screenRate;
    self.QQZone.bottom = self.weChat.bottom;
    
    [self addSubview:self.download];
    [self.download sizeToFit];
    self.download.left = self.QQZone.right+46*screenRate;
    self.download.bottom = self.weChat.bottom;
}
- (UIButton *)weChat {
    if (_weChat == nil) {
        _weChat = [[UIButton alloc]init];
        [_weChat setImage:[UIImage imageNamed:@"Wechat"] forState:UIControlStateNormal];
    }
    return _weChat;
}
- (UIButton *)moment {
    if (_moment == nil) {
        _moment = [[UIButton alloc]init];
        [_moment setImage:[UIImage imageNamed:@"Moment"] forState:UIControlStateNormal];
    }
    return _moment;
}
- (UIButton *)weibo {
    if (_weibo == nil) {
        _weibo = [[UIButton alloc]init];
        [_weibo setImage:[UIImage imageNamed:@"Weibo"] forState:UIControlStateNormal];
    }
    return _weibo;
}
- (UIButton *)QQZone {
    if (_QQZone == nil) {
        _QQZone = [[UIButton alloc]init];
        [_QQZone setImage:[UIImage imageNamed:@"QQzone"] forState:UIControlStateNormal];
    }
    return _QQZone;
}
- (UIButton *)download {
    if (_download == nil) {
        _download = [[UIButton alloc]init];
        [_download setImage:[UIImage imageNamed:@"Savetoalbum"] forState:UIControlStateNormal];
    }
    return _download;
}
@end
