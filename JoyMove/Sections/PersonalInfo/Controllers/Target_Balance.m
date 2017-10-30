//
//  Target_Balance.m
//  JoyMove
//
//  Created by Soda on 2017/10/22.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_Balance.h"
#import "BalanceViewController.h"

@implementation Target_Balance

- (UIViewController *)Action_balanceViewController:(NSDictionary *)params
{
    BalanceViewController *vc = [[BalanceViewController alloc] init];
    return vc;
}


@end
