//
//  Config.h
//  JoyMove
//
//  Created by ethen on 15/6/25.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#ifndef JoyMove_Config_h
#define JoyMove_Config_h
#import "Tool.h"
static BOOL release = YES;   /**< 切换环境：YES生产，NO测试 */
/*天元重要测试*/
//static float nearTheCarDistance     = 1000.f;            /**< 认定用户在车附近的距离 */
static float nearTheStopDistance    = 100.f;            /**< 认定用户在stop附近的距离 */
static float cash                   = 0.01f;            /**< 押金金额 */
static NSString *serviceTelephone   = @"4000607927";    /**< 400客服电话 */
static NSString *serviceTelephoneDes = @"400-0607-927";

static NSString *mapApiKey = @"0d04db0f391424ae47caf97eb8845809"; /**< 高德地图SDK KEY */
static NSString *xfApiKey  = @"51360ee4";                         /**< 讯飞KEY */

extern BOOL isRelease;

#endif
