//
//  MissionWebViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/23.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface MissionWebViewModel : SDCViewModel

@property(strong, nonatomic) RACCommand *completeTaskCommand;

@property(strong, nonatomic) RACSubject *completeTaskSubject;

@property(strong, nonatomic) RACCommand *getRewardCommand;

@property(strong, nonatomic) RACSubject *getRewardSubject;

@property(strong, nonatomic) RACCommand *getOneTaskCommand;

@property(strong, nonatomic) RACSubject *getOneTaskSubject;

@end
