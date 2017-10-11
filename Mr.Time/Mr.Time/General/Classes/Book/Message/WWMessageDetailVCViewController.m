//
//  WWMessageDetailVCViewController.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWMessageDetailVCViewController.h"
#import "WWShareView.h"
#import "WWShareSucceedView.h"
#import "WWCollectButton.h"
#import "WXApi.h"

@interface WWMessageDetailVCViewController (){
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_contentLabel;
    
}
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UILabel *yearsNum;
@property (nonatomic, strong) UILabel *yearsLabel;
@property (nonatomic, strong) UILabel *oldLabel;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) WWShareView *shareView;
@property (nonatomic, strong) WWShareSucceedView *sucView;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger favoId;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *authAge;
@property (nonatomic, copy) NSString *authName;
@property (nonatomic, copy) NSString *favoCount;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) UIView *snapView;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation WWMessageDetailVCViewController

- (instancetype)initWithAge:(NSInteger )age comment:(NSString *)comment authAge:(NSString *)authAge authName:(NSString *)authName favoId:(NSInteger)favoId favoCount:(NSString *)favoCount source:(NSString *)source{
    if (self =[super init]) {
        self.age = age;
        self.favoId = favoId;
        self.favoCount = favoCount;
        self.source = source;
        self.comment = comment;
        self.authAge = authAge;
        self.authName = authName;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 视图
-(void)setupSubViews {
    [self.view addSubview:self.snapView];
    self.snapView.frame = self.view.bounds;
    [self.snapView addSubview:self.nav];
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 10.0f;
    self.containerView.top = self.nav.bottom+10*screenRate;
    self.containerView.left = 20*screenRate;
    self.containerView.width = KWidth - 40*screenRate;
    self.containerView.height = 525*screenRate;
    [self.snapView addSubview:self.containerView];
    
    //背景
    _imageView = [[UIImageView alloc] init];
    NSInteger ages = self.age/10;
    NSString *year = [NSString stringWithFormat:@"%ld",ages];
    _imageView.image = [UIImage imageNamed:[@"commentYearBg" stringByAppendingString:year]];
    if (self.age >= 100) {
        _imageView.image = [UIImage imageNamed:@"commentYearBg9"];
    }
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = true;
    [_imageView sizeToFit];
    _imageView.left = 0;
    _imageView.top = 0;
    [self.containerView addSubview:_imageView];

    
    //年龄
    [self.containerView addSubview:self.yearsNum];
    [self.yearsNum sizeToFit];
    self.yearsNum.left = 25*screenRate;
    self.yearsNum.top = 19*screenRate;
    [self.containerView addSubview:self.yearsLabel];
    [self.yearsLabel sizeToFit];
    self.yearsLabel.left = self.yearsNum.left;
    self.yearsLabel.top = self.yearsNum.bottom;
    
    //收藏
    _likeImage = [[WWCollectButton alloc] init];
    _likeImage.imageView.contentMode = UIViewContentModeCenter;
    _likeImage.favoType = 1;
    [_likeImage sizeToFit];
    _likeImage.right = self.containerView.bounds.size.width - 20*screenRate;
    _likeImage.top = 20*screenRate;
    [self.containerView addSubview:_likeImage];
    [_likeImage sizeToFit];
    [_likeImage addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.source isEqualToString:@"收藏列表"]) {
        [self.likeImage setFavo:YES withAnimate:NO];
        self.islike = YES;
    }else{
        if (self.favoCount.integerValue > 0) {
            [self.likeImage setFavo:YES withAnimate:NO];
            self.islike = YES;
        }else {
            [self.likeImage setFavo:NO withAnimate:NO];
            self.islike = NO;
        }
    }
    //名称
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = RGBCOLOR(0x94A3AE);
    _textLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
    _textLabel.numberOfLines = 1;
    _textLabel.adjustsFontSizeToFitWidth = true;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"—— 来自 %@岁 的 %@" ,self.authAge,self.authName]];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(6,self.authAge.length+1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(6, self.authAge.length+1)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(12,self.authName.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(12, self.authName.length)];
    _textLabel.attributedText = str;
    [_textLabel sizeToFit];
    _textLabel.bottom = self.containerView.bounds.size.height - 25*screenRate;
    _textLabel.right = self.containerView.bounds.size.width - 25*screenRate;
    [self.containerView addSubview:_textLabel];
    [_textLabel sizeToFit];
    
    //内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = RGBCOLOR(0x39454E);
    _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
    _contentLabel.numberOfLines = 5;
    _contentLabel.adjustsFontSizeToFitWidth = true;
    NSString *strText = self.comment;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:strText attributes:@{NSForegroundColorAttributeName : RGBCOLOR(0x39454E), NSParagraphStyleAttributeName: paragraphStyle}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_SemiBold size:27*screenRate] range:NSMakeRange(0, 1)];
    _contentLabel.attributedText = text;
    [_contentLabel sizeToFit];
    _contentLabel.top = _imageView.bottom;
    _contentLabel.left = 25*screenRate;
    _contentLabel.width = self.containerView.bounds.size.width - 50*screenRate;
    [self.containerView addSubview:_contentLabel];
    [_contentLabel sizeToFit];
    [self.view addSubview:self.shareView];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn sizeToFit];
    self.backBtn.left = 20;
    self.backBtn.top = 24;
}

#pragma mark - 点击事件
- (void)likeClick {
    self.islike = !self.islike;
        if (self.islike) {
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                if ([self.source isEqualToString:@"留言列表"]) {
                    request.api = commentLike;
                    request.parameters = @{@"cmtId":@(self.favoId)};
                }else if ([self.source isEqualToString:@"个人列表"]) {
                    request.api = likeMetto;
                    request.parameters = @{@"apthmId":@(self.favoId)};
                }
                request.httpMethod = kXMHTTPMethodPOST;
            } onSuccess:^(id  _Nullable responseObject) {
                [self.likeImage setFavo:YES withAnimate:YES];
            } onFailure:^(NSError * _Nullable error) {
                self.islike = !self.islike;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowRecomment object:nil      userInfo:@{kUserInfo_MainNavRecommentMsg:@"收藏失败，请稍后再试~"}];
            } onFinished:nil];
        }else {
            [WWHUD showMessage:@"暂不支持取消哟~" inView:self.view];
            return;
        }
}

#pragma mark - 点击事件
- (void)dowloadClick {
    UIImage *image = [self captureView:self.snapView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)weixinClick {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        UIImage *image = [self captureView:self.snapView];
        UIImage *smallImage = [UIImage compressImage:image toByte:32];
        [message setThumbImage:smallImage];
        WXImageObject *imageObiect = [WXImageObject object];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        imageObiect.imageData = imageData;
        message.mediaObject = imageObiect;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    } else {
        [WWHUD showMessage:@"您没安装微信" inView:self.view];
    }
}

- (void)momentClick {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        UIImage *image = [self captureView:self.snapView];
        UIImage *smallImage = [UIImage compressImage:image toByte:32];
        [message setThumbImage:smallImage];
        WXImageObject *imageObiect = [WXImageObject object];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        imageObiect.imageData = imageData;
        message.mediaObject = imageObiect;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    } else {
        [WWHUD showMessage:@"您没安装微信" inView:self.view];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo {
    WEAK_SELF;
    if (image) {
            self.sucView = [[WWShareSucceedView alloc]init];
            self.sucView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2,([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80);
            [self.view addSubview:self.sucView];
            [self.sucView processSucceed];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.sucView removeFromSuperview];
                for (UIView* view in weakSelf.view.subviews) {
                    if ([[view class] isSubclassOfClass:[WWShareSucceedView class]]) {
                        [view removeFromSuperview];
                    }
                }
            });
    }else {
        [WWHUD showMessage:@"保存失败！" inView:self.view];
    }
}

#pragma mark - 响应方法
-(UIImage*)captureView: (UIView *)theView {
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:NO];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 懒加载
- (UILabel *)yearsNum {
    if (_yearsNum == nil) {
        _yearsNum = [[UILabel alloc]init];
        _yearsNum.textColor = [UIColor whiteColor];
        _yearsNum.font = [UIFont fontWithName:kFont_DINAlternate size:32*screenRate];
        _yearsNum.text = [NSString stringWithFormat:@"TO %ld",self.age];
    }
    return _yearsNum;
}

- (UILabel *)yearsLabel {
    if (_yearsLabel == nil) {
        _yearsLabel = [[UILabel alloc]init];
        _yearsLabel.textColor = [UIColor whiteColor];
        _yearsLabel.font = [UIFont fontWithName:kFont_DINAlternate size:32*screenRate];
        _yearsLabel.text = @"YEARS OLD";
    }
    return _yearsLabel;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"bacBackBtn"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 10, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"不必";
    }
    return _nav;
}

- (WWShareView *)shareView {
    if (!_shareView) {
        _shareView = [[WWShareView alloc]initWithFrame:CGRectMake(0, KHeight - 49, KWidth, 49)];
        [_shareView.download addTarget:self action:@selector(dowloadClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.weChat addTarget:self action:@selector(weixinClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.moment addTarget:self action:@selector(momentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareView;
}

- (UIView *)snapView {
    if (_snapView == nil) {
        _snapView = [[UIView alloc]init];
        _snapView.backgroundColor = viewBackGround_Color;
    }
    return _snapView;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
