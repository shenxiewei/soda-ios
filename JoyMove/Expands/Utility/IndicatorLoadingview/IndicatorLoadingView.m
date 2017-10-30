//
//  IndicatorLoadingView.m
//  JoyMove
//
//  Created by Soda on 2017/10/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "IndicatorLoadingView.h"

@interface IndicatorLoadingView()

@property(strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

static IndicatorLoadingView *_instance = nil;

@implementation IndicatorLoadingView

+ (instancetype)sharedIndicatorLoadingView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IndicatorLoadingView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    });
    
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)sdc_setupViews
{
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void)sdc_bindViewModel
{
    
}

#pragma mark - public
- (void)show:(UIView *)superView
{
    self.center = CGPointMake(superView.frame.size.width*0.5, superView.frame.size.height*0.5);
    [superView addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - lazyLoad
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    }
    return _activityIndicatorView;
}
@end
