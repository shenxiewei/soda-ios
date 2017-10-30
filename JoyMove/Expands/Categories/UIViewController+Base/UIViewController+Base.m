//
//  UIViewController+Base.m
//  gingu-framework
//
//  Created by Soda on 2017/8/1.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "UIViewController+Base.h"
#import <objc/runtime.h>

static const void *tagDismissCompleteBlockKey = &tagDismissCompleteBlockKey;

@implementation UIViewController (Base)

- (DismissCompleteBlock )dismissCompleteBlock {
    return objc_getAssociatedObject(self, tagDismissCompleteBlockKey);
}

- (void)setDismissCompleteBlock:(DismissCompleteBlock)dismissCompleteBlock {
    objc_setAssociatedObject(self, tagDismissCompleteBlockKey, dismissCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma - Public

- (void)customLeftNav:(NSString *)imgName touchUpInsideBlock:(void (^)())block
{
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    UIButton *leftNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    leftNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
    [leftNavigationItemButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [[leftNavigationItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (block) {
            block();
        }
    }];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: leftNavigationItemButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
}

- (void)customRightNav:(NSString *)imgName touchUpInsideBlock:(void (^)())block
{
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -15;
    
    UIButton *rightNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    rightNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
    [rightNavigationItemButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [[rightNavigationItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (block) {
            block();
        }
    }];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: rightNavigationItemButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
}

- (void)customRightNavWithParams:(NSDictionary *)params touchUpInsideBlock:(void (^)())block
{
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -15;
    
    UIButton *rightNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    CGRect buttonFrame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    if (params[@"frame"]) {
        buttonFrame = CGRectFromString(params[@"frame"]);
    }
    
    rightNavigationItemButton.frame = buttonFrame;
    [rightNavigationItemButton setTitle:params[@"title"] forState:UIControlStateNormal];
    [rightNavigationItemButton setTitleColor:params[@"color"] forState:UIControlStateNormal];
    rightNavigationItemButton.titleLabel.font = params[@"font"];
    [[rightNavigationItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (block) {
            block();
        }
    }];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: rightNavigationItemButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
}
@end
