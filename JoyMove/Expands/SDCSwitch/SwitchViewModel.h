//
//  SwitchViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/27.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface SwitchViewModel : SDCViewModel

@property(nonatomic, strong) RACCommand *shareCarCommand;
@property(nonatomic, strong) RACCommand *unShareCarCommand;

@property(nonatomic, strong) RACSubject *shareCarSuccessSubject;
@property(nonatomic, strong) RACSubject *unShareCarSuccessSubject;

@end
