//
//  UserViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "UserViewController.h"
#import "WWSettingVC.h"
#import "WWMessageDetailVCViewController.h"
#import "WWCollectButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WWLabel.h"
#import "WWBaseTableView.h"
#import "WWHomeBookModel.h"
#import "WWMessageDetailVCViewController.h"

#define CELL_IDENTITY @"myCell"

@protocol userPublishCellDelegate <NSObject>
- (void)userCellLike;
- (void)moreClickAid:(NSString *)aid withContnet:(NSString *)content;
@end

@interface userPublishCell : UITableViewCell
@property (nonatomic, strong) WWLabel *yearsNum;
@property (nonatomic, strong) UIImageView *yearsImage;
@property (nonatomic, strong) WWCollectButton *likeImage;
@property (nonatomic, strong) UILabel *likeNum;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic,  weak) id <userPublishCellDelegate> delegate;
@property (nonatomic, strong) WWHomeBookModel *model;
@property (nonatomic, strong) UIButton *moreBtn;
@end


@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,userPublishCellDelegate>
@property(nonatomic, strong) UIButton  *notice;
@property(nonatomic, strong) UIButton  *setting;
@property(nonatomic, strong) UIButton  *backheadImage;
@property(nonatomic, strong) UIImageView  *headImage;
@property (nonatomic, strong) UILabel *nameLbael;
@property (nonatomic, strong) UILabel *yearLbael;
@property (nonatomic, strong) UILabel *collected;
@property (nonatomic, strong) UILabel *collectedNum;
@property (nonatomic, strong) UIView *sepLine1;
@property (nonatomic, strong) UILabel *recorded;
@property (nonatomic, strong) UILabel *recordedNum;
@property (nonatomic, strong) UIView *sepLine2;
@property (nonatomic, strong) UILabel *likeded;
@property (nonatomic, strong) UILabel *likedNum;
@property (nonatomic, strong) WWBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray <WWHomeBookModel*>* modelArray;
@property (nonatomic, strong) NSNumber *index;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _index = @(0);
    [self setupViews];
}

- (void)loadCustomInfo {
    WEAK_SELF;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = getPersonMetto;
        request.parameters = @{@"page" : weakSelf.index, @"size" : @(20)};
        request.httpMethod = kXMHTTPMethodGET;
    } onSuccess:^(id  _Nullable responseObject) {
        WWHomeJsonBookModel *model = [WWHomeJsonBookModel yy_modelWithJSON:responseObject];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([model.code isEqualToString:@"1"]) {
            if (model.result.count==0 && ![weakSelf.index isEqual:@(0)]) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf.tableView reloadData];
                return ;
            }
            if ([weakSelf.index isEqual:@0]) {
                [weakSelf.modelArray removeAllObjects];
            }
            if (!weakSelf.modelArray || [weakSelf.index isEqual:@0] || !weakSelf.modelArray.count) {
                weakSelf.modelArray = model.result.mutableCopy;
            }else {
                [weakSelf.modelArray addObjectsFromArray:model.result.mutableCopy];
            }
            if (weakSelf.modelArray.count == 0 && [weakSelf.index isEqual:@(0)]) {
                [weakSelf.tableView showEmptyViewWithType:1 andFrame:CGRectMake(-20, 0, KWidth, KHeight)];
            }
            [weakSelf.tableView reloadData];
        }else {
            [WWHUD showMessage:@"加载失败~" inView:weakSelf.view];
        }
    } onFailure:^(NSError * _Nullable error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [WWHUD showMessage:@"服务器可能出问题了~" inView:weakSelf.view];
    } onFinished:nil];
}

- (void)setupViews {
    WWUserModel *model = [WWUserModel shareUserModel];
    model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
    if (model.headimgurl) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    }
    if (model.headimg) {
        self.headImage.image = model.headimg;
    }
    [self.view addSubview:self.headImage];
    [self drawRect];
    [self.view addSubview:self.backheadImage];
    [self.backheadImage sizeToFit];
    self.backheadImage.left = 25*screenRate;
    self.backheadImage.top = SafeAreaTopHeight + 30*screenRate;
    [self.backheadImage sizeToFit];
    
    [self.view addSubview:self.setting];
    [self.setting sizeToFit];
    self.setting.right = self.view.bounds.size.width-25*screenRate;
    self.setting.top = self.backheadImage.top;
    
    //    [self.view addSubview:self.notice];
    //    [self.notice sizeToFit];
    //    self.notice.right = self.setting.left - 35*screenRate;;
    //    self.notice.top = self.backheadImage.top;
    
    if (model.nickname) {
        self.nameLbael.text = model.nickname;
    }
    [self.view addSubview:self.nameLbael];
    [self.nameLbael sizeToFit];
    self.nameLbael.left = self.backheadImage.right+22*screenRate;;
    self.nameLbael.top = self.backheadImage.top;
    
    if (model.dataStr) {
        self.yearLbael.text = model.birthday;
    }
    [self.view addSubview:self.yearLbael];
    [self.yearLbael sizeToFit];
    self.yearLbael.left = self.nameLbael.left;
    self.yearLbael.top = self.nameLbael.bottom+8*screenRate;
    
    //    [self.view addSubview:self.collectedNum];
    //    [self.collectedNum sizeToFit];
    //    self.collectedNum.right = self.view.bounds.size.width - 23*screenRate;
    //    self.collectedNum.top = self.setting.bottom+73*screenRate;
    //
    //    [self.view addSubview:self.collected];
    //    [self.collected sizeToFit];
    //    self.collected.right = self.collectedNum.right;
    //    self.collected.top = self.collectedNum.bottom+6*screenRate;
    //    [self.view addSubview:self.sepLine1];
    //    [self.sepLine1 sizeToFit];
    //    self.sepLine1.right = self.collected.left - 15*screenRate;
    //    self.sepLine1.top = self.collectedNum.top + 3*screenRate;
    //    self.sepLine1.width = 1;
    //    self.sepLine1.height = 30*screenRate;
    //
    //    [self.view addSubview:self.recordedNum];
    //    [self.recordedNum sizeToFit];
    //    self.recordedNum.right = self.sepLine1.left - 15*screenRate;
    //    self.recordedNum.top = self.collectedNum.top;
    //    [self.view addSubview:self.recorded];
    //    [self.recorded sizeToFit];
    //    self.recorded.right = self.recordedNum.right;
    //    self.recorded.top = self.recordedNum.bottom+6*screenRate;
    //    [self.view addSubview:self.sepLine2];
    //    [self.sepLine2 sizeToFit];
    //    self.sepLine2.right = self.recorded.left - 15*screenRate;
    //    self.sepLine2.top = self.recordedNum.top + 3*screenRate;
    //    self.sepLine2.width = 1;
    //    self.sepLine2.height = 30*screenRate;
    //
    //    [self.view addSubview:self.likedNum];
    //    [self.likedNum sizeToFit];
    //    self.likedNum.right = self.sepLine2.left - 15*screenRate;
    //    self.likedNum.top = self.collectedNum.top;
    //    [self.view addSubview:self.likeded];
    //    [self.likeded sizeToFit];
    //    self.likeded.right = self.likedNum.right;
    //    self.likeded.top = self.likedNum.bottom+6*screenRate;
    
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - event
- (void)setClick {
    WWSettingVC *vc = [[WWSettingVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPublishCell"];
    if (!cell) {
        cell = [[userPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPublishCell"];
    }
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWHomeBookModel *model = self.modelArray[indexPath.row];
    WWMessageDetailVCViewController *vc = [[WWMessageDetailVCViewController alloc]initWithAge:model.age.integerValue comment:model.content authAge:model.authorAge authName:model.nickname favoId:model.aid.integerValue favoCount:model.enshrined source:@"个人列表"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.modelArray[indexPath.row].cellHeight ? self.modelArray[indexPath.row].cellHeight : 44;
}

- (void)moreClickAid:(NSString *)aid withContnet:(NSString *)content {
    WWActionSheet *actionSheet = [[WWActionSheet alloc] initWithTitle:nil];
    WEAK_SELF;
    WWActionSheetAction *action = [WWActionSheetAction actionWithTitle:@"删除"
                                                               handler:^(WWActionSheetAction *action) {
                                                                   [weakSelf contentDelAid:aid withContnet:content];
                                                               }];
    
    WWActionSheetAction *action2 = [WWActionSheetAction actionWithTitle:@"复制"
                                                                handler:^(WWActionSheetAction *action) {
                                                                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                    pasteboard.string = content;
                                                                    [WWHUD showMessage:@"已复制" inView:weakSelf.view];
                                                                }];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    
    [actionSheet showInWindow:[WWGeneric popOverWindow]];
}

- (void)contentDelAid:(NSString *)aid withContnet:(NSString *)content {
    WEAK_SELF;
    WWUserModel *model = [WWUserModel shareUserModel];
    model = (WWUserModel*)[NSKeyedUnarchiver unarchiveObjectWithFile:ArchiverPath];
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = delMetto;
        request.parameters = @{@"uid" : model.uid ? model.uid : @"life15078000081469261", @"aid" : aid};
        request.httpMethod = kXMHTTPMethodPOST;
    } onSuccess:^(id  _Nullable responseObject) {
        weakSelf.index = @(0);
        [weakSelf loadCustomInfo];
    } onFailure:^(NSError * _Nullable error) {
        [WWHUD showMessage:@"删除失败，请重试~" inView:self.view];
    } onFinished:nil];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
//    for (userPublishCell *cell in [self.tableView visibleCells]) {
//        CGFloat y = cell.centerY - scrollView.contentOffset.y;
//        CGFloat p = y - viewHeight / 2;
//        CGFloat scale = cos(p / viewHeight * 0.8) * 0.95;
//        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//            cell.containerView.transform = CGAffineTransformMakeScale(scale, scale);
//        } completion:NULL];
//    }
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (CanRefresh) {
//        NSInteger tempIndex = self.index.integerValue;
//        tempIndex ++;
//        self.index = [NSNumber numberWithInteger:tempIndex];
//        [self loadCustomInfo];
//    }
//}

#pragma mark - 懒加载
- (WWBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WWBaseTableView alloc] initWithFrame:CGRectMake(20*screenRate, self.backheadImage.bottom+29*screenRate, KWidth-40*screenRate, KHeight-(self.backheadImage.bottom+29*screenRate)-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = viewBackGround_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WEAK_SELF;
        _tableView.mj_header = [WWRefreshHeaderView headerWithRefreshingBlock:^{
            weakSelf.index = @(0);
            [weakSelf loadCustomInfo];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSInteger tempIndex = weakSelf.index.integerValue;
            tempIndex ++;
            weakSelf.index = [NSNumber numberWithInteger:tempIndex];
            [weakSelf loadCustomInfo];
        }];
    }
    return _tableView;
}

- (UILabel *)yearLbael {
    if (_yearLbael == nil) {
        _yearLbael = [[UILabel alloc]init];
        _yearLbael.text = @"1991.10.18";
        _yearLbael.textAlignment = NSTextAlignmentCenter;
        _yearLbael.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _yearLbael.textColor = RGBCOLOR(0x545454);
        _yearLbael.layer.shadowColor = [UIColor blackColor].CGColor;
        _yearLbael.layer.shadowOpacity = 0.6;
        _yearLbael.layer.shadowRadius = 10;
        _yearLbael.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return _yearLbael;
}

- (UILabel *)nameLbael {
    if (_nameLbael == nil) {
        _nameLbael = [[UILabel alloc]init];
        _nameLbael.text = @"时间先生";
        _nameLbael.textAlignment = NSTextAlignmentCenter;
        _nameLbael.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _nameLbael.textColor = [UIColor whiteColor];
    }
    return _nameLbael;
}

- (UIButton *)notice {
    if (_notice == nil) {
        _notice = [[UIButton alloc]init];
        [_notice setImage:[UIImage imageNamed:@"Noticeicon"] forState:UIControlStateNormal];
        _notice.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _notice;
}

- (UIButton *)setting {
    if (_setting == nil) {
        _setting = [[UIButton alloc]init];
        [_setting setImage:[UIImage imageNamed:@"Setting icon"] forState:UIControlStateNormal];
        _setting.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_setting addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setting;
}

- (UIButton *)backheadImage {
    if (_backheadImage == nil) {
        _backheadImage = [[UIButton alloc]init];
        [_backheadImage setImage:[UIImage imageNamed:@"headbackground"] forState:UIControlStateNormal];
        _backheadImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_backheadImage addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backheadImage;
}

- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(32.8*screenRate, SafeAreaTopHeight + 39.8*screenRate, 55, 55)];
        _headImage.image = [UIImage imageNamed:@"defaulthead"];
        _headImage.clipsToBounds = YES;
    }
    return _headImage;
}

- (UILabel *)collected {
    if (!_collected) {
        _collected = [[UILabel alloc]init];
        _collected.text = @"已收藏";
        _collected.textAlignment = NSTextAlignmentLeft;
        _collected.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _collected.textColor = RGBCOLOR(0x94A3AD);
    }
    return _collected;
}

- (UILabel *)collectedNum {
    if (!_collectedNum) {
        _collectedNum = [[UILabel alloc]init];
        _collectedNum.text = @"320";
        _collectedNum.textAlignment = NSTextAlignmentLeft;
        _collectedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _collectedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _collectedNum;
}

- (UIView *)sepLine1 {
    if (_sepLine1 == nil) {
        _sepLine1 = [[UIView alloc]init];
        _sepLine1.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepLine1;
}

- (UILabel *)recorded {
    if (!_recorded) {
        _recorded = [[UILabel alloc]init];
        _recorded.text = @"已记录";
        _recorded.textAlignment = NSTextAlignmentLeft;
        _recorded.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _recorded.textColor = RGBCOLOR(0x94A3AD);
    }
    return _recorded;
}

- (UILabel *)recordedNum {
    if (!_recordedNum) {
        _recordedNum = [[UILabel alloc]init];
        _recordedNum.text = @"20";
        _recordedNum.textAlignment = NSTextAlignmentLeft;
        _recordedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _recordedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _recordedNum;
}

- (UIView *)sepLine2 {
    if (_sepLine2 == nil) {
        _sepLine2 = [[UIView alloc]init];
        _sepLine2.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepLine2;
}

- (UILabel *)likeded {
    if (!_likeded) {
        _likeded = [[UILabel alloc]init];
        _likeded.text = @"已被收藏";
        _likeded.textAlignment = NSTextAlignmentLeft;
        _likeded.font = [UIFont fontWithName:kFont_Medium size:10*screenRate];
        _likeded.textColor = RGBCOLOR(0x94A3AD);
    }
    return _likeded;
}

- (UILabel *)likedNum {
    if (!_likedNum) {
        _likedNum = [[UILabel alloc]init];
        _likedNum.text = @"1,299";
        _likedNum.textAlignment = NSTextAlignmentLeft;
        _likedNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
        _likedNum.textColor = RGBCOLOR(0xCBD4DC);
    }
    return _likedNum;
}

- (void)drawRect {
    float viewWidth = 55;
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [[UIColor whiteColor] setStroke];
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    [path closePath];
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.lineWidth = 2;
    shapLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapLayer.path = path.CGPath;
    _headImage.layer.mask = shapLayer;
}

//无数据库支持 暂不支持换头像
//- (void)headImageClick {
//    WWActionSheet *actionSheet = [[WWActionSheet alloc] initWithTitle:nil];
//    WEAK_SELF;
//    WWActionSheetAction *action = [WWActionSheetAction actionWithTitle:@"相机"
//                                                               handler:^(WWActionSheetAction *action) {
//                                                                   UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//                                                                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                                                                       if ([Permissions isGetCameraPermission] ) {
//                                                                           sourceType = UIImagePickerControllerSourceTypeCamera;
//                                                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                                                                           picker.delegate = weakSelf;
//                                                                           picker.allowsEditing = YES;//设置可编辑
//                                                                           picker.sourceType = sourceType;
//                                                                           [weakSelf presentViewController:picker animated:YES completion:nil];
//                                                                       }else {
//                                                                           [Permissions getCameraPerMissionWithViewController:weakSelf];
//                                                                       }
//                                                                   }
//                                                               }];
//    
//    WWActionSheetAction *action2 = [WWActionSheetAction actionWithTitle:@"从相册获取"
//                                                                handler:^(WWActionSheetAction *action) {
//                                                                    if ([Permissions isGetPhotoPermission]) {
//                                                                        UIImagePickerController *pic = [[UIImagePickerController alloc] init];
//                                                                        pic.allowsEditing = YES;
//                                                                        pic.delegate = weakSelf;
//                                                                        [weakSelf presentViewController:pic animated:YES completion:nil];
//                                                                    }else {
//                                                                        [Permissions getPhonePermissionWithViewController:weakSelf];
//                                                                    }
//                                                                }];
//    [actionSheet addAction:action];
//    [actionSheet addAction:action2];
//    
//    [actionSheet showInWindow:[WWGeneric popOverWindow]];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    if (!image) {return;}
//    self.headImage.image = image;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
@end


@implementation userPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = viewBackGround_Color;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.containerView addSubview:self.yearsNum];
    [self.containerView addSubview:self.yearsImage];
    [self.containerView addSubview:self.likeNum];
    [self.containerView addSubview:self.likeImage];
    [self.containerView addSubview:self.moreBtn];
    [self.containerView addSubview:self.contentLabel];
    [self addSubview:self.containerView];
}

- (void)setModel:(WWHomeBookModel *)model {
    _model = model;
    self.containerView.width = KWidth - 40*screenRate;
    
    self.yearsNum.text = model.age;
    [self.yearsNum sizeToFit];
    self.yearsNum.top = 8*screenRate;
    self.yearsNum.left = 20*screenRate;
    
    [self.yearsImage sizeToFit];
    self.yearsImage.left = self.yearsNum.right+5*screenRate;
    self.yearsImage.top = 15*screenRate;
    
    [self.moreBtn sizeToFit];
    self.moreBtn.right = self.containerView.width-25*screenRate;
    self.moreBtn.top = 18*screenRate;
    
    self.likeNum.text = model.enshrineCnt;
    [self.likeNum sizeToFit];
    self.likeNum.right = self.moreBtn.left-15*screenRate;
    self.likeNum.top = 18*screenRate;
    
    [self.likeImage sizeToFit];
    self.likeImage.right = self.likeNum.left-5*screenRate;
    self.likeImage.top = 10*screenRate;
    if (model.enshrined.integerValue > 0) {
        [self.likeImage setFavo:YES withAnimate:NO];
    }else {
        [self.likeImage setFavo:NO withAnimate:NO];
    }
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:model.content attributes:@{NSForegroundColorAttributeName : RGBCOLOR(0x39454E), NSParagraphStyleAttributeName: paragraphStyle}];
    self.contentLabel.attributedText = string;
    [self.contentLabel sizeToFit];
    self.contentLabel.left = 25*screenRate;
    self.contentLabel.top = self.yearsImage.bottom+15.5*screenRate;
    self.contentLabel.width = self.containerView.width - 50*screenRate;
//    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];
    
    self.containerView.height = self.contentLabel.bottom+27*screenRate;
//    self.containerView.top = 0;
//    self.containerView.left = 0;
//    [self addSubview:self.containerView];
    _model.cellHeight = self.contentLabel.bottom + 47*screenRate;
}

- (void)moreClick {
    if ([self.delegate respondsToSelector:@selector(moreClickAid:withContnet:)]) {
        [self.delegate moreClickAid:self.model.aid withContnet:self.model.content];
    }
}

#pragma mark - 懒加载
- (WWLabel *)yearsNum {
    if (_yearsNum == nil) {
        _yearsNum = [[WWLabel alloc]init];
        _yearsNum.font = [UIFont fontWithName:kFont_DINAlternate size:40*screenRate];
        _yearsNum.text = @"25";
        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)RGBCOLOR(0x2EFFB6).CGColor];
        _yearsNum.colors =gradientColors;
    }
    return _yearsNum;
}

-  (UIImageView *)yearsImage {
    if (_yearsImage == nil) {
        _yearsImage = [[UIImageView alloc]init];
        _yearsImage.image = [UIImage imageNamed:@"userYearsOld"];
    }
    return _yearsImage;
}

- (WWCollectButton *)likeImage {
    if (_likeImage == nil) {
        _likeImage = [[WWCollectButton alloc]init];
        _likeImage.contentMode = UIViewContentModeCenter;
        _likeImage.favoType = 2;
        _likeImage.userInteractionEnabled = NO;
//        [_likeImage addTarget:self action:@selector(favoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeImage;
}

- (UILabel *)likeNum {
    if (_likeNum == nil) {
        _likeNum = [[UILabel alloc]init];
        _likeNum.text = @"1,3445";
        _likeNum.textColor = RGBCOLOR(0x94A3AD);
        _likeNum.font = [UIFont fontWithName:kFont_DINAlternate size:14*screenRate];
    }
    return _likeNum;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 4;
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
    }
    return _contentLabel;
}

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc]init];
        [_moreBtn setImage:[UIImage imageNamed:@"More"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8*screenRate;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

@end
