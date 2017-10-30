//
//  WGS84TOGCJ02.h
//  JoyMove
//
//  Created by ethen on 15/5/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject

//判断是否已经超出中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

//将WGS-84(GPS坐标)转为GCJ-02(火星坐标，高德)
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
    
//将GCJ-02(火星坐标，高德)转为WGS-84(GPS坐标)
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)gcjLoc;

@end
