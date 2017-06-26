//
//  WWCardSlideCell.m
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCardSlideCell.h"
#import "WWCollectButton.h"

@interface WWCardSlideCell ()
{
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_contentLabel;
    
}
@property (nonatomic, strong) UILabel *yearsNum;
@property (nonatomic, strong) UILabel *yearsLabel;
@property (nonatomic, strong) UILabel *oldLabel;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, assign) BOOL islike;
@end

@implementation WWCardSlideCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.islike = NO;
    }
    return self;
}

-(void)setupSubViews {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"bookOval"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = true;
    [_imageView sizeToFit];
    _imageView.left = 0;
    _imageView.top = 0;
    [self addSubview:_imageView];
    
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
    
    _likeImage = [[WWCollectButton alloc] init];
    _likeImage.imageView.contentMode = UIViewContentModeCenter;
    _likeImage.favoType = 1;
    [_likeImage sizeToFit];
    _likeImage.right = self.bounds.size.width - 20*screenRate;
    _likeImage.top = 20*screenRate;
    [self addSubview:_likeImage];
    [_likeImage sizeToFit];
    [_likeImage addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    _contentLabel.top = 228*screenRate;
    _contentLabel.left = 25*screenRate;
    _contentLabel.width = self.bounds.size.width - 50*screenRate;
    [self addSubview:_contentLabel];
    [_contentLabel sizeToFit];
    
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
    _textLabel.top = 378*screenRate;
    _textLabel.right = self.bounds.size.width - 25*screenRate;
    [self addSubview:_textLabel];
    [_textLabel sizeToFit];
}
- (void)likeClick {
    self.islike = !self.islike;
    if (self.islike) {
        [self.likeImage setFavo:YES withAnimate:YES];
    }else {
        [self.likeImage setFavo:NO withAnimate:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(bookCellLike)]) {
        [self.delegate bookCellLike];
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
-(void)setModel:(id)model {

}
@end
