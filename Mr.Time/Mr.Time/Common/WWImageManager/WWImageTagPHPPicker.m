//
//  WWImageTagPHPPicker.m
//  YaoKe
//
//  Created by steaest on 2016/11/1.
//  Copyright © 2016年 YaoKe. All rights reserved.
//

#import "WWImageTagPHPPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WWPhotoAlbums.h"
#import "Permissions.h"

@import Photos;
@import PhotosUI;

#define ALERT_MSG(msg) static UIAlertView *alert; alert = [[UIAlertView alloc] initWithTitle:L10NString(@"Hint") message:msg delegate:self cancelButtonTitle:L10NString(@"confirm") otherButtonTitles:nil, nil];\
[alert show];\

@interface WWImgalbumNameCell : UITableViewCell
@property (nonatomic, strong) UIImageView *onoImage;
@property (nonatomic, strong) UILabel *albumName;
@property (nonatomic, strong) UILabel *albumCount;
@property (nonatomic, strong) UIView *lineView;
@end

@interface WWImgTagPHPickerCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, copy) NSString* representedAssetIdentifier;
@property (nonatomic, strong) UIImageView *circleImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface WWImageTagPHPPicker ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *nav;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *albumNameTable;
@property (nonatomic, strong) UIView *albumMaskView;
@property (nonatomic, strong) UILabel *navTitleLabel;
// current album
@property (nonatomic, strong) PHAssetCollection* currentColletion;
@property (nonatomic, strong) NSMutableArray *originImageArray;
@property (nonatomic, strong) NSMutableArray *tailoringImageArr;
// title右边的图
@property (nonatomic, strong) UIImageView *imagePicker;
@property (nonatomic, strong) NSMutableArray<WWPhotoAlbums *> *albumsArray;
@property (nonatomic, strong) NSMutableArray <PHAsset *> *currentResult;
///是否允许使用相机
@property (nonatomic, assign) BOOL isCamera;
///相册是否切换过
@property (nonatomic, assign) BOOL isAlbunSwitch;
///第一次记录选过的图片
@property (nonatomic, strong) NSMutableArray *selectPhotoKey;
///第二进入copy选过的图片
@property (nonatomic, strong) NSArray *didSelectPhotoKey;
///标记是不是第一次进入，在collectionView中做判断
@property (nonatomic, assign) BOOL isOneEnter;
///图片标识符及图片字典
@property (nonatomic, strong) NSMutableDictionary *photoDict;
///标记是否是pop之后再push
@property (nonatomic, assign) BOOL isPop;
///是否去掉一个照片
@property (nonatomic, assign) BOOL isCancelPhoto;
@end

@implementation WWImageTagPHPPicker
#pragma mark - 初始化部分
- (instancetype)init {
    if (self = [super init]) {
        self.isPop = NO;
        self.isOneEnter = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.nav];
        [self.view addSubview:self.albumNameTable];
        self.originImageArray = [NSMutableArray arrayWithCapacity:9];
        self.tailoringImageArr = [NSMutableArray arrayWithCapacity:9];
        self.selectPhotoKey = [NSMutableArray arrayWithCapacity:9];
        self.photoDict = [NSMutableDictionary dictionaryWithCapacity:9];
        [self loadPhotos];
        self.currentColletion = (PHAssetCollection*)self.albumsArray.firstObject.assetCollection;
        [self.collectionView reloadData];
        [self.albumNameTable reloadData];
    }
    return self;
}

#pragma mark - 视图生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isPop = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 图片加载
- (void)loadPhotos {
    NSMutableArray<WWPhotoAlbums *> *mArr = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos && obj.assetCollectionSubtype < 212) {
            NSArray <PHAsset *> *assets = [self getAssetsInAssetCollection:obj ascending:NO];
            if ([assets count]) {
                WWPhotoAlbums *pa = [[WWPhotoAlbums alloc] init];
                pa.albumName =obj.localizedTitle;
                pa.albumImageCount = [assets count];
                pa.firstImageAsset = assets.firstObject;
                pa.assetCollection = obj;
                [mArr addObject:pa];
            }
        }
    }];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                           subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:YES];
        if (assets.count > 0) {
            WWPhotoAlbums *pa = [[WWPhotoAlbums alloc] init];
            pa.albumName = collection.localizedTitle;
            pa.albumImageCount = [assets count];
            pa.firstImageAsset = assets.firstObject;
            pa.assetCollection = collection;
            [mArr addObject:pa];
        }
    }];
    self.albumsArray = mArr;
    self.currentColletion = self.albumsArray.firstObject.assetCollection;
}

#pragma mark - 视频过滤
- (NSArray <PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray <PHAsset *> *mArr = [NSMutableArray array];
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mediaType == PHAssetMediaTypeImage && obj.mediaType != PHAssetMediaTypeVideo) {
            [mArr addObject:obj];
        }
    }];
    return mArr;
}
- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return result;
}
#pragma mark - set方法
- (void)setCurrentColletion:(PHAssetCollection *)currentColletion{
    _currentColletion = currentColletion;
    if ([currentColletion isEqual:(PHAssetCollection *)self.albumsArray.firstObject.assetCollection]) {
        self.isCamera = YES;
    }else {
        self.isCamera = NO;
    }
    NSMutableArray <PHAsset *> *mArr = [NSMutableArray array];
    PHFetchResult *result = [self fetchAssetsInAssetCollection:currentColletion ascending:YES];
    [result enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mediaType == PHAssetMediaTypeImage) {
            [mArr addObject:obj];
        }
    }];
    self.currentResult = mArr;
    self.navTitleLabel.text = _currentColletion.localizedTitle;
    [self.navTitleLabel sizeToFit];
    _imagePicker.left = self.navTitleLabel.right+3;
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isCamera) {
        return self.currentResult.count+1;
    }else {
        return self.currentResult.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCamera) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"UICollectionViewCellsim";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhaoxiangji"]];
            img.clipsToBounds = YES;
            img.center = cell.contentView.center;
            [cell.contentView addSubview:img];
            cell.backgroundColor = [UIColor redColor];
            return cell;
        }else {
            static NSString *CellIdentifier = @"TWPhotoCollectionViewCellOne";
            WWImgTagPHPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.isSelected = NO;
            for (int i = 0; i<self.selectPhotoKey.count; i++) {
                if ([self.selectPhotoKey containsObject:cell.representedAssetIdentifier]) {
                    [cell setIsSelected:YES];
                }
            }
            NSInteger number = self.currentResult.count - (indexPath.row);
            PHAsset* asset = self.currentResult[number];
            cell.representedAssetIdentifier = asset.localIdentifier;
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = NO;
            options.networkAccessAllowed = YES;
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                         targetSize:((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:options
                                      resultHandler:^(UIImage *result, NSDictionary *info) {
                                          if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                              cell.imageView.image = result;
                                          }
                                      }];
            return cell;
        }
    }else {
        static NSString *CellIdentifier = @"TWPhotoCollectionViewCellTwo";
        WWImgTagPHPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.isSelected = NO;
        for (int i = 0; i<self.selectPhotoKey.count; i++) {
            if ([self.selectPhotoKey containsObject:cell.representedAssetIdentifier]) {
                [cell setIsSelected:YES];
            }
        }
        PHAsset* asset = self.currentResult[indexPath.row];
        cell.representedAssetIdentifier = asset.localIdentifier;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = NO;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                     targetSize:((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          cell.imageView.image = result;
                                      }
                                  }];
        return cell;
    }
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof__(self) weakSelf = self;
    if (self.isCamera) {
        if (indexPath.row != 0) {
            WWImgTagPHPickerCell* cell = (WWImgTagPHPickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if ([self.didSelectPhotoKey containsObject:cell.representedAssetIdentifier] && self.isOneEnter == NO) {
#warning 图片已在编辑列表中
            }else {
                if ([self.selectPhotoKey containsObject:cell.representedAssetIdentifier]) {
                    [self.selectPhotoKey removeObject:cell.representedAssetIdentifier];
                    self.count = self.count -1;
                    [self.photoDict removeObjectForKey:cell.representedAssetIdentifier];
                    self.isCancelPhoto = YES;
                    [cell setIsSelected:NO];
                }else {
                    if (self.selectPhotoKey.count != 9) {
                        if (self.count == self.maxCount) {
                            NSString *msg = [NSString stringWithFormat:@"%@ %lu %@",@"最多选择",(unsigned long)self.maxCount,@"张照片"];
#warning @"最多选择"
                            return;
                        }
                        [self.selectPhotoKey addObject:cell.representedAssetIdentifier];
                        self.count = self.count+1;
                        NSInteger number = self.currentResult.count - (indexPath.row);
                        PHAsset* asset = self.currentResult[number];
                        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat; //I only want the highest possible quality
                        options.synchronous = NO;
                        options.networkAccessAllowed = YES;
                        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(KWidth, KWidth) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                        __strong __typeof__(weakSelf) strongSelf = weakSelf;
                            if (image) {
                                [strongSelf.photoDict setValue:image forKey:asset.localIdentifier];
                            }
                        }];
                        [cell setIsSelected:YES];
                    }else{
                        NSString *msg = [NSString stringWithFormat:@"%@ %lu %@",@"最多选择",(unsigned long)self.selectPhotoKey.count,@"张照片"];
#warning @"最多选择"
                        return;
                    }
                }
            }
        }else {
            if (![Permissions isGetCameraPermission] ) {
                [Permissions getCameraPerMissionWithViewController:self];
            }else {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    //设置拍照后的图片可被编辑
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    [self.navigationController presentViewController:picker animated:YES completion:nil];
                }
            }
        }
    }else {
        WWImgTagPHPickerCell* cell = (WWImgTagPHPickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if ([self.didSelectPhotoKey containsObject:cell.representedAssetIdentifier] && self.isOneEnter == NO) {
#warning 图片已在编辑列表中
            }else {
                if ([self.selectPhotoKey containsObject:cell.representedAssetIdentifier]) {
                    [self.selectPhotoKey removeObject:cell.representedAssetIdentifier];
                    self.count = self.count -1;
                    [self.photoDict removeObjectForKey:cell.representedAssetIdentifier];
                    self.isCancelPhoto = YES;
                    [cell setIsSelected:NO];
                }else {
                    if (self.selectPhotoKey.count != 9) {
                        if (self.count == self.maxCount) {
                            NSString *msg = [NSString stringWithFormat:@"%@ %lu %@",@"最多选择",(unsigned long)self.maxCount,@"张照片"];
#warning @"最多选择"
                            return;
                        }
                        [self.selectPhotoKey addObject:cell.representedAssetIdentifier];
                        self.count = self.count+1;
                        PHAsset* asset = self.currentResult[indexPath.row];
                        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat; //I only want the highest possible quality
                        options.synchronous = NO;
                        options.networkAccessAllowed = YES;
                        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(KWidth, KWidth) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                            __strong __typeof__(weakSelf) strongSelf = weakSelf;
                            if (image) {
                                [strongSelf.photoDict setValue:image forKey:asset.localIdentifier];
                            }
                        }];
                        [cell setIsSelected:YES];
                    }else{
                        NSString *msg = [NSString stringWithFormat:@"%@ %lu %@",@"最多选择",(unsigned long)self.selectPhotoKey.count,@"张照片"];
                        #warning @"最多选择"
                        return;
                    }
                }
            }
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWImgalbumNameCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWImgalbumNameCell" forIndexPath:indexPath];
    static PHImageRequestID requestID = -1;
    if (requestID >= 1) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    WWPhotoAlbums *album = self.albumsArray[indexPath.row];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.networkAccessAllowed = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:album.firstImageAsset targetSize:CGSizeMake(80*screenRate, 80*screenRate) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        if (image) {
            cell.onoImage.image = image;
        }else {}
    }];
    cell.albumName.text = album.albumName;
    cell.albumCount.text = [NSString stringWithFormat:@"%ld%@", (unsigned long)album.albumImageCount,@"张"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PHAssetCollection* collection = (PHAssetCollection*)[self.albumsArray objectAtIndex:indexPath.row].assetCollection;
    self.currentColletion = collection;
    [self.albumNameTable reloadData];
    [self.collectionView reloadData];
    [self dismissAlbumMaskView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.albumNameTable deselectRowAtIndexPath:indexPath animated:NO];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*screenRate;
}
#pragma mark - 相机
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //当image从相机中获取的时候存入相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//这个地方只做一个提示的功能
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
#warning 图片存储失败
    }else{
        [self performSelector:@selector(addNewPicture)  withObject:image afterDelay:0.5];
    }
}
- (void)addNewPicture {
    PHAssetCollection* collection = (PHAssetCollection*)self.albumsArray.firstObject.assetCollection;
    self.currentColletion = collection;
    self.albumsArray.firstObject.albumImageCount = self.albumsArray.firstObject.albumImageCount+1;
    [self.albumNameTable reloadData];
    [self.collectionView reloadData];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 图片裁剪逻辑
- (void)cropAction {
    if (self.selectPhotoKey.count == 0) {
        return;
    }
    if ((self.didSelectPhotoKey == nil && self.isPop == NO) || self.isCancelPhoto == YES ) {
        self.isCancelPhoto = NO;
        [self.tailoringImageArr removeAllObjects];
        [self.originImageArray removeAllObjects];
        for (int i = 0; i<self.photoDict.count; i++) {
            UIImage *image = [self.photoDict valueForKey:self.selectPhotoKey[i]];
            [self.tailoringImageArr addObject:image];
        }
    }else{
            NSInteger count = self.selectPhotoKey.count - self.didSelectPhotoKey.count;
            NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.didSelectPhotoKey];
            NSArray * filter = [self.selectPhotoKey filteredArrayUsingPredicate:thePredicate];
            NSMutableArray *marray = [NSMutableArray arrayWithArray:filter];
            for (int i = 0; i<count; i++) {
                UIImage *image = [self.photoDict valueForKey:marray[i]];
                if (![self.originImageArray containsObject:image]) {
                    [self.originImageArray addObject:image];
                    [self.tailoringImageArr addObject:image];
                }
            }
    }
    if (self.isBackNeedImageArray == NO) {
    }else {
        if ([self.delegate respondsToSelector:@selector(photoPickerController:)]) {
            [self.delegate photoPickerController:self.originImageArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - 点击方法
- (void)titleLabelClicked{
    if (!self.albumMaskView) {
        self.albumMaskView = [UIView new];
        self.albumMaskView.backgroundColor = [RGBCOLOR(0x000000) colorWithAlphaComponent:0.3];
        self.albumMaskView.alpha = 0;
        self.albumMaskView.frame = CGRectMake(0, 44, KWidth, KHeight - 44);
        [self.view insertSubview:self.albumMaskView belowSubview:self.albumNameTable];
        [UIView animateWithDuration:0.4 animations:^{
            self.albumNameTable.alpha = 1.0;
            self.albumMaskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.albumMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlbumMaskView)]];
        }];
    }else{
        [self dismissAlbumMaskView];
    }
}
- (void)dismissAlbumMaskView{
    self.albumMaskView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.albumNameTable.alpha = 0.0;
        self.albumMaskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.albumMaskView removeFromSuperview];
        self.albumMaskView = nil;
    }];
}

#pragma mark - 懒加载
- (UIView *)nav{
    if (_nav == nil) {
        CGRect rect = CGRectMake(0, 0, 150, 44);
        UIView *navView = [[UIView alloc] initWithFrame:rect];
        navView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"相机胶卷";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:kFont_Regular size:18];
        [titleLabel sizeToFit];
        titleLabel.center = navView.center;
        [navView addSubview:titleLabel];
        titleLabel.userInteractionEnabled = YES;
        self.navTitleLabel = titleLabel;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClicked)]];
        _imagePicker = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imagePicker"]];
        _imagePicker.frame = CGRectMake(titleLabel.right+3, 18, 9, 15);
        _imagePicker.contentMode = UIViewContentModeCenter;
        _imagePicker.centerY = titleLabel.centerY;
        [navView addSubview:_imagePicker];
        _nav = navView;
    }
    return _nav;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat colum = 3, spacing = 6*screenRate;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing - 12) / colum );
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(6*screenRate, 6*screenRate, 6*screenRate, 6*screenRate);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        //所有图片的放置的collectionView
        CGRect rect = CGRectMake(0, 0, KWidth, KHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[WWImgTagPHPickerCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCellOne"];
        [_collectionView registerClass:[WWImgTagPHPickerCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCellTwo"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellsim"];
    }
    return _collectionView;
}

- (UITableView *)albumNameTable{
    if (!_albumNameTable) {
        _albumNameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KWidth,KHeight-44)];
        _albumNameTable.dataSource = self;
        _albumNameTable.delegate = self;
        _albumNameTable.showsVerticalScrollIndicator = NO;
        _albumNameTable.showsHorizontalScrollIndicator = NO;
        [_albumNameTable registerClass:[WWImgalbumNameCell class] forCellReuseIdentifier:@"WWImgalbumNameCell"];
        _albumNameTable.alpha = 0;
        _albumNameTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _albumNameTable;
}

- (UIView *)rightItemView {
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [goBtn setTitle:@"完成" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goBtn.titleLabel.font = [UIFont fontWithName:kFont_Regular size:14];
    [goBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
    return goBtn;
}
- (UIView *)titleView {
    return self.nav;
}
#pragma mark - 固定方法
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

@implementation WWImgTagPHPickerCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.circleImage];
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    NSString *imageName = isSelected ? @"sy_photo-selected":@"sy_photo-normal";
    _circleImage.image = [UIImage imageNamed:imageName];
}
#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
- (UIImageView *)circleImage {
    if (_circleImage == nil) {
        CGFloat margin = 3*screenRate;
        CGFloat width = self.bounds.size.width/5*screenRate;
        CGRect rect = CGRectMake(self.bounds.size.width - margin - width, margin, width, width);
        _circleImage = [[UIImageView alloc]initWithFrame:rect];
    }
    return _circleImage;
}
@end

@implementation WWImgalbumNameCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self.contentView addSubview:self.onoImage];
    [self.contentView addSubview:self.albumName];
    [self.contentView addSubview:self.albumCount];
    [self.contentView addSubview:self.lineView];
}
- (UIImageView *)onoImage {
    if (_onoImage == nil) {
        _onoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenRate, 10*screenRate, 80*screenRate, 80*screenRate)];
        _onoImage.contentMode = UIViewContentModeScaleAspectFill;
        _onoImage.clipsToBounds = YES;
    }
    return _onoImage;
}
- (UILabel *)albumName {
    if (_albumName == nil) {
        _albumName = [[UILabel alloc]initWithFrame:CGRectMake(105*screenRate, 25*screenRate, 100*screenRate, 24*screenRate)];
        _albumName.textColor = [UIColor blackColor];
        _albumName.font = [UIFont fontWithName:kFont_Regular size:16*screenRate];
        _albumName.textAlignment = NSTextAlignmentLeft;
    }
    return _albumName;
}
- (UILabel *)albumCount {
    if (_albumCount == nil) {
        _albumCount = [[UILabel alloc]initWithFrame:CGRectMake(105*screenRate, (self.albumName.frame.size.height+self.albumName.frame.origin.y+5*screenRate), 100*screenRate, 24*screenRate)];
        _albumCount.textColor = [UIColor lightGrayColor];
        _albumCount.font = [UIFont fontWithName:kFont_Regular size:16*screenRate];
        _albumCount.textAlignment = NSTextAlignmentLeft;
    }
    return _albumCount;
}
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 99*screenRate, KWidth, 1)];
        _lineView.backgroundColor = RGBCOLOR(0xE8E8E8);
    }
    return _lineView;
}
@end
