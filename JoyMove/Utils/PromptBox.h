//
//  PromptBox.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/9.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface PromptBox : NSObject <MBProgressHUDDelegate>

/* 设置提示框的文本颜色和字体
 * color：文本颜色，默认为白色
 * font：文本字体，默认为[UIFont fontWithName: @"Avenir-Book" size: 15] */

- (void)setTextColor:(UIColor *)color font:(UIFont *)font;

/* 弹出一个无需确认文本提示框
 * text：文本内容
 * view：提示框的父视图 */

- (void)showTextWithText:(NSString *)text inView:(UIView *)view;

/* 弹出一个附加旋转控件等待提示框
 * text：文本内容，可为空
 * view：提示框的父视图 */

- (void)showIndeterminateWithText:(NSString *)text inView:(UIView *)view;

/* 弹出一个附加进度条等待提示框
 * text：文本内容，可为空
 * view：提示框的父视图 */

- (void)showProgressWithText:(NSString *)text inView:(UIView *)view;

/* 弹出一个自定义image提示框
 * text：文本内容，可为空
 * view：提示框的父视图 */

- (void)showImgWithImg:(NSString *)imgName setTextWithText:(NSString *)text inView:(UIView *)view;

/* 设置进度条
 * progress：进度条百分比 */

- (void)setProgress: (float)progress;

/* 设置提示字样
 * text：文本 */

- (void)setText: (NSString *)text;


/* 隐藏提示框 */

- (void)hide;
- (void)hide:(BOOL)animated;

@end
