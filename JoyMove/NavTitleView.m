//
//  NavTitleView.m
//  JoyMove
//
//  Created by Soda on 2017/10/23.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "NavTitleView.h"

@implementation NavTitleView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.center = CGPointMake(self.superview.center.x, self.center.y);
}

@end
