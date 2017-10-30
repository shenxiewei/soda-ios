//
//  BillModelDetailed.h
//  JoyMove
//
//  Created by cty on 15/11/13.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModelDetailed : NSObject

//超出费用
@property (nonatomic,assign)  double extendFee;
//夜租费用
@property (nonatomic,assign)  double nightFee;

//时间费用
@property (nonatomic,assign)  double timeFee;
////时间费用二
//@property (nonatomic,assign)  double timeFeeSecond;
////时间费用三
//@property (nonatomic,assign)  double timeFeeThird;

//时间费用单分钟单价
@property (nonatomic,assign)  double timePrice;
////时间费用单分钟单价第二
//@property (nonatomic,assign)  double timePriceSecond;
////时间费用单分钟单价第三
//@property (nonatomic,assign)  double timePriceThird;

//最低消费
@property (nonatomic,assign)  double rentMinRate;
//超出后小时单价
@property (nonatomic,assign)  double hourPrice;
//总费用
@property (nonatomic,assign)  double totalFee;
//日租费用
@property (nonatomic,assign)  double dayFee;
//日租价格
@property (nonatomic,assign)  double dailyPrice;

//公里费用
@property (nonatomic,assign)  double mileageFee;
////公里费用第二
//@property (nonatomic,assign)  double mileageFeeSecond;
////公里费用第三
//@property (nonatomic,assign)  double mileageFeeThird;

//日租优惠费率
@property (nonatomic,assign)  double dailyRate;

//公里单价
@property (nonatomic,assign)  double mileagePrice;
////公里单价第二
//@property (nonatomic,assign)  double mileagePriceSecond;
////公里单价第三
//@property (nonatomic,assign)  double mileagePriceThird;

//夜间单价
@property (nonatomic,assign) double nightPrice;

- (BillModelDetailed *)initWithDictionary:(NSDictionary *)dictionary;

@end
