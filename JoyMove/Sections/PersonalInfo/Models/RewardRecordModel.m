//
//  RewardRecordModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/25.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "RewardRecordModel.h"

@implementation RewardRecordModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self)
    {
        self.taskName = params[@"taskName"];
        self.balance = [params[@"balance"] doubleValue];
        self.rewardTime = [params[@"rewardTime"] doubleValue];
    }
    return self;
}

- (NSString *)timeString
{
    _timeString = [NSString timeStamp:self.rewardTime/1000.0 DateFormat:@"yyyy-MM-dd HH:mm"];
    return _timeString;
}
@end
