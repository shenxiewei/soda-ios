//
//  OrderHistoryModel.h
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryModel : NSObject

@property (nonatomic, strong) NSString *carId;
@property (nonatomic, copy) NSArray *destinations;
@property (nonatomic, assign) double fee;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) double startLatitude;
@property (nonatomic, assign) double startLongitude;
@property (nonatomic, assign) double stopLatitude;
@property (nonatomic, assign) double stopLongitude;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval stopTime;
@property (nonatomic, assign) double miles;

@property (nonatomic, assign) double payFee;
@property (nonatomic, assign) double couponFee;

- (OrderHistoryModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
