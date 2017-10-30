//
//  TimeLable.h
//  ResignView
//
//  Created by ethen on 15/2/4.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TimeLabelStyle) {
    
    TLStyleNone = 100,
    TLStyleCarDetailsView,
    TLStyleDrivingNavigationView,
    TLStyleMoney,
};

@interface TimeLabel : UILabel

@property (nonatomic, assign) TimeLabelStyle style;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *mile;


- (void)setTime:(NSTimeInterval)time;
- (void)stop;
- (void)requestForTheCostcompleteHandle:(void(^)(NSString *fee, NSString *mile))block;

@end
