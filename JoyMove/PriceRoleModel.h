//
//  PriceRoleModel.h
//  JoyMove
//
//  Created by 赵霆 on 15/12/29.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceRoleModel : NSObject

@property (nonatomic, assign) double mileagePrice;
@property (nonatomic, assign) double timePrice;

- (PriceRoleModel *)initWithDictionary:(NSDictionary *)dictionary;
@end
