//
//  GetNetworkStatus.h
//  JoyMove
//
//  Created by ethen on 15/5/25.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface GetNetworkStatus : NSObject

+ (NetworkStatus)getCurrentNetworkStatus;

@end
