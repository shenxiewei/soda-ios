//
//  TopBannerViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface TopBannerViewModel : SDCViewModel

@property(nonatomic, strong) RACCommand *refreshRentStatusCommand;
@property(nonatomic, strong) RACSubject *refreshSubject;

@property(nonatomic, strong) RACCommand *shareCarCommand;
@property(nonatomic, strong) RACCommand *unShareCarCommand;

@property(nonatomic, strong) RACSubject *shareCarSuccessSubject;
@property(nonatomic, strong) RACSubject *unShareCarSuccessSubject;

@property(nonatomic, strong) RACSubject *tapSubject;
@end
