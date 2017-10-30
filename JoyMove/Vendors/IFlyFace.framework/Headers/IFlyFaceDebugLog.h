//
//  IFlyFaceDebugLog.h
//  MSC

//  description: 程序中的log处理类

//  Created by ypzhao on 12-11-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/** debug 日志控制类
 
 使用此类控制日志的打印显示.
 */
@interface IFlyFaceDebugLog : NSObject

/**
 * @fn      showLog
 * @brief   打印log
 *
 * @return
 * @param   format          -[in] 要打印的内容格式
 * @param   ...             -[in] 要打印的内容
 * @see
 */
+ (void) showLog:(NSString *)format, ...;

/**
 * @fn      writeLog
 * @brief   将log写入文件中
 *
 *
 * @return
 * @see
 */
+ (void) writeLog;

/**
 * @fn      setShowLog
 * @brief   设置是否显示log
 *
 * @param   showLog          -[in] 设置是否显示
 * @return
 * @see
 */
+ (void) setShowLog:(BOOL) showLog;
@end
