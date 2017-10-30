//
//  UILabel+Extension.h
//  JoyMove
//
//  Created by Soda on 2017/10/17.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace ;

- (void)changeFont:(UIFont *)font noteString:(NSString *)noteString;

- (void)changeColor:(UIColor *)color font:(UIFont *)font noteString:(NSString *)noteString;

- (void)changeColor:(UIColor *)color font:(UIFont *)font lineSpace:(float)lineSpace noteString:(NSString *)noteString;
@end
