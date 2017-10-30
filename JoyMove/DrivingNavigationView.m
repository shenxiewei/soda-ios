//
//  DrivingNavigationView.m
//  JoyMove
//
//  Created by ethen on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "DrivingNavigationView.h"
#import "Macro.h"
#import "TimeLabel.h"

@interface DrivingNavigationView () {
    
    UIView *_white;
    UIImageView *_logoImageView;
    TimeLabel *_titleLabel;
    NSTimer *_timer;
    BOOL isHyperplasia;
}

@end

@implementation DrivingNavigationView

const float drivingNavigationViewHeight = 50.f;
const float drivingNavigationViewAlpha = 1.f;

- (void)initUI {
    
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    
    _white = [[UIView alloc] initWithFrame:self.bounds];
    _white.backgroundColor = UIColorFromRGB(56, 160, 235);
    [self addSubview:_white];
    _white.alpha = .9f;
    
    UIImage *logoImage = [UIImage imageNamed:@"drivingNavi_car"];
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, logoImage.size.width, logoImage.size.height)];
    _logoImageView.image = logoImage;
    [self addSubview:_logoImageView];
    _titleLabel = [[TimeLabel alloc] init];
    _titleLabel.style = TLStyleDrivingNavigationView;
    _titleLabel.font = UIFontFromSize(17);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.frame = CGRectMake(logoImage.size.width + 10, 0, kScreenWidth-logoImage.size.width*2, drivingNavigationViewHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, drivingNavigationViewHeight-.5f, kScreenWidth, .5f)];
    line.backgroundColor = UIColorFromRGB(220, 220, 220);
    [self addSubview:line];
}

+ (CGSize)size {
    
    return CGSizeMake(kScreenWidth, drivingNavigationViewHeight);
}

- (BOOL)isShow {
    
    return (drivingNavigationViewAlpha == self.alpha) ? YES : NO;
}

- (void)show {
    
    [self updateTimeLabel];
    
    if (![self isShow]) {
        [UIView animateWithDuration:.25f animations:^{
            
            self.alpha = drivingNavigationViewAlpha;
        } completion:^(BOOL finished) {
            
            [_timer invalidate];
            _timer = nil;
            _timer = [NSTimer scheduledTimerWithTimeInterval:.015f target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        }];
    }
}

- (void)hide {
    
    [_titleLabel stop];
    [_timer invalidate];
    _timer = nil;
    
    if ([self isShow]) {
        [UIView animateWithDuration:.25f animations:^{
            
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

- (void)updateTimeLabel {
    
    [_titleLabel setTime:[OrderData orderData].startTime/1000];
}

- (void)handleTimer {
    
    if (_logoImageView.alpha>=1.2f) {
        
        isHyperplasia = NO;
    }else if (_logoImageView.alpha<=.25f) {
        
        isHyperplasia = YES;
    }else {
        
        ;
    }
    
    if (isHyperplasia) {
        
        _logoImageView.alpha += .012f;
    }else {
        
        _logoImageView.alpha -= .012f;
    }
}

@end
