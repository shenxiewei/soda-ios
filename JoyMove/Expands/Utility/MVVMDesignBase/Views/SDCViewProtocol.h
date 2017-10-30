//
//  SDCViewProtocol.h
//  JoyMove
//
//  Created by Soda on 2017/4/25.
//  Copyright © 2017年 xin.liu. All rights reserved.
//
@protocol SDCViewModelProtocol;

@protocol SDCViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <SDCViewModelProtocol>)viewModel;

- (void)sdc_bindViewModel;
- (void)sdc_setupViews;

@end
