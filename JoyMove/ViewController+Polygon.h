//
//  ViewController+Polygon.h
//  JoyMove
//
//  Created by ethen on 16/7/21.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "ViewController.h"

@class MAMapView;
@class MAPolygonView;
@class MAPolygon;

@interface ViewController (Polygon)

//在MAMapView对象上添加一个多边形
//注：points的fristObject和lastObject必须相同
- (void)addMAPolygonWithPoints:(NSArray *)points mapView:(MAMapView *)mapView;

//定制在MAMapView上显示的PolygonView对象
- (MAPolygonView *)customPolygonViewWithOverlay:(MAPolygon *)overlay;


- (void)requestFence:(NSString *)cityCode mapView:(MAMapView *)mapView;
@end
