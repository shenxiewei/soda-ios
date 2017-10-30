//
//  BalanceViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface BalanceViewModel : SDCViewModel

@property(nonatomic, strong) RACCommand *checkBalanceCommand;

@property(nonatomic, strong) RACSubject *successSubject;

@end
