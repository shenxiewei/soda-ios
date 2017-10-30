//
//  HintRentView.m
//  JoyMove
//
//  Created by Soda on 2017/9/29.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "HintRentView.h"
#import "HintRentViewModel.h"

@interface HintRentView()

@property(nonatomic,strong) UILabel *tipLbl;
@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) HintRentViewModel *viewModel;
@end


@implementation HintRentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromSixteenRGB(0xf87a63);
    }
    return self;
}

- (instancetype)initWithViewModel:(id<SDCViewModelProtocol>)viewModel
{
    self.viewModel = (HintRentViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    JMWeakSelf(self);
    [self.tipLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250.0, 20.0));
        make.left.equalTo(weakself).with.offset(20);
        make.bottom.equalTo(weakself).with.offset(-10);
    }];
    
    [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30.0));
        make.right.equalTo(weakself).with.offset(-20);
        make.bottom.equalTo(weakself).with.offset(-5);
    }];
    
}

- (void)sdc_setupViews
{
    [self addSubview:self.tipLbl];
    [self addSubview:self.btn];
    
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.tapSubject sendNext:nil];
    }];
    [self addGestureRecognizer:tap];
}
#pragma mark - lazyLoad
- (UILabel *)tipLbl
{
    if (!_tipLbl) {
        _tipLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLbl.font = UIFontFromSize(14.0);
        _tipLbl.textColor = [UIColor whiteColor];
        _tipLbl.text = @"您的套餐已不足七天，请尽快续租";
    }
    return _tipLbl;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"立即续租" forState:UIControlStateNormal];
        _btn.layer.borderWidth = 1.0;
        _btn.layer.borderColor = [UIColor whiteColor].CGColor;
        _btn.titleLabel.textColor = [UIColor whiteColor];
        _btn.titleLabel.font = UIFontFromSize(12.0);
        _btn.enabled = NO;
    }
    return _btn;
}
@end
