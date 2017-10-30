//
//  InputCouponNoView.h
//  JoyMove
//
//  Created by 刘欣 on 15/5/4.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputCouponNoDelegate <NSObject>

- (void)addCoupon:(NSString *)code;

- (void)updateCoupons;

@end

@interface InputCouponNoView : UIView<UITextFieldDelegate>

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,assign)BOOL isUpdateCoupons;

@property(nonatomic,strong)UILabel *promptLabel;

@property(nonatomic,assign)id <InputCouponNoDelegate> couponDelegate;

- (void)show;

- (void)hide;

@end
