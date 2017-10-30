//
//  AKeyRentCarButtonView.h
//  JoyMove
//
//  Created by cty on 15/10/28.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKeyRentCarButtonView : UIView

-(void)initUI;
//
-(void)changeAKeyRentCarButtonHidden:(BOOL)isButtonHidden;

//一键租车失败回调页面
@property (nonatomic,copy) void(^AKeyRentCarButtonClick)();

@end
