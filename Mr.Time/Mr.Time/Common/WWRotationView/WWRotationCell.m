//
//  WWRotationCell.m
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWRotationCell.h"

@implementation WWRotationCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    [self.contentView addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"image":self.imageView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[image]-0-|" options:0 metrics:nil views:dict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[image]-0-|" options:0 metrics:nil views:dict]];
}

#pragma mark - delegate
- (void)imageDidSet:(UIImage *)image {
    self.imageView.image = image;
}

#pragma mark - lazy
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
