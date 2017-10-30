//
//  SDCViewControllerProtocol.h
//  JoyMove
//
//  Created by Soda on 2017/4/24.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDCViewModelProtocol;

@protocol SDCViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id <SDCViewModelProtocol>)viewModel;

@end
