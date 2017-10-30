//
//  TopBannerView.h
//  JoyMove
//
//  Created by Soda on 2017/9/14.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCView.h"

typedef enum {
    TopBannerViewStatusIsDistributing = 1,
    TopBannerViewStatusMonth = 2,
} TopBannerViewStatus;

@interface TopBannerView : SDCView

@property(nonatomic, assign) TopBannerViewStatus status;

- (void)updateInfo:(NSDictionary *)params;

@end
