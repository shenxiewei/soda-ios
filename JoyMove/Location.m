//
//  Location.m
//  PetBar
//
//  Created by eThEn on 14/11/11.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import "Location.h"
#import <UIKit/UIKit.h>
#import "UtilsMacro.h"
#import "WGS84TOGCJ02.h"

@implementation Location {
    
    CLLocationManager *_locationManager;
}

- (BOOL)update {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        if (kAboveIOS8) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
        
        return YES;
    }else {
        
        NSLog(@"定位不可用");
        
        return NO;
    }
}

- (void)stop {
    
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    _locationManager = nil;
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count) {
        
        CLLocation *location = [locations objectAtIndex: 0];
        CLLocationCoordinate2D coor = location.coordinate;
        
        //判断是不是属于国内范围
        if (![WGS84TOGCJ02 isLocationOutOfChina:coor]) {
            
            //WGS-84转GCJ-02(火星坐标)
            coor = [WGS84TOGCJ02 transformFromWGSToGCJ:coor];
        }
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didUpdateUserLocation:)]) {
            
            [self.delegate didUpdateUserLocation:coor];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"没有开启位置授权");
}

@end
