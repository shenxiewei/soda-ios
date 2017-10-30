//
//  TimeButton.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeButtonDelegate <NSObject>

- (void)updateTimeButtonStatus;

@end

@interface TimeButton : UIButton

@property(nonatomic,assign)BOOL buttonUsableStatus;
@property(nonatomic,assign)id<TimeButtonDelegate> timeButtonDelegate;

- (void)setTime:(NSTimeInterval)time;
- (void)stop:(NSString *)title;

@end
