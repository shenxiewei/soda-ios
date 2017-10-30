//
//  LocalNotification.m
//  JoyMove
//
//  Created by ethen on 15/6/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "LocalNotification.h"

@implementation LocalNotification

+ (void)postLocalNotification:(NSString *)alertBody badge:(NSInteger)number delay:(NSTimeInterval)timeInterval {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    
    if (notification) {
        
        // 设置推送时间
        notification.fireDate = pushDate;
        
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 推送内容
        notification.alertBody = alertBody;
        
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = number;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        //        NSDictionary *info = [NSDictionary dictionaryWithObject:@"category"forKey:@"MeetingInvite"];
        //        notification.userInfo = info;
        
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

@end
