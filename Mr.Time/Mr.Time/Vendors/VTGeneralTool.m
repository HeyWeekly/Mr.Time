//
//  VTGeneralTool.m
//  SZDT_Partents
//
//  Created by szdt on 15/3/23.
//  Copyright (c) 2015年 szdt. All rights reserved.
//

#import "VTGeneralTool.h"
#import <AVFoundation/AVFoundation.h>
#import "ACMacros.h"
#import <SDWebImage/SDImageCache.h>
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone4S (480 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

static NSString * const FORM_FLE_INPUT = @"file";

@interface VTGeneralTool ()<UIAlertViewDelegate>

@end


@implementation VTGeneralTool

+(NSString  *)displayDataStyleWithNumber:(NSString *)timeNumber
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[timeNumber longLongValue]/1000];
   // NSLog(@"**** == %ld",(long)[timeNumber integerValue]);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *dateSMS = [dateFormatter stringFromDate:date1];
//    NSLog(@"给的时间date****%@",dateSMS);
    
    
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    //当前的时间转为时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    //计算当前的时间戳和给定得时间戳的差值
    long long int interval = ([timeSp longLongValue] - [timeNumber longLongValue]/1000);
    
    //判断是不是今天
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        if (interval < 60) {
            //秒
            return @"刚刚";
        }else if (interval < 60 * 60){
            //分钟
            return [NSString stringWithFormat:@"%d分钟前", (NSInteger)interval/60];
        }else  {
            //小时
            return [NSString stringWithFormat:@"%d小时前", (NSInteger)interval/(60 * 60)];
        }
    }else {
        //不是今天的情况
        //判断是不是昨天
        //条件就是取两天的差值
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MMM-dd";
        //只要年月日
        NSString *dateString = [formatter stringFromDate:date1];
        NSString *nowString = [formatter stringFromDate:[NSDate date]];
        
        //年-月-日
        NSDate *date = [formatter dateFromString:dateString];
        NSDate *now1 = [formatter dateFromString:nowString];
        //取两天之间的差值
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *component = [calendar components:unit fromDate:date toDate:now1 options:0];
        if (component.year == 0 && component.month == 0 && component.day ==1) {
            
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateSMS = [dateFormatter stringFromDate:date1];
            NSString *date = [dateSMS substringWithRange:NSMakeRange(0, 5)];
            return  [NSString stringWithFormat:@"昨天 %@", date];
            
        }else{
            
            //  出来今天和昨天剩下两种情况  要么是本周之内 要么是超过了一周
            //  判断是不是本周之内
            //  这里得到的日期是星期的开始日期
            //  下面的到本周的开始日期
            NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
            [gregorian setFirstWeekday:2]; //monday is first day
            NSDate *now = [NSDate date];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:now];
            NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
            [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])+ 7 ) % 7)];
            NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:now options:0];
            NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)fromDate: beginningOfWeek];
            NSDateFormatter *hahaformatter1 = [[NSDateFormatter alloc] init];
            // [hahaformatter1 setDateFormat:@"yyyy-MM-dd EEEE HH:mm:ss"];
            [hahaformatter1 setDateFormat:@"EEEE"];
            hahaformatter1.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
            //这里得到的日期是星期的开始日期  //得到星期的第一天的信息
            beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
            
            NSString *begintimeSp = [NSString stringWithFormat:@"%ld", (long)[beginningOfWeek timeIntervalSince1970]];
            NSString *judgetimeSp1 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
            
            //比较这周开始的一天的日期和即将判定的也就是给定的日期的先后
            //date1是给定的即将判定的某一天
            if ([begintimeSp intValue]>[judgetimeSp1 intValue]) {
             //   NSLog(@"直接显示年月日");
                //超过了一周 不是本周内  在本周之前
                //这里超过了一周
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                NSString *dateSMS = [dateFormatter stringFromDate:date1];
                NSString *dateStr = [NSString stringWithFormat:@"%@",dateSMS];
                return dateStr;
            }else{
                //是本周则直接显示的星期
                [dateFormatter setDateFormat:@"EEEE"];
                NSString *dateSMS = [dateFormatter stringFromDate:date1];
                NSString *dateStr = [NSString stringWithFormat:@"%@",dateSMS];
                if ([dateStr isEqualToString:@"Monday"]) {
                    return @"星期一";
                }else if ([dateStr isEqualToString:@"Tuesday"]){
                    return @"星期二";
                }else if ([dateStr isEqualToString:@"Wednesday"]){
                    return @"星期三";
                }else if ([dateStr isEqualToString:@"Thursday"]){
                    return @"星期四";
                }else if ([dateStr isEqualToString:@"Friday"]){
                    return @"星期五";
                }
                return dateStr;
            }
            
        }
        
    }
    
}

+ (CGSize)boundingRectWithSize:(CGSize)size  font:(CGFloat)font text:(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}


+ (UIColor *)colorWithHex:(NSString *)hexColor
{
    
    if (hexColor == nil) {
        return nil;
    }
    if ([hexColor length] < 7 ) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
    
}

+ (BOOL)judgePushSwitch
{
    if(isIOS8)
    {
        
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (types & UIRemoteNotificationTypeAlert);
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
}

+(BOOL)verifyEmail:(NSString*)email
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger numberOfMatches = [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if (numberOfMatches != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)verifyPhone:(NSString*)phone
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{3,}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger numberOfMatches = [regex numberOfMatchesInString:phone options:0 range:NSMakeRange(0, [phone length])];
    if (numberOfMatches != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)verifyMobilePhone:(NSString*)phone
{
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:phone] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)getTimeString:(NSInteger)duration
{
    
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    hour = duration / 3600;
    minute = duration % 3600 / 60;
    second = duration % 3600 % 60;
    
    NSString *dateStr = nil;
    
    if ( hour > 0 )
    {
        dateStr = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", (int)hour, (int)minute, (int)second];
    }
    else if ( minute > 0 )
    {
        dateStr = [NSString stringWithFormat:@"%02d分%02d秒", (int)minute, (int)second];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"%02d秒", (int)second];
    }
    
    return dateStr;
}

+ (NSString *)cleanPhone:(NSString *)beforeClean
{
    if ([beforeClean hasPrefix:@"+86"])
    {
        return [beforeClean substringFromIndex:3];
    }
    else if ([beforeClean hasPrefix:@"0086"])
    {
        return [beforeClean substringFromIndex:4];
    }
    else
        return beforeClean;
}


+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewsize
{
    CGFloat imgHWScale = image.size.height/image.size.width;
    CGFloat viewHWScale = viewsize.height/viewsize.width;
    CGRect rect = CGRectZero;
    if (imgHWScale>viewHWScale)
    {
        rect.size.height = viewsize.width*imgHWScale;
        rect.size.width = viewsize.width;
        rect.origin.x = 0.0f;
        rect.origin.y =  (viewsize.height - rect.size.height)*0.5f;
    }
    else
    {
        CGFloat imgWHScale = image.size.width/image.size.height;
        rect.size.width = viewsize.height*imgWHScale;
        rect.size.height = viewsize.height;
        rect.origin.y = 0.0f;
        rect.origin.x = (viewsize.width - rect.size.width)*0.5f;
    }
    
    UIGraphicsBeginImageContext(viewsize);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (Boolean)isNumberCharaterString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字和字母的集合");
        return YES;
    }
    return NO;
}

+ (Boolean)isCharaterString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"字母的集合");
        return YES;
    }
    return NO;
}

+ (Boolean)isNumberString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字集合");
        return YES;
    }
    return NO;
}

+ (Boolean)hasillegalString:(NSString *)str
{
    if ( str.length == 0 )  //目前允许是空
    {
        return NO;
    }
    
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"/／!！@@#＃$￥%^……&&*＊(（)）——_++|“”:：｛{}｝《<>》?？~～、-；;"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    
    NSLog( @"%@", str );
    
    if (foundRange.location == NSNotFound)
    {
        NSLog(@"含有非法字符");
        return YES;
    }
    
    return NO;
}

+ (Boolean)isValidSmsString:(NSString *)str
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+"] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        NSLog(@"是数字集合");
        return YES;
    }
    return NO;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (void)hiddenTabBar
{
//    AppDelegate *_app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [UIView animateWithDuration:0.5 animations:^{
//        _app.tabBar.ground.frame=CGRectMake(0, kScreenH, kScreenW, kScreenH);
//        _app.tabBar.ground.hidden = YES;
//        _app.tabBar.dcPathButton.hidden = YES;
//    }];
}

+ (void)showTabBar
{
//    AppDelegate *_app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [UIView animateWithDuration:0.5 animations:^{
//        _app.tabBar.ground.frame=CGRectMake(0, kScreenH-49, kScreenW, 49);
//        _app.tabBar.ground.hidden = NO;
//        _app.tabBar.dcPathButton.hidden = NO;
//    }];
}

+ (BOOL)checkNoChar:(NSString *)str
{
    int alength = [str length];
    for (int i = 0; i<alength; i++)
    {
        char commitChar = [str characterAtIndex:i];
        NSString *temp = [str substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            NSLog(@"字符串中含有中文");
            return YES;
        }else if((commitChar>64)&&(commitChar<91)){
            NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
            NSLog(@"字符串中含有小写英文字母");
        }else if((commitChar>47)&&(commitChar<58)){
            NSLog(@"字符串中含有数字");
        }else{
            return YES;
            NSLog(@"字符串中含有非法字符");
        }
    }
    return NO;
}

+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumber
{//检查电话号码
    
    NSString * MOBILE = @"^1([0-9])\\d{9}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+ (BOOL)checkNumberInput:(NSString *)phoneNumber
{//检查电话号码
    
    NSString * MOBILE = @"^1([0-9])\\d{9}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+(NSData*)returnDataWithDictionary:(NSDictionary*)dict
{
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    
    return data;
}

#pragma mark - 日期与字符串
+ (NSString *)getDate
{//得到今天日期的字符串
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{//将日期转换成周字符串
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSArray *)getCurrentWeekDay:(NSDate *)date
{//获取当前周的日期数组
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1)
    {
        firstDiff = 1;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return nil;
}



#pragma mark - 缓存清理工具
//计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+(float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
           folderSize +=[self fileSizeAtPath:absolutePath];
        }
//SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

+(void)clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}


#pragma mark - 图片上传工具
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath  // IN
                     picFileName: (NSString *)picFileName;  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
   
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300)
    {
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
}

/**
 * 修图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",fullPathToFile);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

/**
 * 生成GUID
 */
+ (NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    CFRelease(uuid);
    
    return uuidString;
}


+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
//    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
//        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//        if (ALAuthorizationStatusDenied == authStatus ||
//            ALAuthorizationStatusRestricted == authStatus) {
//            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
//            return NO;
//        }
//    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
//      kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tipStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else{
       // kTipAlert(@"%@", tipStr);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([app canOpenURL:settingsURL])
        {
            [app openURL:settingsURL];
        }
    }
    else
    {
        return;
    }
}

//百度转火星坐标
+ (CLLocationCoordinate2D )bdToGGEncrypt:(CLLocationCoordinate2D)coord
{
    double x = coord.longitude - 0.0065, y = coord.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    CLLocationCoordinate2D transformLocation ;
    transformLocation.longitude = z * cos(theta);
    transformLocation.latitude = z * sin(theta);
    return transformLocation;
}

//火星坐标转百度坐标
+ (CLLocationCoordinate2D )ggToBDEncrypt:(CLLocationCoordinate2D)coord
{
    double x = coord.longitude, y = coord.latitude;
    
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    
    CLLocationCoordinate2D transformLocation ;
    transformLocation.longitude = z * cos(theta) + 0.0065;
    transformLocation.latitude = z * sin(theta) + 0.006;
    
    return transformLocation;
}

//获得设备型号
+ (NSString *)getCurrentDevice
{
    if (IS_IPHONE5)
    {
        return @"iphone5";
    }
    if (IS_IPhone6)
    {
        return @"iphone6";
    }
    if (IS_IPhone6plus)
    {
        return @"iphone6Plus";
    }
    if (IS_IPhone4S)
    {
        return @"iphone4s";
    }
    else
    {
        return @"unkonwnDevice";
    }
}


@end
