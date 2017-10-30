//
//  SDCSwitch.h
//  JoyMove
//
//  Created by Soda on 2017/10/27.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDCSwitch : UIView

@property(nonatomic, assign) BOOL isOn;
- (void)startAnimation;
- (void)updateStatus;

@end
