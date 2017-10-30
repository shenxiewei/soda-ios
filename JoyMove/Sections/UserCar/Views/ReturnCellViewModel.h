//
//  ReturnCellViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/14.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface ReturnCellViewModel : SDCViewModel

@property(strong, nonatomic) RACCommand *returnCommand;
@property(strong, nonatomic) RACSubject *parkInfoSuccessSubject;

@end
