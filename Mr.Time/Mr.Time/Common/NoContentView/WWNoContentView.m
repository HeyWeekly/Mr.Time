//
//  WWNoContentView.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/15.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWNoContentView.h"

@interface WWNoContentView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *bottomLabel;
@end

@implementation WWNoContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = viewBackGround_Color;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    self.topLabel = [[UILabel alloc]init];
    [self addSubview:self.topLabel];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.textColor = [UIColor redColor];
    
    self.bottomLabel = [[UILabel alloc]init];
    [self addSubview:self.bottomLabel];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = [UIFont systemFontOfSize:15];
    self.bottomLabel.textColor = [UIColor yellowColor];
    
    [self.imageView sizeToFit];
    self.imageView.left = 110*screenRate;
    self.imageView.top  = 90*screenRate;
    
    [self.topLabel sizeToFit];
    self.topLabel.top = self.imageView.bottom + 5*screenRate;
    self.topLabel.centerX = self.centerX;
    
    self.bottomLabel.top = self.topLabel.bottom + 5*screenRate;
    self.bottomLabel.centerX = self.centerX;
}

#pragma mark - 根据传入的值创建相应的UI
/** 根据传入的值创建相应的UI */
- (void)setType:(NSInteger)type{
    switch (type) {
            
        case NoContentTypeNetwork: // 没网
        {
            [self setImage:@"网络异常" topLabelText:@"貌似没有网络" bottomLabelText:@"点击重试"];
        }
            break;
            
        case NoContentTypeData:
        {
            [self setImage:@"usernoData" topLabelText:nil bottomLabelText:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置图片和文字
/** 设置图片和文字 */
- (void)setImage:(NSString *)imageName topLabelText:(NSString *)topLabelText bottomLabelText:(NSString *)bottomLabelText{
    self.imageView.image = [UIImage imageNamed:imageName];
    self.topLabel.text = topLabelText;
    self.bottomLabel.text = bottomLabelText;
    [self.imageView sizeToFit];
    [self.topLabel sizeToFit];
    [self.bottomLabel sizeToFit];
}
@end
