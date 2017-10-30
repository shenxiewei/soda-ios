//
//  Budget.h
//  JoyMove
//
//  Created by ethen on 15/3/24.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Budget : NSObject

@property (nonatomic, assign) NSString *fee;

+ (float)costWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)requestForTheCost;

@end
