//
//  BillModel.m
//  JoyMove
//
//  Created by ethen on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BillModel.h"
#import "UtilsMacro.h"

@implementation BillModel

- (BillModel *)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.batonMode = IntegerFormObject(dictionary[@"batonMode"]);
        self.carId = dictionary[@"carId"];
        self.orderId = IntegerFormObject(dictionary[@"orderId"]);
        self.fee = kDoubleFormObject(dictionary[@"fee"]);
        self.mile = kDoubleFormObject(dictionary[@"mile"]);
        self.startTime = kDoubleFormObject(dictionary[@"startTime"]);
        self.stopTime = kDoubleFormObject(dictionary[@"stopTime"]);
        //判断是否有详情
        self.feeDetails=dictionary[@"feeDetails"];
        self.discountString = dictionary[@"discount"];
    }
    
    return self;
}

@end
