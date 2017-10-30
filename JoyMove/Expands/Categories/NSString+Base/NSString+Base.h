//
//  NSString+Base.h
//  SDBaseCompents
//
//  Created by Soda on 2017/3/13.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base)

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isValidVerificationCode:(NSString *)code;

+ (BOOL)isValidatePassword:(NSString *)password;

/**
 获取图片格式

 @param data <#data description#>
 @return <#return value description#>
 */
+ (NSString *)stringWithTypeForImageData:(NSData *)data;

+ (NSString *)getMonth:(NSInteger)beforeMonth;

/**
 时间戳转换时间

 @param interval <#interval description#>
 @param dateFormat <#dateFormat description#>
 @return 字符串时间戳
 */
+ (NSString *)timeStamp:(NSTimeInterval)interval DateFormat:(NSString *)dateFormat;


/**
 时间转换成时间戳

 @param formatTime <#formatTime description#>
 @param format <#format description#>
 @return <#return value description#>
 */
+(double)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
/**
 距离转换

 @param distance <#distance description#>
 @return <#return value description#>
 */
+ (NSString *)distanceConvertToString:(double)distance;


/**
 转换成中国时间--譬如：1小时3分钟

 @param time <#time description#>
 @return <#return value description#>
 */
+ (NSString *)convertChineseFormat:(double)time;

+ (BOOL)isValidateEmail:(NSString *)email;
@end
