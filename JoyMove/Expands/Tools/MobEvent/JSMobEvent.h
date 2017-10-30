//
//  JSMobEvent.h
//  JoyMove
//
//  Created by Darker on 2017/10/24.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMobEvent : NSObject

+(void)sendEvent:(NSString *)event attributes:(NSDictionary *)attrs;

+(void)beginLogn:(NSString *)strs;

+(void)endLogn:(NSString *)strs;
@end
