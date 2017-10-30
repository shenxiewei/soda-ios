//
//  TimeButton.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "TimeButton.h"
#import "UtilsMacro.h"

#import "NSString+dataFormat.h"

@interface TimeButton () {
    
    NSTimeInterval timeInterval;
    NSTimer *timer;
    BOOL isWork;
}
@end

@implementation TimeButton

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -

- (void)setTime:(NSTimeInterval)time {
    
    isWork = YES;
    self.enabled = NO;
    self.buttonUsableStatus = NO;
    timeInterval = time;
    NSString *str = [NSString stringWithFormat:@"%.0f", timeInterval--];
        
    [self setTitle:str forState:UIControlStateNormal];
    self.backgroundColor = UIColorFromRGB(210, 210, 210);
    
    if (self && isWork) {
        
        [NSThread detachNewThreadSelector:@selector(poll) toTarget:self withObject:nil];
    }
}

- (void)stop:(NSString *)title {
    
    isWork = NO;
//    self.enabled = YES;
    self.buttonUsableStatus = YES;
    [self setTitle:title forState:UIControlStateNormal];
//    self.backgroundColor = UIColorFromRGB(236, 105, 65);
    [self.timeButtonDelegate updateTimeButtonStatus];
}

#pragma mark - 私有方法

- (void)poll {
    
    sleep(1);
    
    if (self && isWork) {
        
        [self performSelectorOnMainThread:@selector(updateLabelText) withObject:nil waitUntilDone:NO];
    }
}

- (void)updateLabelText {
    
    if (timeInterval >= 0) {
        
        NSString *str = [NSString stringWithFormat:@"%.0f", timeInterval--];
        [self setTitle:str forState:UIControlStateNormal];
        
        if (self && isWork) {
            
            [NSThread detachNewThreadSelector:@selector(poll) toTarget:self withObject:nil];
        }
    }else {
        
        [self stop:@"验证"];
    }
}

@end
