//
//  DepositData.m
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "DepositData.h"
static DepositData *_depositData = nil;

@implementation DepositData
+ (DepositData *)shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _depositData = [[DepositData alloc] init];
    });
    
    return _depositData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
