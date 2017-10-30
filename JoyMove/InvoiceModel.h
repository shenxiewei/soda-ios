//
//  InvoiceModel.h
//  JoyMove
//
//  Created by 赵霆 on 16/4/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceModel : NSObject

/** 行程金额 */
@property (nonatomic, assign) double fee;
/** 行程ID */
@property (nonatomic, strong) NSNumber *orderId;
/** 行程起始时间 */
@property (nonatomic, assign) double startTime;
/** 行程结束时间 */
@property (nonatomic, assign) double stopTime;
/** 开票历史时间 */
@property (nonatomic, copy) NSString *time;
/** 开票金额 */
@property (nonatomic, assign) double count;
/** 开票状态字符串 */
@property (nonatomic, copy) NSString *state;

- (InvoiceModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
