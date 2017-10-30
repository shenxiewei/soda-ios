//
//  Tool.h
//  JoyMove
//
//  Created by cty on 15/12/30.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (void)setCache:(NSString *)key value:(id)value;
+ (id)getCache:(NSString *)key;
+ (void)removeCache:(NSString *)key;

@end
