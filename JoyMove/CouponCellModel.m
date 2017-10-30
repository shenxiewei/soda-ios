//
//  CouponCellModel.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CouponCellModel.h"
#import "NSString+dataFormat.h"
#import "UtilsMacro.h"

@implementation CouponCellModel

- (CouponCellModel *)initWithDictionary:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        self.couponId = IntegerFormObject(dic[@"couponId"]);
        /*天元测试*/
//        self.couponBalance = IntegerFormObject(dic[@"couponBalance"]);
        self.couponBalance=kDoubleFormObject(dic[@"couponBalance"]);
        if ([dic[@"overdueTime"] isKindOfClass:[NSString class]]) {
            
            self.overdueTime = [self getRangeOfTimeString:dic[@"overdueTime"]];
//            self.usable = NO;
        }else {
            
            NSTimeInterval date = kDoubleFormObject(dic[@"overdueTime"]);
//            NSTimeInterval nowDate = [[NSDate date] timeIntervalSince1970];
//            if (nowDate > date) {
//                
//                self.usable = NO;
//            }else {
//                
//                self.usable = YES;
//            }
            self.overdueTime = [self timeStringFromDateFormat:date];
        }
        if ([dic[@"couponExpDate"] isKindOfClass:[NSString class]]) {
            
            self.startTime = [self getRangeOfTimeString:dic[@"couponExpDate"]];
//            self.usable = NO;
        }else {
            
            NSTimeInterval date = kDoubleFormObject(dic[@"couponExpDate"]);
//            NSTimeInterval nowDate = [[NSDate date] timeIntervalSince1970];
//            if (nowDate > date) {
//                
//                self.usable = NO;
//            }else {
//                
//                self.usable = YES;
//            }
            self.startTime = [self timeStringFromDateFormat:date];
        }
    }
    return self;
}

- (NSString *)timeStringFromDateFormat:(NSTimeInterval)interval {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";  //yyyy-MM-dd HH:mm:ss
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

- (NSString *)getRangeOfTimeString:(NSString *)timeString {
    
    NSString *str = [timeString substringWithRange:NSMakeRange(0, 10)];
    return str;
}

@end
