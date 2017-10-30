//
//  RankingModel.m
//  JoyMove
//
//  Created by 赵霆 on 16/6/12.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "RankingModel.h"

@implementation RankingModel

- (RankingModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.mileage = dic[@"mileage"] != [NSNull null] ? [NSString stringWithFormat:@"%@", dic[@"mileage"]] : @"";
        self.mobileNo = dic[@"mobileNo"] != [NSNull null] ? [NSString stringWithFormat:@"%@", dic[@"mobileNo"]] : @"";
        self.photo = dic[@"photo"] != [NSNull null] ? dic[@"photo"] : @"";
        self.praise = dic[@"praise"] != [NSNull null] ? dic[@"praise"] : @"";
        self.rank = dic[@"rank"] != [NSNull null] ? [NSString stringWithFormat:@"%@", dic[@"rank"]] : @"";
        
    }
    return self;
}

@end
