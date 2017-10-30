//
//  PriceRoleModel.m
//  JoyMove
//
//  Created by 赵霆 on 15/12/29.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "PriceRoleModel.h"
#import "Macro.h"

@implementation PriceRoleModel

- (PriceRoleModel *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.mileagePrice= kDoubleFormObject(dictionary[@"mileagePrice"]);
        self.timePrice= kDoubleFormObject(dictionary[@"timePrice"]);

    }
    return self;
}

@end
