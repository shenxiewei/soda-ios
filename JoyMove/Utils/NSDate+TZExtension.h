//
//  NSData+TZExtension.h
//  JoyMove
//
//  Created by 赵霆 on 16/1/27.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TZExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
