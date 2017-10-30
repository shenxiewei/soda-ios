//
//  IntegralMallCellModel.h
//  JoyMove
//
//  Created by cty on 15/12/15.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralMallCellModel : NSObject

//优惠劵金额
@property (nonatomic,strong) NSNumber *points;
//使用时间
@property (nonatomic,strong) NSString *name;
//需要多少积分
@property (nonatomic,strong) NSString *desc;
//商品id
@property (nonatomic,strong) NSString *goodsId;

- (IntegralMallCellModel *)initWithDictionary:(NSDictionary *)dic;

@end
