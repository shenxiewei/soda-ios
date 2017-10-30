//
//  MessageCellMode.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "MessageCellMode.h"
#import "Macro.h"

@implementation MessageCellMode

- (MessageCellMode *)initWithDitionary:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        self.message = dic[@"content"] != [NSNull null] ? dic[@"content"]:@"(无)";
        self.date = dic[@"createTime"] != [NSNull null] ? dic[@"createTime"]:@"(无)";
        NSTimeInterval timer = kDoubleFormObject(dic[@"messageDate"]);
        self.date = [self getRangeOfTimeString:[self timeStringFromDateFormat:timer]];
        self.messageTitle = [self typeForMessage:dic[@"type"] != [NSNull null] ? dic[@"type"]:@"0"];
    }
    return self;
}
- (NSString *)timeStringFromDateFormat:(NSTimeInterval)interval {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

- (NSString *)getRangeOfTimeString:(NSString *)timeString {
    
    NSString *str = [timeString substringWithRange:NSMakeRange(0, 10)];
    return str;
}

- (NSDictionary *)dictionary {
    
    return @{@"content":self.message,
             @"createTime":self.date,
             @"type":self.messageTitle};
}

//message类型
- (NSString *)typeForMessage:(NSString *)type {

    if ([type isEqualToString:@"0"]) {
        
        return @"系统消息";
    }
    return @"个人消息";
}

@end
