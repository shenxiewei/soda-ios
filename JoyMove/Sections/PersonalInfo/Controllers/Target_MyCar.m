//
//  Target_MyCar.m
//  JoyMove
//
//  Created by Soda on 2017/10/22.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_MyCar.h"

#import "MyCarVC.h"

@implementation Target_MyCar

- (UIViewController *)Action_myCarViewController:(NSDictionary *)params
{
    MyCarVC *vc = [[MyCarVC alloc] init];
    return vc;
}

@end
