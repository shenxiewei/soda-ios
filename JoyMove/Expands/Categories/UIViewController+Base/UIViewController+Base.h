//
//  UIViewController+Base.h
//  gingu-framework
//
//  Created by Soda on 2017/8/1.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissCompleteBlock)();

@interface UIViewController (Base)

@property (nonatomic, copy) DismissCompleteBlock dismissCompleteBlock;

/**
 custom left nav button

 @param imgName imgName
 @param block block TouchUpInside Action
 */
- (void)customLeftNav:(NSString *)imgName touchUpInsideBlock:(void (^)())block;

/**
 custom right nav button
 
 @param imgName imgName
 @param block block TouchUpInside Action
 */
- (void)customRightNav:(NSString *)imgName touchUpInsideBlock:(void (^)())block;

- (void)customRightNavWithParams:(NSDictionary *)params touchUpInsideBlock:(void (^)())block;

@end
