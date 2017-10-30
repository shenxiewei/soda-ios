//
//  IndicatorLoadingView.h
//  JoyMove
//
//  Created by Soda on 2017/10/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCView.h"

@interface IndicatorLoadingView : SDCView

+ (instancetype)sharedIndicatorLoadingView;
- (void)show:(UIView *)superView;
- (void)dismiss;

@end
