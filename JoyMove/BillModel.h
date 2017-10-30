//
//  BillModel.h
//  JoyMove
//
//  Created by ethen on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic, assign) NSInteger batonMode;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) double desLatitude;
@property (nonatomic, assign) double desLongitude;
@property (nonatomic, assign) double fee;
@property (nonatomic, assign) double mile;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval stopTime;
// 活动优惠字符串
@property (nonatomic, strong) NSString *discountString;
//判断是否要显示订单详细
@property (nonatomic,assign) NSString *feeDetails;

- (BillModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
