//
//  PayView.m
//  JoyMove
//
//  Created by ethen on 15/5/12.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "PayView.h"
#import "UtilsMacro.h"

@interface PayView () {
    
    UILabel *_actualPaymentLabel;
    UILabel *_couponPriceLabel;
    UIButton *_payButton;
    UILabel *_lineLabel;
}
@end

@implementation PayView

const float kPayViewHeight = 50.f;

- (void)initUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, .5f)];
    line.backgroundColor = [UIColor blackColor];
    [self addSubview:line];
    line.alpha = .21;
    
    _actualPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (kScreenWidth-15-120) * 0.5, kPayViewHeight)];
    _actualPaymentLabel.textColor = UIColorFromRGB(82, 82, 82);
    _actualPaymentLabel.font = UIFontFromSize(15);
    _actualPaymentLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_actualPaymentLabel];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_actualPaymentLabel.frame) + 5, 10, 0.5, 30)];
    _lineLabel.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [self addSubview:_lineLabel];
    
    _couponPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lineLabel.frame) + 10 , 0, kScreenWidth - CGRectGetMaxX(_actualPaymentLabel.frame) - 120 - 10, kPayViewHeight)];
    _couponPriceLabel.textColor = UIColorFromRGB(184, 184, 184);
    _couponPriceLabel.adjustsFontSizeToFitWidth = YES;
    _couponPriceLabel.font = UIFontFromSize(12);
    [self addSubview:_couponPriceLabel];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(kScreenWidth-120, 0, 120, kPayViewHeight);
    _payButton.backgroundColor = UIColorFromRGB(19, 152, 235);
    [_payButton setTitle:NSLocalizedString(@"Payment", nil) forState:UIControlStateNormal];
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payButton.titleLabel.font = UIBoldFontFromSize(20);
    [_payButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payButton];
}

- (void)update {
    
    NSString *text = [NSString stringWithFormat:@"%@￥%.2f",NSLocalizedString(@"Actual payment：", nil), (_orderPrice-_couponPrice)>0.f?(_orderPrice-_couponPrice):0.f];
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
//    [attributedStr addAttribute:NSFontAttributeName value:UIBoldFontFromSize(18) range:NSMakeRange(4, text.length-4)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(255, 111, 104) range:NSMakeRange(4, text.length-4)];
    _actualPaymentLabel.textColor = UIColorFromRGB(82, 82, 82);
    _actualPaymentLabel.font = UIFontFromSize(15);
    _actualPaymentLabel.textColor = UIColorFromRGB(255, 111, 104);
    _actualPaymentLabel.text = text;
    
    _couponPriceLabel.text = [NSString stringWithFormat:@"%@￥%.0f",NSLocalizedString(@"Coupon", nil), _couponPrice];
}

+ (float)height {
    
    return kPayViewHeight;;
}

- (void)buttonClicked:(UIButton *)button {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(payViewDidClicked)]) {
        
        [self.delegate payViewDidClicked];
    }
}

@end
