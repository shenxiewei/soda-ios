//
//  UserGuideView.m
//  JoyMove
//
//  Created by ethen on 15/7/15.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "UserGuideView.h"
#import "Macro.h"

@interface UserGuideView () {
    
    UIImageView *_imageView;
    UIView *_backgroundView;
}
@end

@implementation UserGuideView

static float userGuideViewWidth     = 300.f;
static float userGuideViewHeight    = 306.45f;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUIWithType:(UserGuideType)type {
    
    NSString *tipImageName;
    NSString *buttonImageName;
    if (UGTypeNotRent==type) {
        
        tipImageName        = @"userGuideTipNotRent";
        buttonImageName     = @"userGuideButtonNotRent";
    }else if (UGTypeAllCertification==type) {
        
        tipImageName        = @"userGuideTipAllCertification";
        buttonImageName     = @"userGuideButtonAllCertification";
    }else {
        
        ;
    }
    
    //背景色
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = .0f;
    [self addSubview:_backgroundView];
    
    //图示
    UIImage *tipImage = UIImageName(tipImageName);
    _imageView = [[UIImageView alloc] initWithImage:tipImage];
    _imageView.frame = CGRectMake((kScreenWidth-userGuideViewWidth)/2, -userGuideViewHeight, userGuideViewWidth, userGuideViewHeight);
    [self addSubview:_imageView];
    self.userInteractionEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    
    //确认按钮
    UIImage *buttonImage = UIImageName(buttonImageName);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((userGuideViewWidth-buttonImage.size.width)/2, userGuideViewHeight-20-buttonImage.size.height, buttonImage.size.width, buttonImage.size.height);
    [button setImage:UIImageName(buttonImageName) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:button];
}

- (void)show {
    
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:.6f initialSpringVelocity:.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _backgroundView.alpha = .8f;
        _imageView.center = CGPointMake(self.center.x, self.center.y);
    } completion:^(BOOL finished) {
        
        ;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:.3f animations:^{
        
        _backgroundView.alpha = .0f;
        _imageView.center = CGPointMake(self.center.x, kScreenHeight+self.center.y);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)buttonClicked:(UIButton *)button {
    
    [self hide];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(userGuideButtonClicked)]) {
        
        [self.delegate userGuideButtonClicked];
    }
}

@end
