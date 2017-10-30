//
//  InputCouponNoView.m
//  JoyMove
//
//  Created by 刘欣 on 15/5/4.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "InputCouponNoView.h"
#import "Macro.h"
#import "LXRequest.h"

typedef NS_ENUM(NSInteger, CouponNoTag) {

    CouponNoTextFieldTag = 201,
    CouponNoConfirmButtonTag,
    CouponNoCancelButtonTag,
};

@implementation InputCouponNoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {

    self = [super init];
    if (self) {
        
        self.alpha = 0;
        self.userInteractionEnabled = NO;
        [self initUI];
    }
    return self;
}

#pragma mark - UI

- (void)initUI {

    self.frame = [[UIScreen mainScreen] bounds];
    
    //黑色蒙板
    UIView *blackView = [[UIView alloc] init];
    blackView.frame = [[UIScreen mainScreen] bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5f;
    [self addSubview:blackView];
    
    CGFloat width = 300;
    CGFloat height = 180;
    UIView *couponNoView = [[UIView alloc] init];
    couponNoView.frame = CGRectMake((kScreenWidth-width)/2, (kScreenHeight-height)/2, width, height);
    couponNoView.layer.cornerRadius = 4;
    couponNoView.layer.masksToBounds = YES;
    couponNoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:couponNoView];
    
    //请输入web优惠券验证码label
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.frame = CGRectMake((width-160)/2, 10, 160, 60);
    self.promptLabel.numberOfLines = 2;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.text = @"请输入web优惠券验证码";
    self.promptLabel.font = UIFontFromSize(20);
    [couponNoView addSubview:self.promptLabel];
    
    //输入框
    for (int i=0; i<2; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 90+40*i, width, 1);
        view.backgroundColor = KBackgroudColor;
        [couponNoView addSubview:view];
    }
    
    //textField
    UITextField *couponNo = [[UITextField alloc] init];
    couponNo.frame = CGRectMake(0, 90, width, 40);
    couponNo.textAlignment = NSTextAlignmentCenter;
    couponNo.font = UIFontFromSize(18);
    couponNo.tag = CouponNoTextFieldTag;
    couponNo.placeholder = @"在此输入验证码";
    couponNo.delegate = self;
    [couponNoView addSubview:couponNo];
    
    //确定按钮和取消按钮间的竖线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(149.5f, 130, 1, height-130);
    lineView.backgroundColor = KBackgroudColor;
    [couponNoView addSubview:lineView];
    
    //确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(width/2, 140, width/2, 40);
    [confirmButton setTitle:@"兑换" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = UIBoldFontFromSize(20);
    confirmButton.tag = CouponNoConfirmButtonTag;
    [confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [couponNoView addSubview:confirmButton];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 140, width/2, 40);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(100, 100, 100) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = UIFontFromSize(20);
    cancelButton.tag = CouponNoCancelButtonTag;
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [couponNoView addSubview:cancelButton];
}

#pragma mark - Action

- (void)buttonClick:(UIButton *)sender {

    if (sender.tag == CouponNoCancelButtonTag) {
        
        [self hide];
    }else if (sender.tag == CouponNoConfirmButtonTag){
    
        UITextField *textField = (UITextField *)[self viewWithTag:CouponNoTextFieldTag];
        [self.couponDelegate addCoupon:textField.text];
    }else {
    
        ;
    }
}

- (void)show {

    UITextField *textField = (UITextField *)[self viewWithTag:CouponNoTextFieldTag];
    [textField becomeFirstResponder];
    [UIView animateWithDuration:.25f animations:^{
        
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
    }];
}

- (void)hide {

    self.userInteractionEnabled = NO;
    UITextField *textField = (UITextField *)[self viewWithTag:CouponNoTextFieldTag];
    [textField resignFirstResponder];
    [UIView animateWithDuration:.25f animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.isUpdateCoupons) {
            
            [self.couponDelegate updateCoupons];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITextField *textField = (UITextField *)[self viewWithTag:CouponNoTextFieldTag];
    [textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"resizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, -80, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"resizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
}


@end
