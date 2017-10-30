//
//  IFlyFaceVersion.h
//  IFlyFaceVersion
//
//  Created by 张剑 on 14-10-10.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/** IFlyFaceVersion
 * SDK 版本类
 */
@interface IFlyFaceVersion: NSObject

/**
 * @fn      getVersion
 * @brief   获取SDK版本号
 *
 * @return  版本号
 * @see
 */
+(NSString*)getVersion;

@end


