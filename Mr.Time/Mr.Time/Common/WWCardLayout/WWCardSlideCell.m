//
//  WWCardSlideCell.m
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCardSlideCell.h"

@interface WWCardSlideCell ()
{
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_contentLabel;
    UIImageView *_likeImage;
}
@end

@implementation WWCardSlideCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"beijingceshi"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = true;
    [_imageView sizeToFit];
    _imageView.left = -20;
    _imageView.top = 0;
    _imageView.width = 200*screenRate;
    _imageView.height = 200*screenRate;
    [self addSubview:_imageView];
    
    _likeImage = [[UIImageView alloc] init];
    _likeImage.contentMode = UIViewContentModeScaleAspectFit;
    _likeImage.image = [UIImage imageNamed:@"bookLike"];
    _likeImage.layer.masksToBounds = true;
    [_likeImage sizeToFit];
    _likeImage.right = self.bounds.size.width - 20*screenRate;
    _likeImage.top = 20*screenRate;
    [self addSubview:_likeImage];
    [_likeImage sizeToFit];
    
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

-(void)setModel:(id)model {

}
@end
