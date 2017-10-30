//
//  MarKWordView.h
//  JoyMove
//
//  Created by 赵霆 on 16/3/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarKWordView : UIView

@property (nonatomic, assign) CGFloat heightForSelf;
@property (nonatomic, strong) NSMutableArray *markArray;
- (void)creatMarkViewWithFrame:(CGRect)frame andStringArray:(NSArray *)array;

@end
