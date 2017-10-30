//
//  poiModel.h
//  JoyMove
//
//  Created by ethen on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIDefine.h"

@interface POIModel : NSObject


@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *desp;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSTimeInterval eta;
@property (nonatomic, assign) POIType type;
@property (nonatomic, assign) NSInteger ifBlueTeeth;
@property (nonatomic, strong) NSString *carInfo;
//电量
@property (nonatomic, assign) double powerPercent;
@property (nonatomic, assign) NSInteger powerType;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *operator;
@property (nonatomic, strong) NSString *parkingFee;
@property (nonatomic, strong) NSString *chargingFee;
@property (nonatomic, assign) NSInteger slowChargeNum;
@property (nonatomic, assign) NSInteger fastChargeNum;
/* 计费标准 **/
@property (nonatomic, copy) NSDictionary *priceRole;
@property (nonatomic, assign) double mileagePrice;
@property (nonatomic, assign) double timePrice;
@property (nonatomic, strong) NSString *priceUrl;
// 动态button
@property (nonatomic, copy) NSDictionary *config;
@property (nonatomic, strong) NSString *activityBtn;

//用户协议
@property (nonatomic, copy) NSDictionary *agreementDic;
@property (nonatomic, strong) NSString *agreement;
//车辆动态icon
@property (nonatomic,copy) NSDictionary *carIconDic;
@property (nonatomic,copy) NSString *disSelectCarIcon;
@property (nonatomic,copy) NSString *selectCarIcon;
@property (nonatomic,copy) NSData *disSelectCarIconData;
@property (nonatomic,copy) NSData *selectCarIconData;
/* 车队logo **/
@property (nonatomic,copy) NSString *logo;

//是否是充电桩
@property (nonatomic) NSInteger isChargingPile;
//停车场，车队
@property (nonatomic,strong) NSString *owner;


- (POIModel *)initWithDictionary:(NSDictionary *)dictionary;
//- (void)transformToGCJ;     //e2e模式下，服务器返回的坐标是wgs坐标，需本地转换为gcj（高德）坐标
- (BOOL)isEqual:(id)object;

@end
