//
//  AKeyRentCarButtonView.m
//  JoyMove
//
//  Created by cty on 15/10/28.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AKeyRentCarButtonView.h"
#import "Macro.h"

@interface AKeyRentCarButtonView ()
{
    UIButton *_AKeyRentCarButton;
}

@end
@implementation AKeyRentCarButtonView

-(void)initUI
{
    _AKeyRentCarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _AKeyRentCarButton.frame=CGRectMake(0, 0,132.0, 47.0);
    _AKeyRentCarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_AKeyRentCarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    _AKeyRentCarButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [_AKeyRentCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_AKeyRentCarButton setTitle:NSLocalizedString(@"Rent", nil) forState:UIControlStateNormal];
    [_AKeyRentCarButton setBackgroundImage:[UIImage imageNamed:@"AKeyRentCarButton"] forState:UIControlStateNormal];
    [_AKeyRentCarButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_AKeyRentCarButton];
    
}

-(void)changeAKeyRentCarButtonHidden:(BOOL)isButtonHidden
{
    if (isButtonHidden==YES)
    {
        [UIView animateWithDuration:.4f animations:^{
             _AKeyRentCarButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden=YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:.4f animations:^{
            _AKeyRentCarButton.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden=NO;
        }];
    }
}

//延迟button的隐藏时间
-(void)delayHideButton
{
     self.hidden=YES;
}

-(void)buttonClick:(UIButton *)button
{
    if(self.AKeyRentCarButtonClick)
    {
        self.AKeyRentCarButtonClick();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
