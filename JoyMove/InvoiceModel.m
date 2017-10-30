//
//  InvoiceModel.m
//  JoyMove
//
//  Created by 赵霆 on 16/4/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "InvoiceModel.h"
#import "Macro.h"

@implementation InvoiceModel

- (InvoiceModel *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.fee = kDoubleFormObject(dictionary[@"fee"]);
        self.orderId = dictionary[@"orderId"];
        
        self.startTime = kDoubleFormObject(dictionary[@"startTime"]);
        self.stopTime = kDoubleFormObject(dictionary[@"stopTime"]);
        
        self.time = dictionary[@"time"] != [NSNull null] ? dictionary[@"time"] : @"";
        self.count = kDoubleFormObject(dictionary[@"count"]);
        self.state = dictionary[@"state"] != [NSNull null] ? dictionary[@"state"] : @"";
    }
    return self;
}

@end
