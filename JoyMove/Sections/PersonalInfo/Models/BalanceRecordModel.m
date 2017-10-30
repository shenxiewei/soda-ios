//
//  BalanceRecordModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceRecordModel.h"
#import "NSString+Base.h"

@implementation BalanceRecordModel

- (id)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.amount = [params[@"amount"] doubleValue];
        self.createTime = [params[@"createTime"] doubleValue];
        self.tradeType = [params[@"type"] integerValue];
    }
    return self;
}

#pragma mark - getter & setter
- (NSString *)amountString
{
//    NSString *temp = @"-";
//    if (self.tradeType == RecordTradeTypeCharge ||
//        self.tradeType == RecordTradeTypeShareIncome ||
//        self.tradeType == RecordTradeTypeUnFreeze) {
//        temp = @"+";
//    }
    _amountString =[NSString stringWithFormat:@"%.2f元",self.amount];
    return _amountString;
}

- (NSString *)tradeName
{
    if (self.tradeType == RecordTradeTypeCharge) {
       _tradeName = @"充值";
    }else if (self.tradeType == RecordTradeTypeShareIncome)
    {
        _tradeName = @"共享收入";
    }else if (self.tradeType == RecordTradeTypeFreeze)
    {
        _tradeName = @"冻结";
    }else if (self.tradeType == RecordTradeTypeUnFreeze)
    {
        _tradeName = @"解冻";
    }else if (self.tradeType == RecordTradeTypeWithhold)
    {
        _tradeName = @"扣款";
    }else if (self.tradeType == RecordTradeTypePackagePay)
    {
        _tradeName = @"套餐支付";
    }else if (self.tradeType == RecordTradeTypeOrderPay)
    {
        _tradeName = @"订单支付";
    }else if (self.tradeType == RecordTradeTypeMissionReward)
    {
        _tradeName = @"任务奖励";
    }
    return _tradeName;
}

- (NSString *)timeString
{
    _timeString = [NSString timeStamp:self.createTime/1000.0 DateFormat:@"yyyy-MM-dd HH:mm"];
    return _timeString;
}

@end
