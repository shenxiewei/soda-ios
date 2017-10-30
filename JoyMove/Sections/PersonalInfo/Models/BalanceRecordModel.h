//
//  BalanceRecordModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCModel.h"

typedef NS_ENUM (NSUInteger, RecordTradeType){
    RecordTradeTypeCharge = 1,
    RecordTradeTypeShareIncome,
    RecordTradeTypeFreeze,
    RecordTradeTypeUnFreeze,
    RecordTradeTypeWithhold,
    RecordTradeTypePackagePay,
    RecordTradeTypeOrderPay,
    RecordTradeTypeMissionReward,
};

@interface BalanceRecordModel : SDCModel

@property(nonatomic, assign) RecordTradeType tradeType;
@property(nonatomic, assign) double amount;
@property(nonatomic, assign) double createTime;
@property(nonatomic, copy) NSString *amountString;
@property(nonatomic, copy) NSString *tradeName;
@property(nonatomic, copy) NSString *timeString;

@end
