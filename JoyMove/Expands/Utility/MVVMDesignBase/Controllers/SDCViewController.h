//
//  SDCViewController.h
//  JoyMove
//
//  Created by Soda on 2017/4/24.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCViewControllerProtocol.h"

@interface SDCViewController : UIViewController<SDCViewControllerProtocol>

/**
 *  添加控件
 */
- (void)sdc_addSubviews;

/**
 *  绑定
 */
- (void)sdc_bindViewModel;

@end
