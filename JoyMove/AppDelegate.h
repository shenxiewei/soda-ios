//
//  AppDelegate.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MiPushSDKDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@end

