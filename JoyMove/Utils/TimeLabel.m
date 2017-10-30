//
//  TimeLable.m
//  ResignView
//
//  Created by ethen on 15/2/4.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "TimeLabel.h"
#import "NSString+dataFormat.h"
#import "LXRequest.h"
#import "Macro.h"
#import "Budget.h"

@interface TimeLabel() {
    
    NSTimeInterval timeInterval;
    NSTimer *timer;
    BOOL isWork;
//    NSString *_fee;
//    NSString *_mile;
}
@end

@implementation TimeLabel

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

#pragma mark -

- (void)setTime:(NSTimeInterval)time {
    
    isWork = YES;
    self.hidden = NO;
    timeInterval = time;
    
    [self handle];
    [self requestForTheCostcompleteHandle:nil];
}

- (void)stop {
    
    isWork = NO;
    self.hidden = YES;
}

#pragma mark - 私有方法

- (void)handle {
    
    [self performSelectorOnMainThread:@selector(updateLabelText) withObject:nil waitUntilDone:NO];
    if (self && isWork) {
        
        [self performSelector:@selector(poll) withObject:nil afterDelay:60];
    }
}

- (void)poll {

    if (self && isWork) {
        
        [self handle];
        
        if (TLStyleDrivingNavigationView == self.style) {
            
            [self performSelectorOnMainThread:@selector(requestForTheCost) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)updateLabelText {
    
    if (TLStyleCarDetailsView == self.style) {
        
        NSString *str = [NSString compareCurrentTime:timeInterval isCountdown:YES];
        self.text = str.length ? [NSString stringWithFormat:@"该车预计%@后到达", str] : @"";
    }else if (TLStyleDrivingNavigationView == self.style) {
        
        NSString *str = [NSString compareCurrentTime:timeInterval isCountdown:NO];

        str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Rented", nil), str];
        
        if (_fee && _mile) {
            
            self.text = [NSString stringWithFormat:@"%@,%@ %@ Km,￥%@", str, NSLocalizedString(@"Drived", nil), _mile, _fee];
        }else {
            
            self.text = [NSString stringWithFormat:@"%@", str];
        }
        
    }else if (TLStyleMoney == self.style) {
        
        float money = [Budget costWithTimeInterval:timeInterval];
        self.text = [NSString stringWithFormat:@"预计%.2f元", money];
    }else {
        
        NSString *str = [NSString compareCurrentTime:timeInterval isCountdown:NO];
        self.text = str.length ? str : @"";
    }
}

#pragma mark - Request
-(void)requestForTheCostcompleteHandle:(void (^)(NSString *, NSString *))block
{
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetOrderDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess) {
                
                NSString *stringfee = [NSString stringWithFormat:@"%@", response[@"fee"]];
                NSString *endMileage = [NSString stringWithFormat:@"%@", response[@"endMileage"]];
                NSString *startMileage = [NSString stringWithFormat:@"%@", response[@"startMileage"]];
                double fee = [stringfee doubleValue];
                double mile = [endMileage doubleValue] - [startMileage doubleValue];
                _fee = [NSString stringWithFormat:@"%.2f", fee];
                _mile = [NSString stringWithFormat:@"%.1f", mile];
                
                [self updateLabelText];
                
                if (block) {
                    block(_fee, _mile);
                }

            }
        }
    }];
}


- (void)requestForTheCost {
    
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetOrderDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess) {

                NSString *stringfee = [NSString stringWithFormat:@"%@", response[@"fee"]];
                NSString *endMileage = [NSString stringWithFormat:@"%@", response[@"endMileage"]];
                NSString *startMileage = [NSString stringWithFormat:@"%@", response[@"startMileage"]];
                double fee = [stringfee doubleValue];
                double mile = [endMileage doubleValue] - [startMileage doubleValue];
                _fee = [NSString stringWithFormat:@"%.2f", fee];
                _mile = [NSString stringWithFormat:@"%.1f", mile];
                
                [self updateLabelText];
            }
        }
    }];
}

@end
