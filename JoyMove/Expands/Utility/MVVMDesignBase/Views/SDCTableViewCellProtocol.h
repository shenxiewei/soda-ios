//
//  SDCTableViewCellProtocol.h
//  JoyMove
//
//  Created by Soda on 2017/5/5.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SDCTableVIewCellProtocol <NSObject>
@optional

- (void)sdc_setupViews;
- (void)sdc_bindViewModel;

@end
