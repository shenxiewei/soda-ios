//
//  NSString+dataFormat.m
//  PetBar
//
//  Created by Juvham on 14-8-19.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import "NSString+dataFormat.h"

@implementation NSString (dataFormat)

+ (NSString*)compareCurrentTime:(NSTimeInterval)timeInterval isCountdown:(BOOL)isCountdown {
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    timeInterval = timeInterval - nowTime;
    
    return [NSString compareTime:timeInterval isCountdown:isCountdown];
}

+ (NSString*)compareStopTime:(NSTimeInterval)timeInterval startTime:(NSTimeInterval)timeInterval2 {
    
    timeInterval = timeInterval - timeInterval2;
    
    return [NSString compareTime:timeInterval isCountdown:YES];
}

+ (NSString*)compareTime:(NSTimeInterval)timeInterval isCountdown:(BOOL)isCountdown {

    //NSLog(@"DIDA");
    
    if (isCountdown) {
        
        if (timeInterval <= 0) {
            
            return @"";
        }
    }else {
        
        if (timeInterval >= 0) {
            
            return @"";
        }else {
            
            timeInterval = -timeInterval;
        }
    }
    
    
    int hours = 0;
    int minutes = 0;
//    int seconds = 0;
    NSString *result;
    
    if (timeInterval >= (60 * 60)) {
        
        hours = timeInterval / (60 * 60);
        result = [NSString stringWithFormat:@"%i %@", hours, NSLocalizedString(@"h", nil)];
        timeInterval = (int)timeInterval % (60 * 60);
    }
    if (timeInterval >= 60) {
        
        minutes = timeInterval / 60;
        result = result.length ? [NSString stringWithFormat:@"%@ %i %@", result, minutes, NSLocalizedString(@"min", nil)] : [NSString stringWithFormat:@"%i %@", minutes, NSLocalizedString(@"min", nil)];
        timeInterval = (int)timeInterval % 60;
    }
//    seconds = (int)timeInterval;
    result = result.length ? result : @"";
    
    return result;
}

@end
