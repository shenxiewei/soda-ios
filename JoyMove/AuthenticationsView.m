//
//  AuthenticationsView.m
//  JoyMove
//
//  Created by 刘欣 on 15/4/21.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AuthenticationsView.h"
#import "UtilsMacro.h"
#import "PersonalInfoViewController.h"
#import "DriveViewController.h"

@implementation AuthenticationsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UI

- (void)initUIWithDictionary:(NSDictionary *)dic {

    self.frame = [[UIScreen mainScreen] bounds];
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    
    //黑色蒙板
    UIView *blackView = [[UIView alloc] init];
    blackView.frame = [[UIScreen mainScreen] bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5f;
    [self addSubview:blackView];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake((kScreenWidth-300)/2, 200, 300, 150);
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];

    CGFloat width = whiteView.frame.size.width;
    
    NSArray *tagArray = @[[NSNumber numberWithInteger:PhoneBindTag],[NSNumber numberWithInteger:IdentifyTag],[NSNumber numberWithInteger:DriverTag],[NSNumber numberWithInteger:CashTag]];
    NSArray *titleArray = @[@"手机绑定",@"身份认证",@"驾照认证",@"押金充值"];
    NSArray *buttonImg_y = @[@"AVphone_y",@"AVidentify_y",@"AVdriver_y",@"AVcash_y"];
    NSArray *buttonImg_n = @[@"AVphone_n",@"AVidentify_n",@"AVdriver_n",@"AVcash_n"];
    CGFloat buttonWidth = (width-20)/7;
    for (int i=0; i<4; i++) {
        
        //绿色button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+buttonWidth*2*i, 10, buttonWidth, buttonWidth);
        button.layer.cornerRadius = buttonWidth/2;
        button.layer.masksToBounds = YES;
        button.backgroundColor = UIColorFromRGB(83, 211, 126);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = [[tagArray objectAtIndex:i] integerValue];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
      
        //从字典中取出button的状态
        NSInteger buttonStatus;
        if (PhoneBindTag == button.tag) {
            
            buttonStatus = [dic[@"mobileAuthState"] integerValue];
        }else if (IdentifyTag == button.tag) {
            
            buttonStatus = [dic[@"id5AuthState"] integerValue];
        }else if (DriverTag == button.tag) {
            
            buttonStatus = [dic[@"driverLicAuthState"] integerValue];
        }else {
            
            buttonStatus = [dic[@"depositState"] integerValue];
        }
       
        //根据button的状态不同创建不同的背景图片
        if (buttonStatus) {
            
            [button setBackgroundImage:[UIImage imageNamed:[buttonImg_y objectAtIndex:i]] forState:UIControlStateNormal];
            button.enabled = NO;
        }else {
        
            [button setBackgroundImage:[UIImage imageNamed:[buttonImg_n objectAtIndex:i]] forState:UIControlStateNormal];
        }
        
        //label
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10+buttonWidth*2*i-5, buttonWidth+15, buttonWidth+10, 20);
        label.text = [titleArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [whiteView addSubview:label];
        
        if (i < 3) {
            
            CGRect rect = CGRectMake((10+buttonWidth)+buttonWidth*2*i, buttonWidth, buttonWidth, buttonWidth);
            
            UIImage *img = [UIImage imageNamed:@"greenPoint"];
            
            //间隙宽度
            CGFloat imgWith = img.size.width;
            CGFloat gapWith = (rect.size.width-imgWith*3)/4;
            CGFloat x = rect.origin.x+gapWith;
            CGFloat y = (rect.origin.y-imgWith)/2+10;
            for (int i=0; i<3; i++) {
                
                UIImageView *pointView = [[UIImageView alloc] init];
                pointView.frame = CGRectMake(x+(imgWith+gapWith)*i, y, imgWith, imgWith);
                pointView.image = img;
                [whiteView addSubview:pointView];
            }
        }
    }
    
    //确定button
    UIImage *buttonImg = [UIImage imageNamed:@"AVbuttonBorder"];
    CGFloat noteWith = buttonImg.size.width;
    CGFloat noteHeight = buttonImg.size.height;
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton.frame = CGRectMake((whiteView.frame.size.width-noteWith)/2, whiteView.frame.size.height-10-40, noteWith,noteHeight);
    [noteButton setTitle:@"确定" forState:UIControlStateNormal];
    [noteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteButton.titleLabel.font = UIFontFromSize(18);
    [noteButton setBackgroundImage:buttonImg forState:UIControlStateNormal];
    [noteButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:noteButton];
}

- (void)update:(NSDictionary *)dic {
    
    
}

- (void)show {
    
    [UIView animateWithDuration:.25f animations:^{
        
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25f animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        ;
    }];
}

#pragma mark - Action

- (void)buttonClick:(UIButton *)sender {

    [self.authenticationDelegate pushAuthentication:sender.tag];
    
    if (PhoneBindTag == sender.tag) {
        
        
    }else if (IdentifyTag == sender.tag){
    
    
    }else if (DriverTag == sender.tag) {
    
        
    }else if (CashTag == sender.tag){
    
    
    }else {
    
        ;
    }
}

@end
