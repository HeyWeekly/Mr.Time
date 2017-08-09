//
//  WWLoginBirthdaySetting.m
//  Mr.Time
//
//  Created by steaest on 2017/8/9.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWLoginBirthdaySetting.h"

@interface WWLoginBirthdaySetting ()<UIPickerViewDataSource, UIPickerViewDelegate>
//@property (nonatomic, strong) UIDatePicker *birthdayView;
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *dayArray;
@end

@implementation WWLoginBirthdaySetting
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempArray2 = [NSMutableArray array];
    for (int i = 1949; i <= 2020; i++) {
        [tempArray addObject:@(i)];
    }
    self.yearArray = [NSArray arrayWithArray:tempArray.copy];
    self.monthArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    for (int i = 1; i <= 020; i++) {
        [tempArray addObject:@(i)];
    }
}
//- (UIPickerView *)birthdayView{
//    if (_birthdayView == nil) {
//        _birthdayView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, KHeight * 0.4)];
//        [_birthdayView setDataSource: self];
//        [_birthdayView setDelegate: self];
//        _birthdayView.showsSelectionIndicator = YES;
//    }
//    return _birthdayView;
//}
@end
