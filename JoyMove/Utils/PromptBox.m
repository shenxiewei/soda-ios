//
//  PromptBox.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/9.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "PromptBox.h"

@implementation PromptBox {
    
    MBProgressHUD *hud;
    UIColor *myColor;
    UIFont *myFont;
}

- (void)setTextColor:(UIColor *)color font:(UIFont *)font {
    
    myColor = color;
    myFont = font;
}

//只有文本的提示框
- (void)showTextWithText:(NSString *)text inView:(UIView *)view {
    
    [self hide];
    
    if (!myFont) {
        
        myFont = [UIFont fontWithName:@"Avenir-Book" size:15];
    }
    if (!myColor) {
        
        myColor = [UIColor whiteColor];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelColor = myColor;
    hud.labelFont = myFont;
    
    [hud show:YES];
}

//带有小菊花的提示框
- (void)showIndeterminateWithText:(NSString *)text inView:(UIView *)view {
    
    [self hide];
    
    if (!myFont) {
        
        myFont = [UIFont fontWithName:@"Avenir-Book" size:15];
    }
    if (!myColor) {
        
        myColor = [UIColor whiteColor];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.labelColor = myColor;
    hud.labelFont = myFont;
    
    [hud show:YES];
}

//进度条提示框
- (void)showProgressWithText:(NSString *)text inView:(UIView *)view {
    
    [self hide];
    
    if (!myFont) {
        
        myFont = [UIFont fontWithName:@"Avenir-Book" size:15];
    }
    if (!myColor) {
        
        myColor = [UIColor whiteColor];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = text;
    hud.labelColor = myColor;
    hud.labelFont = myFont;
    
    [hud show:YES];
}

//自定义图片
- (void)showImgWithImg:(NSString *)imgName setTextWithText:(NSString *)text inView:(UIView *)view {

    [self hide];
    
    if (!myFont) {
        
        myFont = [UIFont fontWithName:@"Avenir-Book" size:15];
    }
    if (!myColor) {
        
        myColor = [UIColor whiteColor];
    }
    
    hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = self;
    hud.labelText = text;
    
    [hud show:YES];
}

- (void)setProgress: (float)progress {
    
    hud.progress = progress;
}

- (void)setText: (NSString *)text {
    
    hud.labelText = text;
}

- (void)hide {
    
    [hud hide:YES];
    hud = nil;
}

- (void)hide:(BOOL)animated {
    
    [hud hide:animated];
    hud = nil;
}

@end
