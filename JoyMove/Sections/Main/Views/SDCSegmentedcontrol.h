//
//  SDCSegmentedcontrol.h
//  JoyMove
//
//  Created by Soda on 2017/10/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCView.h"

#define kSelectedIndex @"kSelectedIndex"

@protocol SDCSegmentedControlDelegate <NSObject>

- (void)SDCSegmentControlClickedIndex:(NSInteger)index;

@end

@interface SDCSegmentedcontrol : SDCView

@property(nonatomic,assign) id<SDCSegmentedControlDelegate> delegate;

@property(nonatomic,strong) UIColor *normalColor;
@property(nonatomic,strong) UIColor *selectedColor;

@property(nonatomic,strong) UIColor *titleNoramlColor;
@property(nonatomic,strong) UIColor *titleSelectedColor;

@property(nonatomic,assign) NSInteger selectedIndex;

- (instancetype)initWithIems:(NSArray *)items;
@end
