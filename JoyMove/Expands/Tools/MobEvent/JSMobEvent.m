//
//  JSMobEvent.m
//  JoyMove
//
//  Created by Darker on 2017/10/24.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "JSMobEvent.h"
#import "UMMobClick/MobClick.h"

@implementation JSMobEvent

+(void)sendEvent:(NSString *)event attributes:(NSDictionary *)attrs{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (attrs.allKeys.count) {
            [MobClick event:event attributes:attrs];
        }else{
            [MobClick event:event];
        }
    });
}
+(void)beginLogn:(NSString *)strs{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (strs) {
            [MobClick beginLogPageView:strs];
        }
    });
}

+(void)endLogn:(NSString *)strs{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (strs) {
            [MobClick endLogPageView:strs];
        }
    });
}

@end
