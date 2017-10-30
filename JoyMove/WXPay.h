//
//  WXPay.h
//  JoyMove
//
//  Created by 刘欣 on 15/5/7.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXPay : NSObject<WXApiDelegate>

+ (void)pay:(NSDictionary *)payDic;

@end
