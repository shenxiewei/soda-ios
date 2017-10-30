//
//  ViewControllerServant.h
//  JoyMove
//
//  Created by ethen on 15/6/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//
//  ViewController类的工具类，意在解决该类代码臃肿问题

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <UIKit/UIKit.h>

@interface ViewControllerServant : NSObject

//获取用户与目标车的距离
+ (CLLocationDistance)distance: (CLLocationCoordinate2D)coorA fromCoor:(CLLocationCoordinate2D)coorB;

//计算两个坐标之间的距离
+ (double)distanceFromA:(CLLocationCoordinate2D)coorA toB:(CLLocationCoordinate2D)coorB;

//用户当前位置上方的头像
+ (UIImageView *)userImageView;

//途经点上方的头像
+ (UIImageView *)stopImageView;

//终点上方的头像
+ (UIImageView *)destinationImageView;

@end
