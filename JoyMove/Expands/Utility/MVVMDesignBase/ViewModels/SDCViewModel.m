//
//  SDCViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/4/25.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import "SDCViewModel.h"

@implementation SDCViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    SDCViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel sdc_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)sdc_initialize {}

@end
