//
//  PayViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/17.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface PayViewModel : SDCViewModel

@property(nonatomic ,strong) RACCommand *checkPackageCommand;
@property(nonatomic ,strong) RACCommand *purchasePackageCommand;
@property(nonatomic ,strong) RACCommand *balanceCommand;

@property(nonatomic ,strong)RACSubject *balanceSubject;
@property(nonatomic, strong)RACSubject *allPackageSubject;

@property(nonatomic, strong)RACSubject *paySuccessSubject;
@end
