//
//  IntegralMallCellModel.m
//  JoyMove
//
//  Created by cty on 15/12/15.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "IntegralMallCellModel.h"

@implementation IntegralMallCellModel

- (IntegralMallCellModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
//        self.points = dic[@"point"] != [NSNull null] ? dic[@"point"] : @"";
        self.name = dic[@"name"] != [NSNull null] ? dic[@"name"] : @"";
        self.desc = dic[@"desc"] != [NSNull null] ? dic[@"description"] : @"";
        self.goodsId=dic[@"id"] !=[NSNull null] ? dic[@"id"] : @"";
        self.points=dic[@"point"]!=[NSNull null]?dic[@"point"]:@"";
    }
    return self;
}

@end
