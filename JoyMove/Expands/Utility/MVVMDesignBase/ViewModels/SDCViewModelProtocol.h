//
//  SDCViewModelProtocol.h
//  JoyMove
//
//  Created by Soda on 2017/4/24.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SDCHeaderRefresh_HasMoreData = 1,
    SDCHeaderRefresh_HasNoMoreData,
    SDCFooterRefresh_HasMoreData,
    SDCFooterRefresh_HasNoMoreData,
    SDCRefreshError,
    SDCRefreshUI,
} LSRefreshDataStatus;

@protocol  SDCViewModelProtocol<NSObject>

@optional

- (instancetype)initWithModel:(id)model;

/**
 *  初始化
 */
- (void)sdc_initialize;
@end

