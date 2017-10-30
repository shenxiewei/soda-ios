//
//  OrderData.m
//  JoyMove
//
//  Created by ethen on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OrderData.h"

@implementation OrderData

static OrderData *myOrderData = nil;

+ (OrderData *)orderData {
    
    if (!myOrderData) {
        
        myOrderData = [[OrderData alloc] init];
        
        [OrderData reset];
    }
    return myOrderData;
}

+ (void)reset {
    
    myOrderData.state = OrderStatusUnknown;
    myOrderData.orderId = -1;
    myOrderData.startTime = -1;
    myOrderData.stopTime = -1;
    myOrderData.batonModel = -1;
    myOrderData.carId = @"";
    myOrderData.ifBlueTeeth = -1;
    myOrderData.authCode = @"";
    myOrderData.blueName = @"";
}

+ (BOOL)isDirty {
    
    return (OrderStatusNoOrder != [OrderData orderData].state) ? YES : NO;
}

@end
