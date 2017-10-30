//
//  Alipay.m
//  JoyMove
//
//  Created by ethen on 15/3/26.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "Alipay.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "UtilsMacro.h"


@implementation Alipay

- (void)pay:(NSString *)string {
    
    [[AlipaySDK defaultService] payOrder:string fromScheme:@"Soda" callback:^(NSDictionary *resultDic) {
        NSString *isSuccess=resultDic[@"resultStatus"];
        if ([isSuccess isEqualToString:@"9000"])
        {
            PostNotificationAllParameter(@"alipaySafepay", nil, resultDic);
        }
    }];
}

@end
