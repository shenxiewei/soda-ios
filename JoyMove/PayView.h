//
//  PayView.h
//  JoyMove
//
//  Created by ethen on 15/5/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewDelegate <NSObject>

- (void)payViewDidClicked;

@end

@interface PayView : UIView

@property (assign, nonatomic) id<PayViewDelegate> delegate;
@property (assign, nonatomic) float orderPrice;
@property (assign, nonatomic) float couponPrice;

- (void)initUI;
- (void)update;
+ (float)height;

@end
