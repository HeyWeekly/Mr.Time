//
//  WWLoginSettingInfoVC.m
//  Mr.Time
//
//  Created by steaest on 2017/8/8.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWLoginSettingInfoVC.h"
#import "WWLoginBirthdaySetting.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define DESMAX_STARWORDS_LENGTH 12

@interface WWLoginSettingInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UIImageView *thisNickName;
@property (nonatomic, strong) UIImageView *settingHeadImage;
@property (nonatomic, strong) UITextField *nickName;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIButton *backheadImage;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, assign) BOOL isHaveHeadImage;
@property (nonatomic, assign) NSInteger nickNameLength;
@end

@implementation WWLoginSettingInfoVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveHeadImage = NO;
    [self setupSubview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nickName];
}

- (void)setupSubview {
    [self.view addSubview:self.nav];
    [self.view addSubview:self.thisNickName];
    [self.thisNickName sizeToFit];
    self.thisNickName.centerX = self.view.centerX;
    self.thisNickName.top = 85*screenRate;
    
    [self.view addSubview:self.backheadImage];
    [self.backheadImage sizeToFit];
    self.backheadImage.centerX = self.view.centerX;
    self.backheadImage.top = self.thisNickName.bottom + 80*screenRate;
    [self.backheadImage sizeToFit];
    
    if ([WWUserModel shareUserModel].headimgurl) {
        [self.settingHeadImage sd_setImageWithURL:[NSURL URLWithString:[WWUserModel shareUserModel].headimgurl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    }
    [self.view addSubview:self.settingHeadImage];
    [self drawRect];
    
    [self.view addSubview:self.sepView];
    [self.sepView sizeToFit];
    self.sepView.left = 120*screenRate;
    self.sepView.top = self.backheadImage.bottom + 68*screenRate;
    self.sepView.width = 140*screenRate;
    self.sepView.height = 2;
    
    if ([WWUserModel shareUserModel].nickname) {
        self.nickName.text = [WWUserModel shareUserModel].nickname;
    }
    [self.view addSubview:self.nickName];
    [self.nickName sizeToFit];
    self.nickName.centerX = self.view.centerX;
    self.nickName.width = self.sepView.width;
    self.nickName.left = self.sepView.left;
    self.nickName.top = self.backheadImage.bottom+35*screenRate;
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn sizeToFit];
    self.nextBtn.bottom = self.view.bottom - 60*screenRate;
    self.nextBtn.centerX = self.view.centerX;
}

#pragma mark - NSNotification
//中英文的分别判断字符个数
-(void)textFiledEditChanged:(NSNotification *)obj{
    __block NSInteger count = 0;
    UITextField *textField = self.nickName;
    NSString *toBeString = textField.text;
    // 获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (toBeString.length > DESMAX_STARWORDS_LENGTH){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:DESMAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:DESMAX_STARWORDS_LENGTH];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, DESMAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    WEAK_SELF;
    [textField.text enumerateSubstringsInRange:NSMakeRange(0, textField.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         char commitChar = [toBeString characterAtIndex:0];
         NSString *temp = [toBeString substringWithRange:NSMakeRange(0,1)];
         const char *u8Temp = [temp UTF8String];
         if ([weakSelf stringContainsEmoji:substring]) {
             count += 1;
         }else if (u8Temp && 3==strlen(u8Temp)) {
             count += 2;
         }else if(commitChar >= 0 && commitChar <= 127){
             count++;
         }else{
             count++;
         }
     }];
    self.nickNameLength = count;
}

#pragma mark - event
- (void)headImageClick {
    WWActionSheet *actionSheet = [[WWActionSheet alloc] initWithTitle:nil];
    WEAK_SELF;
    WWActionSheetAction *action = [WWActionSheetAction actionWithTitle:@"相机"
                                                               handler:^(WWActionSheetAction *action) {
                                                                   UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                       if ([Permissions isGetCameraPermission] ) {
                                                                           sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                           picker.delegate = weakSelf;
                                                                           picker.allowsEditing = YES;//设置可编辑
                                                                           picker.sourceType = sourceType;
                                                                           [weakSelf presentViewController:picker animated:YES completion:nil];
                                                                       }else {
                                                                           [Permissions getCameraPerMissionWithViewController:weakSelf];
                                                                       }
                                                                   }
                                                               }];
    
    WWActionSheetAction *action2 = [WWActionSheetAction actionWithTitle:@"从相册获取"
                                                                handler:^(WWActionSheetAction *action) {
                                                                    if ([Permissions isGetPhotoPermission]) {
                                                                        UIImagePickerController *pic = [[UIImagePickerController alloc] init];
                                                                        pic.allowsEditing = YES;
                                                                        pic.delegate = weakSelf;
                                                                        [weakSelf presentViewController:pic animated:YES completion:nil];
                                                                    }else {
                                                                        [Permissions getPhonePermissionWithViewController:weakSelf];
                                                                    }
                                                                }];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    
    [actionSheet showInWindow:[WWGeneric popOverWindow]];
}

- (void)nextClick {
    if (!self.isHaveHeadImage && self.nickName.text.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowError object:nil userInfo:@{kUserInfo_MainNavErrorMsg:@"请设置头像和用户名"}];
        return;
    }
    if (!self.isHaveHeadImage && [self.settingHeadImage.image isEqual:[UIImage imageNamed:@"defaulthead"]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowError object:nil userInfo:@{kUserInfo_MainNavErrorMsg:@"请设置头像"}];
        return;
    }
    if (self.nickName.text.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowError object:nil userInfo:@{kUserInfo_MainNavErrorMsg:@"请输入用户名"}];
        return;
    }
    if (self.nickNameLength > DESMAX_STARWORDS_LENGTH) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_MainNavShowError object:nil userInfo:@{kUserInfo_MainNavErrorMsg:@"用户名最长6个中文字符（12个英文字符）"}];
        return;
    }
    [WWUserModel shareUserModel].nickname = self.nickName.text;
    [WWUserModel shareUserModel].headimg = self.settingHeadImage.image;
    [[WWUserModel shareUserModel] saveAccount];
    WWLoginBirthdaySetting *vc = [[WWLoginBirthdaySetting alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nickName resignFirstResponder];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {return;}
    self.settingHeadImage.image = image;
    self.isHaveHeadImage = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Tools
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

- (void)drawRect {
    float viewWidth = 98;
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
    _settingHeadImage.layer.mask = shapLayer;
}

#pragma mark - lazy
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = NO;
        [_nav.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _nav.navTitle.text = nil;
    }
    return _nav;
}

- (UIImageView *)thisNickName {
    if (_thisNickName == nil) {
        _thisNickName = [[UIImageView alloc]init];
        _thisNickName.image = [UIImage imageNamed:@"setingNickName"];
    }
    return _thisNickName;
}

- (UIImageView *)settingHeadImage {
    if (_settingHeadImage == nil) {
        _settingHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(KWidth/2 - self.backheadImage.width/2 + 6, self.thisNickName.bottom+90*screenRate, 98, 98)];
        _settingHeadImage.image = [UIImage imageNamed:@"defaulthead"];
        _settingHeadImage.clipsToBounds = YES;
    }
    return _settingHeadImage;
}

- (UIButton *)backheadImage {
    if (_backheadImage == nil) {
        _backheadImage = [[UIButton alloc]init];
        [_backheadImage setImage:[UIImage imageNamed:@"loginsettingheading"] forState:UIControlStateNormal];
        _backheadImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backheadImage addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backheadImage;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setImage:[UIImage imageNamed:@"nextBirthday"] forState:UIControlStateNormal];
        _nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc]init];
        _sepView.backgroundColor = RGBCOLOR(0x545454);
    }
    return _sepView;
}

- (UITextField *)nickName {
    if (_nickName == nil) {
        _nickName = [[UITextField alloc]init];
        _nickName.font = [UIFont fontWithName:kFont_SemiBold size:20*screenRate];
        _nickName.textColor = [UIColor whiteColor];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:
                                          @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:_nickName.font
                                            }];
        _nickName.attributedPlaceholder = attrString;
        _nickName.textAlignment = NSTextAlignmentCenter;
        _nickName.keyboardType = UIKeyboardTypeDefault;
        _nickName.keyboardAppearance = UIKeyboardAppearanceDark;
        _nickName.returnKeyType = UIReturnKeyDone;
        _nickName.tintColor = RGBCOLOR(0x15C2FF);
        _nickName.adjustsFontSizeToFitWidth = YES;
        _nickName.delegate = self;
    }
    return _nickName;
}
@end
