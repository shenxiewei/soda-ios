//
//  OrderData.h
//  JoyMove
//
//  Created by ethen on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIModel.h"

typedef NS_ENUM(NSInteger, OrderStatus) {
    
    OrderStatusUnknown = -1, //订单状态未知
    
    OrderStatusNoOrder = 0,  //
    OrderStatusRent,
    OrderStatusWaitingForPayment,
    OrderStatusRequestRent,
    OrderStatusRequestTerminate,
};

@interface OrderData : NSObject

@property (nonatomic, assign) OrderStatus state;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval stopTime;
@property (nonatomic, assign) NSInteger batonModel;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *blueName;
@property (nonatomic, assign) NSInteger ifBlueTeeth;
@property (nonatomic, assign) BOOL isWriting;

//初始化
+ (OrderData *)orderData;
//重置
+ (void)reset;
//是否有未结清的订单
+ (BOOL)isDirty;

@end
