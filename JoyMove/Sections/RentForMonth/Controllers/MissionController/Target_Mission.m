//
//  Target_Mission.m
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "Target_Mission.h"
#import "MissionViewController.h"

@implementation Target_Mission

- (UIViewController *)Action_missionViewController:(NSDictionary *)params
{
    MissionViewController *vc = [[MissionViewController alloc] init];
    vc.missions = params[@"mission"];
    return vc;
}

@end
