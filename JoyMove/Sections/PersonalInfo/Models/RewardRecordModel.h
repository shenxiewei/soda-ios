//
//  RewardRecordModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/25.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCModel.h"

@interface RewardRecordModel : SDCModel

@property(strong, nonatomic)NSString *taskName;
@property(nonatomic, nonatomic)double balance;
@property(nonatomic, nonatomic)double rewardTime;
@property(strong, nonatomic) NSString *timeString;

@end
