//
//  OrderHistoryModel.m
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OrderHistoryModel.h"
#import "SearchModel.h"
#import "UtilsMacro.h"

@implementation OrderHistoryModel

- (OrderHistoryModel *)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.carId = dictionary[@"carId"];
        self.fee = kDoubleFormObject(dictionary[@"fee"]);
        self.orderId = IntegerFormObject(dictionary[@"orderId"]);
        self.startLatitude = kDoubleFormObject(dictionary[@"startLatitude"]);
        self.startLongitude = kDoubleFormObject(dictionary[@"startLongitude"]);
        self.stopLatitude = kDoubleFormObject(dictionary[@"stopLatitude"]);
        self.stopLongitude = kDoubleFormObject(dictionary[@"stopLongitude"]);
        self.startTime = kDoubleFormObject(dictionary[@"startTime"]);
        self.stopTime = kDoubleFormObject(dictionary[@"stopTime"]);
        self.miles = kDoubleFormObject(dictionary[@"miles"]);
        self.payFee = kDoubleFormObject(dictionary[@"payFee"]);
        self.couponFee = kDoubleFormObject(dictionary[@"couponPayFee"]);
        
        NSString *destinations = dictionary[@"destinations"];
        if (destinations && [destinations isKindOfClass:[NSString class]]) {
                
            NSData *data = [destinations dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSMutableArray *mutableArray = [@[] mutableCopy];
            for (NSDictionary *dic in array) {
                
                SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                [mutableArray addObject:model];
            }
            self.destinations = mutableArray;
        }else {
            
            self.destinations = @[];
        }
    }
    
    return self;
}

@end
