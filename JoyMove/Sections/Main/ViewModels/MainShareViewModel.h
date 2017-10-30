//
//  MainShareViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface MainShareViewModel : SDCViewModel

@property(strong, nonatomic) RACCommand *packageCommand;
@property(strong, nonatomic) RACCommand *balanceCommand;
@property(strong, nonatomic) RACCommand *messageCommand;

@property(strong, nonatomic) RACSubject *packageSubject;

@end
