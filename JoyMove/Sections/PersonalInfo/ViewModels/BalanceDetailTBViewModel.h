//
//  BalanceDetailTBViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface BalanceDetailTBViewModel : SDCViewModel

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) RACCommand *refreshDataCommand;
@property(nonatomic, strong) RACCommand *nextPageCommand;

@property(nonatomic, strong) RACSubject *refreshUISubject;
@property(nonatomic, strong) RACSubject *refreshEndSubject;

@end
