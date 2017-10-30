//
//  poiModel.m
//  JoyMove
//
//  Created by ethen on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "POIModel.h"
#import "WGS84TOGCJ02.h"
#import "Macro.h"

@implementation POIModel

- (POIModel *)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.carId = dictionary[@"carId"];
        self.desp = dictionary[@"desp"];
        self.latitude = kDoubleFormObject(dictionary[@"latitude"]);
        self.longitude = kDoubleFormObject(dictionary[@"longitude"]);
        self.eta = kDoubleFormObject(dictionary[@"eta"]);
        
        //待优化:电桩接口返回数据字段错误导致
        if (!self.latitude) {
            
            self.latitude = kDoubleFormObject(dictionary[@"positionY"]);
        }
        if (!self.longitude) {
            
            self.longitude = kDoubleFormObject(dictionary[@"positionX"]);
        }
        
        self.ifBlueTeeth = IntegerFormObject(dictionary[@"ifBlueTeeth"]);
        self.powerType = IntegerFormObject(dictionary[@"powerType"]);
        self.powerPercent = kDoubleFormObject(dictionary[@"powerPercent"]);
        self.carInfo = dictionary[@"carInfo"];
        self.imageUrl = dictionary[@"imageUrl"] != [NSNull null] ? dictionary[@"imageUrl"]:@"";
        self.addr = dictionary[@"addr"] != [NSNull null] ? dictionary[@"addr"] : @"空";
        self.operator = dictionary[@"operator"] != [NSNull null] ? dictionary[@"operator"] : @"空";
        self.parkingFee = dictionary[@"parkingFee"] != [NSNull null] ? dictionary[@"parkingFee"] : @"空";
        self.chargingFee = dictionary[@"chargingFee"] != [NSNull null] ? dictionary[@"chargingFee"] : @"空";
        self.slowChargeNum = dictionary[@"slowChargeNum"] != [NSNull null] ? IntegerFormObject(dictionary[@"slowChargeNum"]) : 0;
        self.fastChargeNum = dictionary[@"fastChargeNum"] != [NSNull null] ? IntegerFormObject(dictionary[@"fastChargeNum"]) : 0;
        
        self.priceRole = dictionary[@"priceRole"];
        self.mileagePrice = kDoubleFormObject(self.priceRole[@"mileagePrice"]);
        self.timePrice = kDoubleFormObject(self.priceRole[@"timePrice"]);
        self.priceUrl = self.priceRole[@"priceUrl"]!= [NSNull null] ? self.priceRole[@"priceUrl"]:@"";
        self.config = dictionary[@"config"];
        self.activityBtn = self.config[@"activityBtn"];
        
        self.agreementDic=dictionary[@"agreement"];
        self.agreement=self.agreementDic[@"url"];
        
        self.carIconDic=dictionary[@"td"];
        self.disSelectCarIcon=self.carIconDic[@"IMG_ICON_ID_NOR_IOS"];
        self.selectCarIcon=self.carIconDic[@"IMG_ICON_TD_PRE_IOS"];
        
        self.logo = dictionary[@"logo"] != [NSNull null] ? dictionary[@"logo"] : @"";
        
        self.owner=dictionary[@"owner"] != [NSNull null] ? dictionary[@"owner"] : @"";
        self.isChargingPile=dictionary[@"type"] != [NSNull null] ? IntegerFormObject(dictionary[@"type"]) : 0;
        
        
        
//        NSLog(@"66666666   %@",self.isChargingPile);
        
//        NSLog(@"7777777  %@",self.disSelectCarIcon);
//        NSLog(@"6666666  %@",self.selectCarIcon);
//        if (!self.disSelectCarIconData)
//        {
//             self.disSelectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.disSelectCarIcon]];
//        }
//        if (!self.selectCarIconData)
//        {
//            self.selectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.selectCarIcon]];
//        }
//        if ([self.desp isEqualToString:@"666666"])
//        {
//            self.disSelectCarIcon = @"http://share.sodacar.com:8082/joymove/pic/download/0ab99d93778742449363914359fe53d7.c";
//        }
        
       
        
    }
    
    return self;
}

- (void)transformToGCJ {
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    if (![WGS84TOGCJ02 isLocationOutOfChina:coor]) {
            
        coor = [WGS84TOGCJ02 transformFromWGSToGCJ:coor];
        self.latitude = coor.latitude;
        self.longitude = coor.longitude;
    }
}

- (BOOL)isEqual:(id)object {
    
    return [self.carId isEqualToString:((POIModel *)object).carId];
}

@end
