//
//  Target_ReturnCarInfo.m
//  JoyMove
//
//  Created by Soda on 2017/9/14.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_ReturnCarInfo.h"
#import "ReturnCarInfoVC.h"

@implementation Target_ReturnCarInfo

- (UIViewController *)Action_returnCarInfoViewController:(NSDictionary *)params
{
    ReturnCarInfoVC *vc = [[ReturnCarInfoVC alloc] init];
    return vc;
}

@end
