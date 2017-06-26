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
@end

@implementation WWMessageDetailVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}
#pragma mark - 视图
-(void)setupSubViews {
    [self.view addSubview:self.nav];
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 10.0f;
    self.containerView.top = self.nav.bottom+10*screenRate;
    self.containerView.left = 20*screenRate;
    self.containerView.width = KWidth - 40*screenRate;
    self.containerView.height = 525*screenRate;
    [self.view addSubview:self.containerView];
    
    //背景
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"notwhere"];
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
    
    //名称
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = RGBCOLOR(0x94A3AE);
    _textLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
    _textLabel.numberOfLines = 1;
    _textLabel.adjustsFontSizeToFitWidth = true;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"—— 来自 50岁 的 Punk奶奶"];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(6,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(6, 3)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(12,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(12, 6)];
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
    NSString *strText = @"此刻正在阅读这封信的你身在何方，在做些什么？十五岁的我，怀揣着无法向任何人述说的烦恼的种子，我有话要对十五岁的你说，是否就能将一切诚实地坦露，问问自己到底自己为什么不够一切的爱上一个人，爱的那么轰轰烈烈，没有任何负担的全身心投入";
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:strText attributes:@{NSForegroundColorAttributeName : RGBCOLOR(0x39454E), NSParagraphStyleAttributeName: paragraphStyle}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_SemiBold size:27*screenRate] range:NSMakeRange(0, 1)];
    _contentLabel.attributedText = text;
    [_contentLabel sizeToFit];
    _contentLabel.bottom = 228*screenRate;
    _contentLabel.left = 25*screenRate;
    _contentLabel.width = self.containerView.bounds.size.width - 50*screenRate;
    [self.containerView addSubview:_contentLabel];
    [_contentLabel sizeToFit];
    [self.view addSubview:self.shareView];
}
#pragma mark - 点击事件
- (void)likeClick {
    self.islike = !self.islike;
    if (self.islike) {
        [self.likeImage setFavo:YES withAnimate:YES];
    }else {
        [self.likeImage setFavo:NO withAnimate:YES];
    }
}
- (void)dowloadClick {
    UIImage *image = [self captureView:self.containerView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo {
    if (image) {
            self.sucView = [[WWShareSucceedView alloc]init];
            self.sucView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2,([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80);
            [self.view addSubview:self.sucView];
            [self.sucView processSucceed];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.sucView removeFromSuperview];
                for (UIView* view in self.view.subviews) {
                    if ([[view class] isSubclassOfClass:[WWShareSucceedView class]]) {
                        [view removeFromSuperview];
                    }
                }
            });
    }else {
        NSLog(@"失败");
    }
}
#pragma mark - 响应方法
-(UIImage*)captureView: (UIView *)theView {
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, theView.opaque, 0.0);
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
        _yearsNum.text = @"TO 25";
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
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = @"不必";
    }
    return _nav;
}
- (WWShareView *)shareView {
    if (!_shareView) {
        _shareView = [[WWShareView alloc]initWithFrame:CGRectMake(0, KHeight - 49, KWidth, 49)];
        [_shareView.download addTarget:self action:@selector(dowloadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareView;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
