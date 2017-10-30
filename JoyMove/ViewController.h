//
//  ViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CoreLocation/CLLocation.h>

typedef NS_ENUM(NSInteger, WayToTravel) {
    
    Drive = 100,    //行车导航
    Walk,           //步行
    GO,             //前往（停车场、充电站）
};

@interface ViewController : BaseViewController

- (NSArray *)getCarLocation;
- (NSDictionary *)getUserLocation;

@end

