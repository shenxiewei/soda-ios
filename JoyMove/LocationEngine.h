//
//  LocationEngine.h
//  JoyMove
//
//  Created by ethen on 15/6/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationEngine : NSObject

- (void)setStop:(CLLocation *)location;
- (void)setUserLocation: (CLLocationCoordinate2D)coor;
- (void)start;
- (void)stop;

@end
