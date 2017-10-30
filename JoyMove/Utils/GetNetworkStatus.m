//
//  GetNetworkStatus.m
//  JoyMove
//
//  Created by ethen on 15/5/25.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "GetNetworkStatus.h"

@implementation GetNetworkStatus

+ (NetworkStatus)getCurrentNetworkStatus {
    
    Reachability *r = [Reachability reachabilityWithHostName:@"http://baidu.com"];
    return [r currentReachabilityStatus];
}

@end
