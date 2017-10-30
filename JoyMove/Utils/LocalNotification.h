//
//  LocalNotification.h
//  JoyMove
//
//  Created by ethen on 15/6/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject

+ (void)postLocalNotification:(NSString *)alertBody badge:(NSInteger)number delay:(NSTimeInterval)timeInterval;

@end
