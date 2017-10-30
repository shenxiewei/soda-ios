//
//  Tool.m
//  JoyMove
//
//  Created by cty on 15/12/30.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)setCache:(NSString *)key value:(id)value{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (value==nil) {
        [setting removeObjectForKey:key];
    }
    else
    {
        [setting setObject:value forKey:key];
    }
    [setting synchronize];
}

+ (id)getCache:(NSString *)key{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:key];
    return value;
}

+ (void)removeCache:(NSString *)key
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:key];
    if (value) {
        [setting removeObjectForKey:key];
        [setting synchronize];
    }
}

@end
