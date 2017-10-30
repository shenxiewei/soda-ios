//
//  TabShareViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface TabShareViewModel : SDCViewModel

@property(nonatomic, strong) RACCommand *messageCommand;
@property(nonatomic, strong) RACSubject *messageSubject;

@property(nonatomic, strong) RACCommand *missionCommand;
@property(nonatomic, strong) RACSubject *missionSubject;

@property(nonatomic, strong) RACCommand *shareCarCommand;
@property(nonatomic, strong) RACCommand *unShareCarCommand;

@property(nonatomic, strong) RACSubject *shareCarSuccessSubject;
@property(nonatomic, strong) RACSubject *unShareCarSuccessSubject;

@property(nonatomic, strong) RACCommand *checkBalanceCommand;

@property(nonatomic, strong) RACSubject *successSubject;
@end
