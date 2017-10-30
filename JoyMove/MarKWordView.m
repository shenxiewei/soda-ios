//
//  MarKWordView.m
//  JoyMove
//
//  Created by 赵霆 on 16/3/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "MarKWordView.h"
#import "Macro.h"

@implementation MarKWordView

- (void)creatMarkViewWithFrame:(CGRect)frame andStringArray:(NSArray *)array
{
    // 初始化数组
    _markArray = [NSMutableArray array];

    self.frame = frame;
    
    CGFloat btnW = 0;
    CGFloat btnH = 23;
    CGFloat addW = 20;
    CGFloat marginX = 14;
    CGFloat marginY = 11;
    CGFloat lastX = 0;
    CGFloat lastY = 15;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromSixteenRGB(0xf87a63) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn.titleLabel sizeToFit];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColorFromSixteenRGB(0xf87a63).CGColor;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btnW = btn.titleLabel.frame.size.width + addW;
        
        if (frame.size.width - lastX > btnW) {
            btn.frame = CGRectMake(lastX, lastY, btnW, btnH);
        }else{
            btn.frame = CGRectMake(0, lastY + marginY + btnH, btnW, btnH);
        }

        lastX = CGRectGetMaxX(btn.frame) + marginX;
        lastY = btn.frame.origin.y;
        _heightForSelf = CGRectGetMaxY(btn.frame) + 15;

        [self addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)btn
{
    
    if (!btn.selected) {
        
        btn.selected = YES;
        btn.backgroundColor = UIColorFromSixteenRGB(0xf87a63);
        [_markArray addObject:btn.titleLabel.text];
    }else{
        
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
        [_markArray removeObject:btn.titleLabel.text];
    }
    
}

@end
