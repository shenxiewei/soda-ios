//
//  Target_MonthRent.m
//  JoyMove
//
//  Created by Soda on 2017/9/10.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_MonthRent.h"
#import "MonthRentVC.h"

@implementation Target_MonthRent
- (UIViewController *)Action_monthRentViewController:(NSDictionary *)params
{
    MonthRentVC *vc = [[MonthRentVC alloc] init];
    return vc;
}
@end
