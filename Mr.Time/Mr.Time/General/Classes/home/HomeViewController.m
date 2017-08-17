//
//  HomeViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "HomeViewController.h"
#import "WWPublishVC.h"
#import <YYText/YYText.h>
#import "WWLabel.h"
#import "GCD.h"
#import "POP.h"
#import "SDCycleScrollView.h"

@interface HomeYearsCell :UICollectionViewCell
@property (nonatomic,strong) UILabel *yearsNum;
@property (nonatomic,strong) UILabel *yearLbael;
@end

@interface HomeViewController ()<SDCycleScrollViewDelegate>{
    SDCycleScrollView* _bannerView;
}
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIButton *puslishBtn;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

#define totalColumns 10

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = KHeight - 100;
    _fpsLabel.left = 12;
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    NSArray *imagesURLStrings = @[@"",@""];
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(105*screenRate, 40, 175*screenRate, 140*screenRate) delegate:self placeholderImage:nil];
    _bannerView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    _bannerView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    _bannerView.imageURLStringsGroup = imagesURLStrings;
    _bannerView.autoScroll = NO;
    [self.view addSubview:_bannerView];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.puslishBtn];
    [self.puslishBtn sizeToFit];
    self.puslishBtn.centerX = self.view.centerX;
    self.puslishBtn.bottom = self.view.bottom - 10*screenRate - 49;
    
    [self creatBackView];
    [self creatYearsView];
}

- (void)creatBackView {
    CGFloat cellW = 12*screenRate;
    CGFloat cellH = 12*screenRate;
    CGFloat margin =19*screenRate;
    for(int index = 0; index< 100; index++) {
        UIView *cellView = [[UIView alloc ]init ];
        cellView.backgroundColor = RGBCOLOR(0x404040);
        // 计算行号 & 列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定子控件的坐标
        CGFloat cellX = 44*screenRate + col * (cellW + margin);
        CGFloat cellY = 197*screenRate+row * (cellH + margin);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        // 添加到view中
        [self.view addSubview:cellView];
    }
}

- (void)creatYearsView {
    CGFloat cellW2 = 22*screenRate;
    CGFloat cellH2 = 22*screenRate;
    CGFloat margin2 =9*screenRate;
    
    for(int index = 0; index< [WWUserModel shareUserModel].yearDay.integerValue; index++) {
        UIView *cellView = [[UIView alloc ]init ];
        cellView.layer.shadowColor = RGBCOLOR(0x27ECCC).CGColor;
        cellView.layer.shadowOpacity = 0.35;
        cellView.layer.shadowRadius = 6;
        cellView.layer.shadowOffset = CGSizeMake(1, 1);
        cellView.layer.cornerRadius = 4;
        cellView.clipsToBounds = YES;
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = 39*screenRate + col * (cellW2 + margin2);
        CGFloat cellY = 192*screenRate+row * (cellH2 + margin2);
        cellView.frame = CGRectMake(cellX, cellY, cellW2, cellH2);
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(0.9, 0.9);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(cellView.frame), CGRectGetHeight(cellView.frame));
        if (index == 24) {
            gradientLayer.colors = @[(__bridge id)RGBCOLOR(0x27EBCD).CGColor,(__bridge id)RGBCOLOR(0x16C3FE).CGColor];
        }else if(index >= 0+row*10 && index <= row*10+3 ){
            gradientLayer.backgroundColor = [UIColor colorWithRed:0/255.0 green:255/255.0 blue:213/255.0 alpha:1].CGColor;
        }else if(index >=4+row*10 && index <= row*10+5 ){
            gradientLayer.backgroundColor = [UIColor colorWithRed:0/255.0 green:246/255.0 blue:239/255.0 alpha:1].CGColor;
        }else if(index >= 6+row*10 && index <= row*10+9 ){
            gradientLayer.backgroundColor = [UIColor colorWithRed:0/255.0 green:241/255.0 blue:255/255.0 alpha:1].CGColor;
        }
        [cellView.layer addSublayer:gradientLayer];
        // 添加到view 中
        [self.view addSubview:cellView];
        if (index == [WWUserModel shareUserModel].yearDay.integerValue-1) {
            self.animationView = cellView;
            [GCDQueue executeInMainQueue:^{
                [self scaleAnimation];
            } afterDelaySecs:1.f];
        }
    }
}

//心跳动画
- (void)scaleAnimation {
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.name               = @"scaleSmallAnimation";
    scaleAnimation.delegate           = self;
    scaleAnimation.duration           = 0.25f;
    scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(1.15, 1.15)];
    [self.animationView pop_addAnimation:scaleAnimation forKey:nil];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ([anim.name isEqualToString:@"scaleSmallAnimation"]) {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.name                = @"SpringAnimation";
        scaleAnimation.delegate            = self;
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(-2, -2)];
        scaleAnimation.springBounciness    = 20.f;
        scaleAnimation.springSpeed         = 15.f;
        scaleAnimation.dynamicsTension     = 600.f;
        scaleAnimation.dynamicsFriction    = 22.f;
        scaleAnimation.dynamicsMass        = 2.f;
        [self.animationView pop_addAnimation:scaleAnimation forKey:nil];
    } else if ([anim.name isEqualToString:@"SpringAnimation"]) {
        [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:1];
    }
}

#pragma mark - delegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _bannerView) {
        return nil;
    }
    return [HomeYearsCell class];
}
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    HomeYearsCell *myCell = (HomeYearsCell *)cell;
    if (index == 0) {
        myCell.yearsNum.text = [WWUserModel shareUserModel].yearDay;
        myCell.yearLbael.text = @"YEARS OLD";
    }else if (index == 1){
        myCell.yearsNum.text = [WWUserModel shareUserModel].dataStr;
        myCell.yearLbael.text = @"DAY";
    }
}

#pragma mark - 点击事件
- (void)publishBtnClick {
    WWPublishVC *publishVC = [[WWPublishVC alloc]initWithYear:[WWUserModel shareUserModel].yearDay.integerValue andIsPublish:YES];
    [self.navigationController pushViewController:publishVC animated:YES];
}

#pragma mark - lazyLoad
- (UIButton *)puslishBtn {
    if (_puslishBtn == nil) {
        _puslishBtn = [[UIButton alloc]init];
        [_puslishBtn setImage:[UIImage imageNamed:@"homePublish"] forState:UIControlStateNormal];
        [_puslishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _puslishBtn;
}

@end


@implementation HomeYearsCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.yearsNum];
        [self.yearsNum sizeToFit];
        self.yearsNum.left = 0;
        self.yearsNum.top = 5;
        [self addSubview:self.yearLbael];
        [self.yearLbael sizeToFit];
        self.yearLbael.centerX = self.yearsNum.centerX;
        self.yearLbael.top = self.yearsNum.bottom;
    }
    return self;
}

- (UILabel *)yearLbael {
    if (_yearLbael == nil) {
        _yearLbael = [[UILabel alloc]init];
        _yearLbael.text = @"YEARS OLD";
        _yearLbael.textAlignment = NSTextAlignmentCenter;
        _yearLbael.font = [UIFont fontWithName:kFont_DINAlternate size:21*screenRate];
        _yearLbael.textColor = RGBCOLOR(0x545454);
    }
    return _yearLbael;
}

- (UILabel *)yearsNum {
    if (_yearsNum == nil) {
        _yearsNum = [[UILabel alloc]init];
        _yearsNum.textAlignment = NSTextAlignmentCenter;
        _yearsNum.text = @"9,9999";
        _yearsNum.font = [UIFont fontWithName:kFont_DINAlternate size:66*screenRate];
        _yearsNum.textColor = [UIColor whiteColor];
        _yearsNum.layer.shadowColor = [UIColor blackColor].CGColor;
        _yearsNum.layer.shadowOpacity = 0.5;
        _yearsNum.layer.shadowRadius = 10;
        _yearsNum.layer.shadowOffset = CGSizeMake(0, 8*screenRate);
    }
    return _yearsNum;
}

@end
