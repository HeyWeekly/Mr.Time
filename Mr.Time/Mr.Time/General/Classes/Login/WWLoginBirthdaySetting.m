//
//  WWLoginBirthdaySetting.m
//  Mr.Time
//
//  Created by steaest on 2017/8/9.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWLoginBirthdaySetting.h"

@interface WWLoginBirthdaySetting ()<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *_dayArray;
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
}
@property (nonatomic, strong) UIPickerView *birthdayView;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIImageView *tellMeBirthday;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSDate *scrollToDate;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *dateStr;
@end

@implementation WWLoginBirthdaySetting

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateStr = @"1949-1-01";
    NSMutableArray *tempArray = [NSMutableArray array];
    self.monthArray = [NSArray array];
    for (int i = 1949; i <= 2020; i++) {
        [tempArray addObject:@(i)];
    }
    self.yearArray = [NSArray arrayWithArray:tempArray.copy];
    self.monthArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    _dayArray = [self setArray:_dayArray];
    [self setupSubview];
}

- (void)setupSubview {
    [self.view addSubview:self.tellMeBirthday];
    [self.tellMeBirthday sizeToFit];
    self.tellMeBirthday.centerX = self.view.centerX;
    self.tellMeBirthday.top = 94*screenRate;
    
    [self.view addSubview:self.backImage];
    [self.backImage sizeToFit];
    self.backImage.centerX = self.view.centerX;
    self.backImage.top = self.tellMeBirthday.bottom + 142*screenRate;
    
    [self.view addSubview:self.birthdayView];
    self.birthdayView.left = 0;
    self.birthdayView.top = self.tellMeBirthday.bottom+73*screenRate;
    self.birthdayView.width = KWidth;
    self.birthdayView.height = 215*screenRate;
    
    [self.view addSubview:self.doneBtn];
    [self.doneBtn sizeToFit];
    self.doneBtn.centerX = self.view.centerX;
    self.doneBtn.bottom = KHeight - 60*screenRate;
}

#pragma mark - pickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    UILabel* numLabel = (UILabel*)view;
    if (!numLabel){
        numLabel = [[UILabel alloc] init];
        [numLabel setFont:[UIFont fontWithName:kFont_DINAlternate size:50*screenRate]];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 0) {
        numLabel.text = [NSString stringWithFormat:@"%@", self.yearArray[row]];
    }else if (component == 1){
        numLabel.text = [NSString stringWithFormat:@"%@", self.monthArray[row]];
    }else if(component == 2){
        numLabel.text = [NSString stringWithFormat:@"%@", _dayArray[row]];;
    }
    return numLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        yearIndex = row;
    }else if (component == 1){
        monthIndex = row;
    }else if (component == 2) {
        dayIndex = row;
    }
    if (component == 0 || component == 1){
        [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        if (_dayArray.count-1<dayIndex) {
            dayIndex = _dayArray.count-1;
        }
    }
    [pickerView reloadAllComponents];
    self.dateStr = [NSString stringWithFormat:@"%@-%@-%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex]];
    self.year = _yearArray[yearIndex];
    self.month = _monthArray[monthIndex];
    self.day = _dayArray[dayIndex];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 65*screenRate;
}

//每个item的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return  150*screenRate;
    } else if(component==1){
        return  80*screenRate;
    }else if(component==2){
        return  80*screenRate;
    }
    return  0;
}

#pragma mark - event
- (void)birthdayDoneClick {
    NSInteger dataStr = [self getDifferenceByDate:self.dateStr];
    NSString *yearDay = [self dateToOld:self.dateStr];
    [WWUserModel shareUserModel].yearDay = yearDay;
    [WWUserModel shareUserModel].dataStr = [NSString stringWithFormat:@"%ld",(long)dataStr];
    [WWUserModel shareUserModel].isNewUser = YES;
    [[WWUserModel shareUserModel] saveAccount];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"oldCustom"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginSuccess" object:nil];
}

#pragma mark - tools
-(NSString *)dateToOld:(NSString *)bornDate{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:bornDate];
    
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:oldDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

- (NSInteger)getDifferenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}

-(NSArray *)getNumberOfRowsInComponent {
    NSInteger yearNum = self.yearArray.count;
    NSInteger monthNum = self.monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    return @[@(yearNum),@(monthNum),@(dayNum)];
}

//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

#pragma mark - lazy
- (UIPickerView *)birthdayView {
    if (_birthdayView == nil) {
        _birthdayView = [[UIPickerView alloc] init];
        [_birthdayView setDataSource: self];
        [_birthdayView setDelegate: self];
        _birthdayView.showsSelectionIndicator = NO;
    }
    return _birthdayView;
}

- (UIImageView *)tellMeBirthday {
    if (_tellMeBirthday == nil) {
        _tellMeBirthday = [[UIImageView alloc]init];
        _tellMeBirthday.image = [UIImage imageNamed:@"tellMeBirthday"];
    }
    return _tellMeBirthday;
}

- (UIImageView *)backImage {
    if (_backImage == nil) {
        _backImage = [[UIImageView alloc]init];
        _backImage.image = [UIImage imageNamed:@"selectBirthday"];
    }
    return _backImage;
}

- (UIButton *)doneBtn {
    if (_doneBtn == nil) {
        _doneBtn = [[UIButton alloc]init];
        [_doneBtn setImage:[UIImage imageNamed:@"birthdayDone"] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(birthdayDoneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

@end
