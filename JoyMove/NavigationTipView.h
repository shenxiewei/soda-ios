//
//  NavigationTipView.h
//  JoyMove
//
//  Created by ethen on 15/4/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol NavigationTipDelegate <NSObject>

- (void)navigationTipDidClicked;

@end

@interface NavigationTipView : UIView

@property (assign, nonatomic) id<NavigationTipDelegate> delegate;
@property (assign, nonatomic) UIViewController *viewController;

- (void)setStop:(NSArray *)array;
- (void)setUserLocation: (CLLocationCoordinate2D)coor;

- (void)initUI;
- (void)start;
- (void)stop;
- (void)identify;
- (void)show;
- (void)hide;

@end
