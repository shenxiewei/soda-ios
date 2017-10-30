//
//  BillModelDetailed.m
//  JoyMove
//
//  Created by cty on 15/11/13.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "BillModelDetailed.h"
#import "UtilsMacro.h"

@implementation BillModelDetailed

- (BillModelDetailed *)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.extendFee=kDoubleFormObject(dictionary[@"extendFee"]);
        self.nightFee=kDoubleFormObject(dictionary[@"nightFee"]);
        self.timeFee=kDoubleFormObject(dictionary[@"timeFee"]);
        self.timePrice=kDoubleFormObject(dictionary[@"timePrice"]);
        self.rentMinRate=kDoubleFormObject(dictionary[@"rentMinRate"]);
        self.hourPrice=kDoubleFormObject(dictionary[@"hourPrice"]);
        self.totalFee=kDoubleFormObject(dictionary[@"totalFee"]);
        self.dayFee=kDoubleFormObject(dictionary[@"dayFee"]);
        self.dailyPrice=kDoubleFormObject(dictionary[@"dailyPrice"]);
        self.mileageFee=kDoubleFormObject(dictionary[@"mileageFee"]);
        self.dailyRate=kDoubleFormObject(dictionary[@"dailyRate"]);
        self.mileagePrice=kDoubleFormObject(dictionary[@"mileagePrice"]);
        self.nightPrice=kDoubleFormObject(dictionary[@"nightPrice"]);
    }
    
    return self;
}


@end
