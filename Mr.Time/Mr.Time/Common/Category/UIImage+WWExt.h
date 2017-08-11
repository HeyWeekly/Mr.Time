//
//  UIImage+WWExt.h
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WWExt)

+ (UIImage *)imageWithView:(UIView *)view;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)resizableImage;

- (UIImage *)resizeImageToSize:(CGSize)size;

- (UIImage *)resizeImageToSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale;

- (UIImage *)createWithImageInRect:(CGRect)rect;

- (UIImage *)getGrayImage;

- (UIImage *)darkenImage;

- (UIImage *) partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest;

- (CGSize)pixelSize;

- (NSInteger)imageFileSize;
@end
