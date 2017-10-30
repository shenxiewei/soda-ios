//
//  LoginViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
// <登录>

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

//登陆成功回调事件
@property (copy,nonatomic) void (^pushRootViewController)();

@end
