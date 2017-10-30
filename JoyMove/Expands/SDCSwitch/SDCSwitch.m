//
//  SDCSwitch.m
//  JoyMove
//
//  Created by Soda on 2017/10/27.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCSwitch.h"
#import "SwitchViewModel.h"

@interface SDCSwitch()
{
    UISwipeGestureRecognizer *leftSwipeRecognizer;
    UISwipeGestureRecognizer *rightSwipeRecognizer;
}

@property(nonatomic, strong) UIImageView *bgImgV;
@property(nonatomic, strong) UILabel *lbl;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) SwitchViewModel *viewModel;

@end

@implementation SDCSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgImgV];
        [self addSubview:self.lbl];
        [self addSubview:self.button];
        
        [self sdc_bindViewModel];
        
        [self updateConstraintsIfNeeded];
        
        leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:leftSwipeRecognizer];
        
        rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:rightSwipeRecognizer];
    }
    return self;
}
- (void)dealloc
{
    [self removeGestureRecognizer:leftSwipeRecognizer];
    [self removeGestureRecognizer:rightSwipeRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{

    if (self.isOn) {
        if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
           [self.viewModel.unShareCarCommand execute:nil];
        }
    }
    if (!self.isOn) {
        if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
           [self.viewModel.shareCarCommand execute:nil];
        }
    }
}

- (void)sdc_bindViewModel
{
    @weakify(self)
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.isOn) {
            [self.viewModel.unShareCarCommand execute:nil];
        }else
        {
             [self.viewModel.shareCarCommand execute:nil];
        }
    }];
    
    [self.viewModel.shareCarSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        [self startAnimation];
    }];
    
    [self.viewModel.unShareCarSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        [self startAnimation];
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];

    JMWeakSelf(self);
    [self.bgImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
    
    [self.lbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakself);
        make.left.equalTo(@(weakself.frame.size.height*0.3));
        make.right.equalTo(@(-weakself.frame.size.height*0.3));
    }];
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakself.frame.size.height, weakself.frame.size.height));
        if (weakself.isOn)
        {
            make.left.equalTo(@(weakself.frame.size.width-weakself.frame.size.height));
            
        }else
        {make.left.equalTo(@0);}
        make.centerY.equalTo(weakself);
    }];
}

#pragma mark - animation
- (void)startAnimation
{
    if (self.isOn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.button.frame = CGRectMake(0.0, 0.0, self.button.frame.size.width, self.button.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.isOn = NO;
            
            [self.button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateHighlighted];
            self.bgImgV.image = [UIImage imageNamed:@"by_switch_off_switch background"];
            
            self.lbl.textAlignment = NSTextAlignmentRight;
            self.lbl.textColor = [UIColor whiteColor];
            self.lbl.text = @"滑动开启分享";
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
             self.button.frame = CGRectMake(self.frame.size.width-self.button.frame.size.width, 0.0, self.button.frame.size.width, self.button.frame.size.height);
        } completion:^(BOOL finished) {
            self.isOn = YES;
            
            [self.button setImage:[UIImage imageNamed:@"by_switch_on_handle"] forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"by_switch_on_handle"] forState:UIControlStateHighlighted];
            self.bgImgV.image = [UIImage imageNamed:@"by_switch_on_switch background"];
            
            self.lbl.textAlignment = NSTextAlignmentLeft;
            self.lbl.textColor = UIColorFromSixteenRGB(0x88d03f);
            self.lbl.text = @"已开启分享";
        }];
    }
}


- (void)updateStatus
{
    if (self.isOn) {
        
        [self.button setImage:[UIImage imageNamed:@"by_switch_on_handle"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"by_switch_on_handle"] forState:UIControlStateHighlighted];
        self.bgImgV.image = [UIImage imageNamed:@"by_switch_on_switch background"];
        
        self.lbl.textAlignment = NSTextAlignmentLeft;
        self.lbl.textColor = UIColorFromSixteenRGB(0x88d03f);
        self.lbl.text = @"已开启分享";
        
    }else
    {
        [self.button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateHighlighted];
        self.bgImgV.image = [UIImage imageNamed:@"by_switch_off_switch background"];
        
        self.lbl.textAlignment = NSTextAlignmentRight;
        self.lbl.textColor = [UIColor whiteColor];
        self.lbl.text = @"滑动开启分享";
    }
}

#pragma mark - private


#pragma mark - lazyLoad
- (UIImageView *)bgImgV
{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"by_switch_off_switch background"]];
        
    }
    return _bgImgV;
}

- (UILabel *)lbl
{
    if (!_lbl) {
        
        _lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbl.font = [UIFont systemFontOfSize:12.0];
        _lbl.textAlignment = NSTextAlignmentRight;
        _lbl.textColor = [UIColor whiteColor];
        _lbl.text = @"滑动开启分享";
    }
    return _lbl;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        _button.frame = CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.height);
        [_button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"by_switch_off_handleSwitch_off_handle"] forState:UIControlStateHighlighted];
        [_button sizeToFit];
    }
    return _button;
}

- (SwitchViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SwitchViewModel alloc] init];
    }
    return _viewModel;
}
@end
