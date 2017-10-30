//
//  WWCardSlideCell.m
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCardSlideCell.h"
#import "WWCollectButton.h"
#import "WWHomeBookModel.h"

@interface WWCardSlideCell ()
@property (nonatomic, strong) UILabel *yearsNum;
@property (nonatomic, strong) UILabel *yearsLabel;
@property (nonatomic, strong) UILabel *oldLabel;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation WWCardSlideCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = true;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        self.islike = NO;
    }
    return self;
}

-(void)setupSubViews {
    [self addSubview:self.imageView];
    [self.imageView sizeToFit];
    self.imageView.left = 0;
    self.imageView.top = 0;
    
    [self addSubview:self.yearsNum];
    [self.yearsNum sizeToFit];
    self.yearsNum.left = 25*screenRate;
    self.yearsNum.top = 10*screenRate;
    
    [self addSubview:self.yearsLabel];
    [self.yearsLabel sizeToFit];
    self.yearsLabel.left = self.yearsNum.left;
    self.yearsLabel.top = self.yearsNum.bottom;
    
    [self addSubview:self.oldLabel];
    [self.oldLabel sizeToFit];
    self.oldLabel.left = self.yearsNum.left;
    self.oldLabel.top = self.yearsLabel.bottom;
    
    [self addSubview:self.moreBtn];
    [self.moreBtn sizeToFit];
    self.moreBtn.right = self.bounds.size.width - 20*screenRate;
    self.moreBtn.top = 23*screenRate;
    
    [self addSubview:self.likeImage];
    [self.likeImage sizeToFit];
    self.likeImage.right = self.moreBtn.left - 15*screenRate;
    self.likeImage.top = 20*screenRate;
    [self.likeImage sizeToFit];
    [self.likeImage addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentLabel.top = self.imageView.bottom;
    self.contentLabel.left = 25*screenRate;
    self.contentLabel.width = self.bounds.size.width - 50*screenRate;
    [self addSubview:self.contentLabel];
    
    self.textLabel.top = 378*screenRate;
    self.textLabel.left = 25*screenRate;
    self.textLabel.width = self.bounds.size.width - 50*screenRate;
    self.textLabel.height = 20*screenRate;
    [self addSubview:self.textLabel];
}

-(void)setModel:(WWHomeBookModel *)model {
    _model = model;
    int ages = model.age.intValue/10;
    NSString *year = [NSString stringWithFormat:@"%d",ages];
    self.imageView.image = [UIImage imageNamed:[@"contentYearBg" stringByAppendingString:year]];
    if (model.age.integerValue >= 100) {
        self.imageView.image = [UIImage imageNamed:@"contentYearBg9"];
    }
    if (model.enshrined.integerValue > 0) {
        [self.likeImage setFavo:YES withAnimate:NO];
        self.islike = YES;
    }else {
        [self.likeImage setFavo:NO withAnimate:NO];
        self.islike = NO;
    }
    self.yearsNum.text = model.age;
    [self.yearsNum sizeToFit];
    
    NSString *strText = model.content;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:strText attributes:@{NSForegroundColorAttributeName : RGBCOLOR(0x39454E), NSParagraphStyleAttributeName: paragraphStyle}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_SemiBold size:27*screenRate] range:NSMakeRange(0, 1)];
    self.contentLabel.attributedText = text;
    [self.contentLabel sizeToFit];
    self.contentLabel.top = self.imageView.bottom;
    self.contentLabel.left = 25*screenRate;
    self.contentLabel.width = self.bounds.size.width - 50*screenRate;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"—— 来自 %@岁 的 %@" ,model.authorAge,model.nickname]];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(6,model.authorAge.length+1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(6, model.authorAge.length+1)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0x50616E) range:NSMakeRange(12,model.nickname.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_DINAlternate size:14*screenRate] range:NSMakeRange(12, model.nickname.length)];
    self.textLabel.attributedText = str;
}

- (void)moreClick {
    if ([self.delegate respondsToSelector:@selector(moreClickAid:withContnet:)]) {
        [self.delegate moreClickAid:self.model.aid withContnet:self.model.content];
    }
}

- (void)likeClick {
    self.islike = !self.islike;
    if (self.islike) {
        [self.likeImage setFavo:YES withAnimate:YES];
    }else {
        [WWHUD showMessage:@"暂不支持取消哟~" inView:self];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bookCellLikeIndex:)]) {
        [self.delegate bookCellLikeIndex:self.model.aid.integerValue];
    }
}

- (UILabel *)yearsNum {
    if (_yearsNum == nil) {
        _yearsNum = [[UILabel alloc]init];
        _yearsNum.textColor = [UIColor whiteColor];
        _yearsNum.font = [UIFont fontWithName:kFont_DINAlternate size:72*screenRate];
        _yearsNum.text = @"25";
    }
    return _yearsNum;
}

- (UILabel *)yearsLabel {
    if (_yearsLabel == nil) {
        _yearsLabel = [[UILabel alloc]init];
        _yearsLabel.textColor = [UIColor whiteColor];
        _yearsLabel.font = [UIFont fontWithName:kFont_DINAlternate size:20*screenRate];
        _yearsLabel.text = @"YEARS";
    }
    return _yearsLabel;
}

- (UILabel *)oldLabel {
    if (_oldLabel == nil) {
        _oldLabel = [[UILabel alloc]init];
        _oldLabel.textColor = [UIColor whiteColor];
        _oldLabel.font = [UIFont fontWithName:kFont_DINAlternate size:20*screenRate];
        _oldLabel.text = @"OLD";
    }
    return _oldLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"contentYearBg9"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel ) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = RGBCOLOR(0x94A3AE);
        _textLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentRight;
        _textLabel.adjustsFontSizeToFitWidth = true;
    }
    return _textLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(0x39454E);
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _contentLabel.numberOfLines = 7;
        _contentLabel.adjustsFontSizeToFitWidth = true;
    }
    return _contentLabel;
}

- (WWCollectButton *)likeImage {
    if (!_likeImage) {
        _likeImage = [[WWCollectButton alloc] init];
        _likeImage.imageView.contentMode = UIViewContentModeCenter;
        _likeImage.favoType = 1;
    }
    return _likeImage;
}

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc]init];
        [_moreBtn setImage:[UIImage imageNamed:@"More"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}


@end
