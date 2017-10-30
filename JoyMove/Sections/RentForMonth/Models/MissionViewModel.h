//
//  MissionViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface MissionViewModel : SDCViewModel

@property(strong, nonatomic) RACCommand *missionCommand;

@end
