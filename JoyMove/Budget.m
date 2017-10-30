//
//  Budget.m
//  JoyMove
//
//  Created by ethen on 15/3/24.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "Budget.h"
#import "LXRequest.h"
#import "Macro.h"
#import "BillModel.h"


@implementation Budget

const float everySecondOfTheCost = .01/60.f;

+ (float)costWithTimeInterval:(NSTimeInterval)timeInterval {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval t = now - timeInterval;
    
    return t*everySecondOfTheCost;
}

- (void)requestForTheCost
{
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId)};

    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetOrderDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess) {
                
                self.fee = [NSString stringWithFormat:@"%@", response[@"fee"]];
                
            }else{
                
            }
        }else{
            
        }
    }];
}

@end
