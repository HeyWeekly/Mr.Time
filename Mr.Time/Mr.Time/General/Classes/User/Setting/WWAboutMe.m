//
//  WWAboutMe.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/10/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWAboutMe.h"

@interface WWAboutMe ()
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *introDetailLabel;
@property (nonatomic, strong) UILabel *teamIntroLabel;
@property (nonatomic, strong) UIButton *cat;
@end


@implementation WWAboutMe

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0];
    
    self.teamIntroLabel.frame = CGRectMake(0, 30, KWidth, 40);
    [self.view addSubview:self.teamIntroLabel];
    self.introDetailLabel.frame = CGRectMake(30, self.teamIntroLabel.bounds.size.height + self.teamIntroLabel.bounds.origin.y + 75, KWidth - 60, KHeight - (self.teamIntroLabel.bounds.size.height + self.teamIntroLabel.bounds.origin.y + 75) - 150 );
    [self.view addSubview:self.introDetailLabel];
    [self.introDetailLabel sizeToFit];
    [self.view addSubview:self.closeBtn];
    self.cat.frame = CGRectMake(250, 150, 45, 45);
    [self.view addSubview:self.cat];
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc]init];
        _closeBtn.frame = CGRectMake(self.view.bounds.size.width/2-25, KHeight-100, 60,60);
        [_closeBtn setBackgroundColor:[UIColor whiteColor]];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorWithRed:(41)/255.0 green:(41)/255.0 blue:(41)/255.0 alpha:1.0] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _closeBtn.layer.cornerRadius = 30;
        _closeBtn.clipsToBounds = YES;
        [_closeBtn addTarget:self action:@selector(aboutMeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)cat {
    if (_cat == nil) {
        _cat = [[UIButton alloc]init];
        [_cat setImage:[UIImage imageNamed:@"catbtn"] forState:UIControlStateNormal];
        _cat.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _cat.layer.cornerRadius = 22.5;
        _cat.clipsToBounds = YES;
    }
    return _cat;
}

- (UILabel *)introDetailLabel {
    if (_introDetailLabel == nil) {
        _introDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _introDetailLabel.text = @"后端：bless\n\n产品：不听懂                 -->\n纪念一只叫大王的暹罗  -->\n\n设计：Jsaon\n\n程序员：王二黑\n微信：WALL-Emumu\n电子邮箱：steaest@gmail.com\n离职状态，求勾搭☺\n\n\n\n\n\n\n\n\n                       一群没梦想的咸鱼" ;
        _introDetailLabel.textColor = [UIColor whiteColor];
        _introDetailLabel.numberOfLines = 0;
        _introDetailLabel.font = [UIFont systemFontOfSize:16];
    }
    return _introDetailLabel;
}

- (UILabel *)teamIntroLabel {
    if (_teamIntroLabel == nil) {
        _teamIntroLabel = [[UILabel alloc]init];
        _teamIntroLabel.text = @"制作团队";
        _teamIntroLabel.textAlignment = NSTextAlignmentCenter;
        _teamIntroLabel.textColor = [UIColor whiteColor];
        _teamIntroLabel.font = [UIFont systemFontOfSize:20];
    }
    return _teamIntroLabel;
}

- (void)aboutMeClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
