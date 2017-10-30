//
//  NearbyCarListViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/6/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"
#import "POIModel.h"
#import <CoreLocation/CLLocation.h>

typedef NS_ENUM(NSInteger, ShowType) {
    //控制展示类型：车 充电桩 停车场
    ShowTypeCars = 10000,
    ShowTypePowerbars,
    ShowTypeParks
};

@protocol NearbyCarDelegate <NSObject>

- (void)didSelectNearbyCar:(POIModel *)poiModel;

@end

@interface NearbyCarListViewController : BaseViewController

//判断是否从一键租车失败页面push过来的，如果是，BOOL=YES
@property (nonatomic) BOOL isAKeyRentCarFailure;
//判断是否是从还车失败页面push过来的，如果是，BOOL=YES
@property (nonatomic) BOOL isReturnCarFailure;
@property (nonatomic,assign) CLLocationCoordinate2D userLocationCoor;    //用户位置
@property (nonatomic,assign) id <NearbyCarDelegate> nearbyCarDelegate;
@property (nonatomic,assign) ShowType showType;                          //展示类型

@end
