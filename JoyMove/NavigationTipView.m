//
//  NavigationTipView.m
//  JoyMove
//
//  Created by ethen on 15/4/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "NavigationTipView.h"
#import "UtilsMacro.h"
#import "SearchModel.h"
#import "AudioUtils.h"
#import "WebViewController.h"
#import "POIDefine.h"
#import "LocalNotification.h"

@interface NavigationTipView () {
    
    WebViewController *_webViewController;
    UILabel *_label;
    CLLocationCoordinate2D _userLocationCoor;
    NSTimer *_timer;
    NSArray *_stop;
    NSString *_url;
}
@end

@implementation NavigationTipView

const float timeInterval = 10.f;                 /**< 心跳的间隔 */
const float showTime = 5.f;                      /**< show的时间 */

- (void)setStop:(NSArray *)array {
    
    if (![_stop isEqualToArray:array]) {    //避免重复赋值
        
        _stop = array;
    }
}

- (void)setUserLocation: (CLLocationCoordinate2D)coor {
    
    _userLocationCoor = coor;
}

- (void)start {
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(identify) userInfo:nil repeats:YES];
}

- (void)stop {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)identify {
    
    //无stop数据时,结束timer
    if (!_stop.count) {
        
        [self stop];

        return;
    }
    
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_userLocationCoor.latitude longitude:_userLocationCoor.longitude];
    
    for (SearchModel *model in _stop) {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:model.latitude longitude:model.longitude];
        CLLocationDistance kilometers = [userLocation distanceFromLocation:location];
        
        if (kilometers<nearTheStopDistance) {
            
            //移除显示过的model(一个stop只显示一次)
            NSMutableArray *mutableArray = [_stop mutableCopy];
            [mutableArray removeObject:model];
            _stop = mutableArray;
            
            //show & hide
            [self updateText:model.name];
            _url = model.url;
            [self show];
            [self performSelector:@selector(hide) withObject:nil afterDelay:showTime];
            
            return;
        }
    }
}

- (void)initUI {
    
    //self.backgroundColor = UIColorFromRGB(38, 52, 72);
    self.backgroundColor = kThemeColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    //暂不加小箭头
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-25.5f, 0, 25.5f, 44)];
    arrow.image = [UIImage imageNamed:@"NavTipArrow"];
    [self addSubview:arrow];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-50, 44)];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = UIBoldFontFromSize(20);
//    _label.minimumScaleFactor=5;
    _label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_label];
}

#pragma mark -

- (void)updateText:(NSString *)text {
    
    [AudioUtils phoneVibrate];
    NSString *str = [NSString stringWithFormat:@"已行驶到“%@”附近", text];
    _label.text = str;
}

- (void)show {
    
    NSLog(@"show");
    self.alpha = 0;
    [[UIApplication sharedApplication].windows[[UIApplication sharedApplication].windows.count-1] addSubview:self];
    
    [UIView animateWithDuration:.4f animations:^{
        
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        ;
    }];
    
    //发送本地推送
    [LocalNotification postLocalNotification:_label.text badge:0 delay:0];
}

- (void)hide {
    
    NSLog(@"hide");
    [UIView animateWithDuration:.4f animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if (!_url||!_url.length||!_viewController) {
        
        return;
    }
    
    //webViewController未显示时，push
    if (![_webViewController isShow]) {
        
        _webViewController = [[WebViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_webViewController];
        _webViewController.view.frame = [UIScreen mainScreen].bounds;
        [_webViewController setHideAgreeButton:YES];
        [_webViewController loadUrl:_url];

        [_viewController presentViewController:navi animated:YES completion:nil];
        
        [self hide];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(navigationTipDidClicked)]) {
            
            [self.delegate navigationTipDidClicked];
        }
    }
}

@end
