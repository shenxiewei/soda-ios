//
//  TimeTabView.m
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "TimeTabView.h"
#import "Macro.h"

@interface TimeTabView () {
    
    UIImageView *_backgroundImageView;
    UIImageView *_elvesView;
    UISlider *_slider;
}

@end

@implementation TimeTabView

const float timeTabViewWidth = 300.f;
const float timeTabViewHeight = 60.f;

- (void)initUI {
    
    self.userInteractionEnabled = YES;
    self.alpha = 1.0f;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, timeTabViewWidth, timeTabViewHeight)];
    _backgroundImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundImageView];
    _backgroundImageView.userInteractionEnabled = YES;
    
    NSArray *textArray = @[@"现在", @"15分钟", @"30分钟"];
    for (NSInteger i=0; i<3; i++) {
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = i;
//        button.frame = CGRectMake(timeTabViewWidth/3*i, 0, timeTabViewWidth/3, timeTabViewHeight);
//        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_backgroundImageView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*timeTabViewWidth/3, 5, timeTabViewWidth/3, 20)];
        label.tag = i+100;
        label.text = textArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = (!i)?kThemeColor:UIColorFromRGB(120, 120, 120);
        label.font = (!i)?UIFontFromSize(12):UIFontFromSize(12);
        [_backgroundImageView addSubview:label];
    }
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(35, 20, timeTabViewWidth-70, 40)];
    //[_slider setThumbImage:UIImageName(@"tabElves") forState:UIControlStateNormal];
    [_slider setTintColor:UIColorFromRGB(183, 183, 183)]; //确保白球两端线段颜色一致
    
    //[_slider setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    _slider.minimumValue = 0;
    _slider.maximumValue = 2;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_slider];
    
//    _elvesView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 22.5f, 22.5f, 22.5f)];
//    _elvesView.image = UIImageName(@"tabElves");
//    [_backgroundImageView addSubview:_elvesView];
    
    self.selectedIndex = 0;
    [self addObserver: self forKeyPath: @"selectedIndex" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: nil];
}

+ (CGSize)size {
    
    return CGSizeMake(timeTabViewWidth, timeTabViewHeight);
}

- (BOOL)isShow {
    
    return self.alpha;
}

- (void)show {
    
    if (![self isShow]) {
        
        [UIView animateWithDuration:.4f animations:^{
            
            self.alpha = 1.0f;
            _backgroundImageView.frame = CGRectMake(0, 0, timeTabViewWidth, timeTabViewHeight);
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

- (void)hide {
    
    if ([self isShow]) {
        
        [UIView animateWithDuration:.4f animations:^{
            
            self.alpha = 0;
            _backgroundImageView.frame = CGRectMake(0, 100, timeTabViewWidth, timeTabViewHeight);
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

#pragma mark - Action

//- (void)buttonClicked:(UIButton *)button {
//    
//    self.selectedIndex = button.tag;
//}

- (void)sliderValueChanged:(UISlider *)slider {
    
    float limit = 2.f/3;
    float value = slider.value;
    if (value>=0 && value<=limit) {
        
        self.selectedIndex = 0;
    }else if (value>limit && value<=limit*2) {
        
        self.selectedIndex = 1;
    }else {
        
        self.selectedIndex = 2;
    }
    slider.value = self.selectedIndex;
    
    for (NSInteger i=0; i<3; i++) {
        
        UILabel *label = (UILabel *)[_backgroundImageView viewWithTag:i+100];
        label.textColor = (i==self.selectedIndex)?kThemeColor:UIColorFromRGB(120, 120, 120);
        label.font = (i==self.selectedIndex)?UIFontFromSize(12):UIFontFromSize(12);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (change[@"new"] == change[@"old"]) {
        
        NSLog(@"same view");
        return;
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedIndexDidChange:)]) {
        
        [self.delegate selectedIndexDidChange:self.selectedIndex];
    }
  
//    float x = 23+[change[@"new"] integerValue]*105;
//    
//    [UIView animateWithDuration:.25f animations:^{
//        
//        _elvesView.frame = CGRectMake(x, _elvesView.frame.origin.y, _elvesView.frame.size.width, _elvesView.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedIndexDidChange:)]) {
//            
//            [self.delegate selectedIndexDidChange:self.selectedIndex];
//        }
//    }];
}

@end
