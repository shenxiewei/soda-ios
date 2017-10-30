//
//  NSString+dataFormat.h
//  PetBar
//
//  Created by Juvham on 14-8-19.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dataFormat)

+ (NSString*)compareCurrentTime:(NSTimeInterval)timeInterval isCountdown:(BOOL)isCountdown;
+ (NSString*)compareStopTime:(NSTimeInterval)timeInterval startTime:(NSTimeInterval)timeInterval2;
+ (NSString*)compareTime:(NSTimeInterval)timeInterval isCountdown:(BOOL)isCountdown;

@end
