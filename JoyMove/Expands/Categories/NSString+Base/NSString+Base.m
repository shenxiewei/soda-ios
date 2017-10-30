//
//  NSString+Base.m
//  SDBaseCompents
//
//  Created by Soda on 2017/3/13.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}

// 验证密码的长度
+ (BOOL)isValidVerificationCode:(NSString *)code {
    
    return code.length > 3;
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//密码验证
+ (BOOL)isValidatePassword:(NSString *)password
{
    //大小写+数字
    NSString *passwordRegex = @"^(?:(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))(?!.*(.)\1{2,})[A-Za-z0-9!~<>,;:_=?*+#.\"&§%°()\\|\\[\\]\\-\\$\\^\\@\\/]{8,32}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

+ (NSString *)stringWithTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    return nil;
}

+ (NSString *)getMonth:(NSInteger)beforeMonth
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:beforeMonth];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}

+ (NSString *)timeStamp:(NSTimeInterval)interval DateFormat:(NSString *)dateFormat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
    
}

+ (NSString *)distanceConvertToString:(double)distance
{
    if (distance<=0) {     //未获取到用户位置
        
        return @"不能获取您的位置";
    }else if (distance < 1000) {
        
        return [NSString stringWithFormat:@"%.lf M",distance];
    }else {
        
        return [NSString stringWithFormat:@"%.1lf KM",distance];
    }
}

#pragma mark - 将某个时间转化成 时间戳

+(double)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    double timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] doubleValue]*1000;
    
    
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}

+ (NSString *)convertChineseFormat:(double)time
{
    NSString *result;
    int hours = 0;
    int minutes = 0;
    if (time >= (60 * 60)) {
        
        hours = time / (60 * 60);
        result = [NSString stringWithFormat:@"%i 小时", hours];
        time = (int)time % (60 * 60);
    }
    
    if (time >= 60) {
        
        minutes = time / 60;
        result = result.length ? [NSString stringWithFormat:@"%@ %i 分钟", result, minutes] : [NSString stringWithFormat:@"%i ", minutes ];
        time = (int)time % 60;
    }
    result = result.length ? result : @"";
    return result;
}
@end
