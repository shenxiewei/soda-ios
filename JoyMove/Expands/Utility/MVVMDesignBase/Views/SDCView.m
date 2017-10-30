//
//  SDCView.m
//  JoyMove
//
//  Created by Soda on 2017/4/25.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import "SDCView.h"

@implementation SDCView

+ (CGSize)size {
    
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self sdc_setupViews];
        [self sdc_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<SDCViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
        
        [self sdc_setupViews];
        [self sdc_bindViewModel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sdc_setupViews];
        [self sdc_bindViewModel];
    }
    return self;
}

- (void)sdc_bindViewModel {
}

- (void)sdc_setupViews {
}
@end
