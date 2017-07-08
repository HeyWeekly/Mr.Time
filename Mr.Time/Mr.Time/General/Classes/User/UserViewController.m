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
#import "WWSettingVC.h"
#import "WWMessageDetailVCViewController.h"
#import "WWCollectButton.h"

#define CELL_IDENTITY @"myCell"

@protocol userPublishCellDelegate <NSObject>
- (void)userCellLike;
@end

@interface userPublishCell : UITableViewCell
@property (nonatomic, strong) UIImageView *yearsImage;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic,  weak) id <userPublishCellDelegate> delegate;
@end


@interface UserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MYCollectionViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UIButton  *notice;
@property(nonatomic, strong) UIButton  *setting;
@property(nonatomic, strong) UIButton  *backheadImage;
@property(nonatomic, strong) UIImageView  *headImage;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) UILabel *yearLbael;
@property(nonatomic,strong) MYCollectionView *myCollectionView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) UILabel *collected;
@property (nonatomic, strong) UILabel *collectedNum;
@property (nonatomic, strong) UIView *sepLine1;
@property (nonatomic, strong) UILabel *recorded;
@property (nonatomic, strong) UILabel *recordedNum;
@property (nonatomic, strong) UIView *sepLine2;
@property (nonatomic, strong) UILabel *likeded;
@property (nonatomic, strong) UILabel *likedNum;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    self.backheadImage.left = 25*screenRate;
    self.backheadImage.top = 50*screenRate;
    [self.backheadImage sizeToFit];
    
    [self.view addSubview:self.setting];
    [self.setting sizeToFit];
    self.setting.right = self.view.bounds.size.width-25*screenRate;
    self.setting.top = self.backheadImage.top;
    
    [self.view addSubview:self.notice];
    [self.notice sizeToFit];
    self.notice.right = self.setting.left - 35*screenRate;;
    self.notice.top = self.backheadImage.top;
    
    [self.view addSubview:self.nameLbael];
    [self.nameLbael sizeToFit];
    self.nameLbael.left = self.backheadImage.right+22*screenRate;;
    self.nameLbael.top = self.backheadImage.top;
    
    [self.view addSubview:self.yearLbael];
    [self.yearLbael sizeToFit];
    self.yearLbael.left = self.nameLbael.left;
    self.yearLbael.top = self.nameLbael.bottom+8*screenRate;
    
    [self.view addSubview:self.collectedNum];
    [self.collectedNum sizeToFit];
    self.collectedNum.right = self.view.bounds.size.width - 23*screenRate;
    self.collectedNum.top = self.setting.bottom+73*screenRate;
    
    [self.view addSubview:self.collected];
    [self.collected sizeToFit];
    self.collected.right = self.collectedNum.right;
    self.collected.top = self.collectedNum.bottom+6*screenRate;
    [self.view addSubview:self.sepLine1];
    [self.sepLine1 sizeToFit];
    self.sepLine1.right = self.collected.left - 15*screenRate;
    self.sepLine1.top = self.collectedNum.top + 3*screenRate;
    self.sepLine1.width = 1;
    self.sepLine1.height = 30*screenRate;
    
    [self.view addSubview:self.recordedNum];
    [self.recordedNum sizeToFit];
    self.recordedNum.right = self.sepLine1.left - 15*screenRate;
    self.recordedNum.top = self.collectedNum.top;
    [self.view addSubview:self.recorded];
    [self.recorded sizeToFit];
    self.recorded.right = self.recordedNum.right;
    self.recorded.top = self.recordedNum.bottom+6*screenRate;
    [self.view addSubview:self.sepLine2];
    [self.sepLine2 sizeToFit];
    self.sepLine2.right = self.recorded.left - 15*screenRate;
    self.sepLine2.top = self.recordedNum.top + 3*screenRate;
    self.sepLine2.width = 1;
    self.sepLine2.height = 30*screenRate;
    
    [self.view addSubview:self.likedNum];
    [self.likedNum sizeToFit];
    self.likedNum.right = self.sepLine2.left - 15*screenRate;
    self.likedNum.top = self.collectedNum.top;
    [self.view addSubview:self.likeded];
    [self.likeded sizeToFit];
    self.likeded.right = self.likedNum.right;
    self.likeded.top = self.likedNum.bottom+6*screenRate;
    
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
- (void)setClick {
    WWSettingVC *vc = [[WWSettingVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPublishCell"];
    if (!cell) {
        cell = [[userPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPublishCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.likeNum.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215*screenRate;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
    for (userPublishCell *cell in [self.tableView visibleCells]) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewHeight / 2;
        CGFloat scale = cos(p / viewHeight * 0.8) * 0.95;
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                cell.containerView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:NULL];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20*screenRate, self.backheadImage.bottom+29*screenRate, KWidth-40*screenRate, KHeight-self.backheadImage.bottom+29*screenRate-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
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
        _yearLbael.textColor = RGBCOLOR(0x545454);
        _yearLbael.layer.shadowColor = [UIColor blackColor].CGColor;
        _yearLbael.layer.shadowOpacity = 0.6;
        _yearLbael.layer.shadowRadius = 10;
        _yearLbael.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _yearLbael;
}
- (UILabel *)nameLbael {
    if (_nameLbael == nil) {
        _nameLbael = [[UILabel alloc]init];
        _nameLbael.text = @"王二黑";
        _nameLbael.textAlignment = NSTextAlignmentCenter;
        _nameLbael.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _nameLbael.textColor = [UIColor whiteColor];
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
        [_setting addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
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
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(33*screenRate, 60*screenRate, 55*screenRate, 55*screenRate)];
        _headImage.image = [UIImage imageNamed:@"dasdasdas"];
        _headImage.clipsToBounds = YES;
    }
    return _headImage;
}
- (UILabel *)collected {
    if (!_collected) {
        _collected = [[UILabel alloc]init];
        _collected.text = @"已收藏";
        _collected.textAlignment = NSTextAlignmentLeft;
        _collected.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _collected.textColor = RGBCOLOR(0x94A3AD);
    }
    return _collected;
}
- (UILabel *)collectedNum {
    if (!_collectedNum) {
        _collectedNum = [[UILabel alloc]init];
        _collectedNum.text = @"320";
        _collectedNum.textAlignment = NSTextAlignmentLeft;
        _collectedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _collectedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _collectedNum;
}
- (UIView *)sepLine1 {
    if (_sepLine1 == nil) {
        _sepLine1 = [[UIView alloc]init];
        _sepLine1.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepLine1;
}
- (UILabel *)recorded {
    if (!_recorded) {
        _recorded = [[UILabel alloc]init];
        _recorded.text = @"已记录";
        _recorded.textAlignment = NSTextAlignmentLeft;
        _recorded.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _recorded.textColor = RGBCOLOR(0x94A3AD);
    }
    return _recorded;
}
- (UILabel *)recordedNum {
    if (!_recordedNum) {
        _recordedNum = [[UILabel alloc]init];
        _recordedNum.text = @"20";
        _recordedNum.textAlignment = NSTextAlignmentLeft;
        _recordedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _recordedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _recordedNum;
}
- (UIView *)sepLine2 {
    if (_sepLine2 == nil) {
        _sepLine2 = [[UIView alloc]init];
        _sepLine2.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepLine2;
}
- (UILabel *)likeded {
    if (!_likeded) {
        _likeded = [[UILabel alloc]init];
        _likeded.text = @"已被收藏";
        _likeded.textAlignment = NSTextAlignmentLeft;
        _likeded.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _likeded.textColor = RGBCOLOR(0x94A3AD);
    }
    return _likeded;
}
- (UILabel *)likedNum {
    if (!_likedNum) {
        _likedNum = [[UILabel alloc]init];
        _likedNum.text = @"1,299";
        _likedNum.textAlignment = NSTextAlignmentLeft;
        _likedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _likedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _likedNum;
}
- (void)drawRect {
    float viewWidth = 55*screenRate;
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
    
    [self.containerView addSubview:self.likeImage];
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left-5*screenRate;
    self.likeImage.top = 19*screenRate;
    
    [self.contentLabel sizeToFit];
    self.contentLabel.left = 25*screenRate;
    self.contentLabel.top = self.yearsImage.bottom+15.5*screenRate;
    self.contentLabel.width = self.containerView.width - 50*screenRate;
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];
    
    self.containerView.height = self.contentLabel.bottom+27*screenRate;
    [self addSubview:self.containerView];
}
- (void)favoClick {
    self.islike = !self.islike;
    if (self.islike) {
        [self.likeImage setFavo:YES withAnimate:YES];
    }else {
        [self.likeImage setFavo:NO withAnimate:YES];
    }
}
-  (UIImageView *)yearsImage {
    if (_yearsImage == nil) {
        _yearsImage = [[UIImageView alloc]init];
        _yearsImage.image = [UIImage imageNamed:@"21yearsOld"];
    }
    return _yearsImage;
}
- (WWCollectButton *)likeImage {
    if (_likeImage == nil) {
        _likeImage = [[WWCollectButton alloc]init];
        _likeImage.contentMode = UIViewContentModeCenter;
        _likeImage.favoType = 2;
        [_likeImage addTarget:self action:@selector(favoClick) forControlEvents:UIControlEventTouchUpInside];
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
