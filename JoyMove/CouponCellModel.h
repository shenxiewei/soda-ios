//
//  CouponCellModel.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponCellModel : NSObject

@property(nonatomic,assign)NSInteger couponId;
/*天元测试*/
@property(nonatomic,assign)NSInteger couponBalance;
//@property(nonatomic,assign)NSInteger couponBalance;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *overdueTime;
//@property(nonatomic,assign)BOOL usable;

- (CouponCellModel *)initWithDictionary:(NSDictionary *)dic;

@end
