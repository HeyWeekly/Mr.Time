//
//  WWPhotoAlbums.h
//  YaoKe
//
//  Created by steaest on 2017/3/23.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <photos/photos.h>

@interface WWPhotoAlbums : NSObject

@property (nonatomic, copy) NSString *albumName; //相册名字
@property (nonatomic, assign) NSUInteger albumImageCount; //该相册内相片数量
@property (nonatomic, strong) PHAsset *firstImageAsset; //相册第一张图片缩略图
@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片
@end
