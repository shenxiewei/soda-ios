//
//  DriveViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/19.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
// <驾驶证认证>
#import "BaseViewController.h"

@protocol DriverDelegate <NSObject>

- (void)didUploadDriverLicense;

@end

@interface DriveViewController : BaseViewController

@property(nonatomic,assign) BOOL isPresentView;
@property(nonatomic,assign)id <DriverDelegate> driverDelegate;

@end
