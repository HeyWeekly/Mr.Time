//
//  UserViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "UserViewController.h"
#import "QQLineFlowLayout.h"
#import "QQEngine.h"
#import "MYCollectionView.h"

@interface userPublishCell : UITableViewCell
@property (nonatomic, strong) UIImageView *yearsImage;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *containerView;
@end


@interface UserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UIButton  *notice;
@property(nonatomic, strong) UIButton  *setting;
@property(nonatomic, strong) UIButton  *backheadImage;
@property(nonatomic, strong) UIImageView  *headImage;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) UILabel *yearLbael;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) MYCollectionView *myCollectionView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation UserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self setupViews];
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = KHeight - 100;
    _fpsLabel.left = 12;
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
}
- (void)setupViews {
    [self.view addSubview:self.headImage];
    [self drawRect];
    [self.view addSubview:self.backheadImage];
    [self.backheadImage sizeToFit];
    self.backheadImage.centerX = self.view.centerX;
    self.backheadImage.top = 41*screenRate;
    [self.backheadImage sizeToFit];
    [self.view addSubview:self.notice];
    self.notice.left = 58*screenRate;;
    self.notice.top = 75 *screenRate;
    [self.notice sizeToFit];
    [self.view addSubview:self.setting];
    self.setting.left = self.backheadImage.right+56*screenRate;
    self.setting.top = self.notice.top;
    [self.setting sizeToFit];
    [self.view addSubview:self.nameLbael];
    [self.nameLbael sizeToFit];
    self.nameLbael.centerX = self.view.centerX;
    self.nameLbael.top = self.backheadImage.bottom+10*screenRate;
    [self.view addSubview:self.yearLbael];
    [self.yearLbael sizeToFit];
    self.yearLbael.centerX = self.view.centerX;
    self.yearLbael.top = self.nameLbael.bottom+20;
    [self.view addSubview:self.tableView];
}

#pragma mark - target
- (void)headImageClick {
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.allowsEditing = YES;
    pic.delegate = self;
    [self presentViewController:pic animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {return;}
    self.headImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPublishCell"];
    if (!cell) {
        cell = [[userPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPublishCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220*screenRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20*screenRate, self.yearLbael.bottom+25*screenRate, KWidth-40*screenRate, KHeight-self.yearLbael.bottom+25*screenRate-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = viewBackGround_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UILabel *)yearLbael {
    if (_yearLbael == nil) {
        _yearLbael = [[UILabel alloc]init];
        _yearLbael.text = @"1991.10.18";
        _yearLbael.textAlignment = NSTextAlignmentCenter;
        _yearLbael.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _yearLbael.textColor = [UIColor whiteColor];
    }
    return _yearLbael;
}
- (UILabel *)nameLbael {
    if (_nameLbael == nil) {
        _nameLbael = [[UILabel alloc]init];
        _nameLbael.text = @"王二黑";
        _nameLbael.textAlignment = NSTextAlignmentCenter;
        _nameLbael.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _nameLbael.textColor = RGBCOLOR(0x545454);
    }
    return _nameLbael;
}
- (UIButton *)notice {
    if (_notice == nil) {
        _notice = [[UIButton alloc]init];
        [_notice setImage:[UIImage imageNamed:@"Noticeicon"] forState:UIControlStateNormal];
        _notice.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _notice;
}
- (UIButton *)setting {
    if (_setting == nil) {
        _setting = [[UIButton alloc]init];
        [_setting setImage:[UIImage imageNamed:@"Setting icon"] forState:UIControlStateNormal];
        _setting.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _setting;
}
- (UIButton *)backheadImage {
    if (_backheadImage == nil) {
        _backheadImage = [[UIButton alloc]init];
        [_backheadImage setImage:[UIImage imageNamed:@"headbackground"] forState:UIControlStateNormal];
        _backheadImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backheadImage addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backheadImage;
}
- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(144*screenRate, 45*screenRate, 89*screenRate, 89*screenRate)];
        _headImage.image = [UIImage imageNamed:@"dasdasdas"];
        _headImage.clipsToBounds = YES;
    }
    return _headImage;
}
- (void)drawRect {
    float viewWidth = 89*screenRate;
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [[UIColor whiteColor] setStroke];
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    [path closePath];
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.lineWidth = 2;
    shapLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapLayer.path = path.CGPath;
    _headImage.layer.mask = shapLayer;
}

#pragma mark - 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


@implementation userPublishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = viewBackGround_Color;
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    self.containerView.width = KWidth - 40*screenRate;
    [self.yearsImage sizeToFit];
    self.yearsImage.left = 20*screenRate;
    self.yearsImage.top = 11.5*screenRate;
    [self.containerView addSubview:self.yearsImage];
    
    [self.likeNum sizeToFit];
    self.likeNum.right = self.containerView.width-25*screenRate;
    self.likeNum.top = 26.5*screenRate;
    [self.containerView addSubview:self.likeNum];
    
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left-5*screenRate;
    self.likeImage.top = 28*screenRate;
    [self.containerView addSubview:self.likeImage];
    
    [self.contentLabel sizeToFit];
    self.contentLabel.left = 25*screenRate;
    self.contentLabel.top = self.yearsImage.bottom+15.5*screenRate;
    self.contentLabel.width = self.containerView.width - 50*screenRate;
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];
    
    self.containerView.height = self.contentLabel.bottom+27*screenRate;
    [self addSubview:self.containerView];
}
-  (UIImageView *)yearsImage {
    if (_yearsImage == nil) {
        _yearsImage = [[UIImageView alloc]init];
        _yearsImage.image = [UIImage imageNamed:@"21yearsOld"];
    }
    return _yearsImage;
}
- (UIImageView *)likeImage {
    if (_likeImage == nil) {
        _likeImage = [[UIImageView alloc]init];
        _likeImage.image = [UIImage imageNamed:@"userlike"];
    }
    return _likeImage;
}
- (UILabel *)likeNum {
    if (_likeNum == nil) {
        _likeNum = [[UILabel alloc]init];
        _likeNum.text = @"1,3445";
        _likeNum.textColor = RGBCOLOR(0x94A3AD);
        _likeNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
    }
    return _likeNum;
}
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        NSString *text =@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信";
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : RGBCOLOR(0x39454E), NSParagraphStyleAttributeName: paragraphStyle}];
        _contentLabel.attributedText = string;
        _contentLabel.numberOfLines = 4;
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
    }
    return _contentLabel;
}
- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8*screenRate;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}
@end
