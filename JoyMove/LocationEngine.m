//
//  LocationEngine.m
//  JoyMove
//
//  Created by ethen on 15/6/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "LocationEngine.h"
#import "LocalNotification.h"
#import "SearchModel.h"
#import "Macro.h"

@interface LocationEngine () {
    
    CLLocationCoordinate2D _userLocationCoor;
    NSTimer *_timer;
    CLLocation *_stopLocation;
}

@end

@implementation LocationEngine

const float timeInterval = 10.f;                 /**< 心跳的间隔 */
const float showTime = 5.f;                      /**< show的时间 */

- (void)setStop:(CLLocation *)location {
    
    _stopLocation = location;
}

- (void)setUserLocation: (CLLocationCoordinate2D)coor {
    
    _userLocationCoor = coor;
}

- (void)start {
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(identify) userInfo:nil repeats:YES];
}

- (void)stop {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)identify {
    
    //无stop数据时,结束timer
    if (!_stopLocation) {
        
        [self stop];
        
        return;
    }
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_userLocationCoor.latitude longitude:_userLocationCoor.longitude];
    
    CLLocationCoordinate2D coor = _stopLocation.coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    CLLocationDistance kilometers = [userLocation distanceFromLocation:location];
    
    if (kilometers<nearTheStopDistance) {
        
        [LocalNotification postLocalNotification:@"已步行到目标车辆附近，可以开始租用" badge:0 delay:0];
        _stopLocation = nil;
        [self stop];
    }
}

@end
