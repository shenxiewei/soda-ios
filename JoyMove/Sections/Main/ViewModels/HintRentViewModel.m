//
//  HintRentViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/30.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "HintRentViewModel.h"

@implementation HintRentViewModel


- (RACSubject *)tapSubject
{
    if (!_tapSubject) {
        _tapSubject = [[RACSubject alloc] init];
    }
    return _tapSubject;
}
@end
