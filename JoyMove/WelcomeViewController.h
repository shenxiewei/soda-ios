//
//  WelcomeViewController.h
//  JoyMove
//
//  Created by ethen on 15/3/18.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (nonatomic,copy) void (^loginNilBlock)();

- (void)showInView:(UIView *)view;
- (void)hide;

@end
