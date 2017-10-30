//
//  UserData.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

typedef NS_ENUM(NSInteger, DeopositStatus) {
    
    DeopositStatusUnknown = -1, //订单状态未知
    
    DeopositStatusFrozen = 0,
    DeopositStatusNormal = 1,
};


@interface UserData : NSObject

@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,assign)NSInteger genderIndex;
@property(nonatomic,copy)NSString *authToken;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *mobileNo;

@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,copy)NSString *provinceString;
@property (nonatomic,copy)NSString *cityString;
@property (nonatomic,copy)NSString *townString;

@property (nonatomic, assign) BOOL isRentForMonth;
@property (nonatomic, assign) double balance;

@property (nonatomic, strong)MAUserLocation *userLocation;

+ (UserData *)share;
//初始化
+ (UserData *)userData;
//判断是否登录
+ (BOOL)isLogin;
//登出清空userDefault
+ (void)logout;
//保存数据
+ (void)savaData;
//提取数据
+ (void)loadData;

@end
