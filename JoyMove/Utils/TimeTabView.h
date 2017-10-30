//
//  TimeTabView.h
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeTabViewDelegate <NSObject>

- (void)selectedIndexDidChange:(NSInteger)index;

@end

@interface TimeTabView : UIView

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) NSInteger selectedIndex;

- (void)initUI;
+ (CGSize)size;
- (BOOL)isShow;
- (void)show;
- (void)hide;

@end
