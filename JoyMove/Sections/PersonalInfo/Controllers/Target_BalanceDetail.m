//
//  Target_BalanceDetail.m
//  JoyMove
//
//  Created by Soda on 2017/10/22.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_BalanceDetail.h"

#import "BalanceDetailVC.h"

@implementation Target_BalanceDetail

- (UIViewController *)Action_balanceDetailViewController:(NSDictionary *)params
{
    BalanceDetailVC *vc = [[BalanceDetailVC alloc] init];
    if(params)
    {
        vc.isMessage = params[@"isMessage"];
        vc.dataArray = params[@"data"];
    }
    return vc;
}

@end
