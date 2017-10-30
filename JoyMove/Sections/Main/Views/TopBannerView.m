//
//  TopBannerView.m
//  JoyMove
//
//  Created by Soda on 2017/9/14.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TopBannerView.h"
#import "JoyMove-Swift.h"

#import "MyCar.h"
#import "TopBannerViewModel.h"

@import SevenSwitch;
@interface TopBannerView ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIImageView *bgV;

@property(nonatomic, strong) UILabel *carNumLbl;
@property(nonatomic, strong) UILabel *daysLbl;

@property(nonatomic, strong) UILabel *statusLbl;
@property(nonatomic, strong) SevenSwitch *mySwitch;

@property(nonatomic, strong) UIButton *refreshBtn;

@property(nonatomic, strong) TopBannerViewModel *viewModel;


@end

@implementation TopBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //self.status = TopBannerViewStatusIsDistributing
    }
    return self;
}

- (instancetype)initWithViewModel:(id<SDCViewModelProtocol>)viewModel
{
    self.viewModel = (TopBannerViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints
{
    [super updateConstraints];
    JMWeakSelf(self);
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
    
    [self.daysLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.0, 19.0));
        make.left.equalTo(weakself).with.offset(20);
        make.bottom.equalTo(weakself).with.offset(-20);
    }];
    
    [self.carNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.0, 19.0));
        make.centerX.equalTo(weakself.daysLbl);
        make.bottom.equalTo(weakself.daysLbl.mas_top).with.offset(-8.0);
    }];
    
    [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130.0, 40.0));
        make.centerY.equalTo(weakself);
        make.right.equalTo(weakself).with.offset(-20.0);
    }];
    
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(190.0, 17.0));
        make.centerY.equalTo(weakself);
        make.left.equalTo(weakself).with.offset(20.0);
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80.0, 30.0));
        make.centerY.equalTo(weakself);
        make.right.equalTo(weakself).with.offset(-20.0);
    }];
}

- (void)sdc_setupViews
{
    [self addSubview:self.bgV];
    
    /***测试默认数据***/
    self.daysLbl.text = @"余  23  天";
    self.carNumLbl.text = @"川AS33Y7";
   // [self bigDayByLabel:self.daysLbl];
    
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.tapSubject sendNext:nil];
    }];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.carNumLbl];
    [self addSubview:self.daysLbl];
    [self addSubview:self.mySwitch];
    
    [self addSubview:self.statusLbl];
    [self addSubview:self.refreshBtn];
}

- (void)sdc_bindViewModel
{
    @weakify(self)
    
    [[self.refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.refreshRentStatusCommand execute:nil];
    }];
    
    [self.viewModel.shareCarSuccessSubject subscribeNext:^(id x) {
         @strongify(self)
        self.mySwitch.thumbImage = self.mySwitch.on?UIImageName(@"switch_on"):UIImageName(@"switch_off");
    }];
    
    [self.viewModel.unShareCarSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        self.mySwitch.thumbImage = self.mySwitch.on?UIImageName(@"switch_on"):UIImageName(@"switch_off");
    }];
    
    [self.viewModel.refreshSubject subscribeNext:^(NSDictionary *data) {
        if (data[@"licenseNum"]) {
            [[MyCar shareIntance] loadCar:data];
            self.status = TopBannerViewStatusMonth;
            [self updateInfo:@{@"licenseNum":data[@"licenseNum"]}];
        }else
        {
            self.status = TopBannerViewStatusIsDistributing;
        }
    }];
}

#pragma mark - public
- (void)updateInfo:(NSDictionary *)params
{
    self.carNumLbl.text = params[@"licenseNum"];
    
    double days = [MyCar shareIntance].expireTime-[MyCar shareIntance].serverTime;
    days =  days/1000/60/60/24;
    if (days <= 0) {
        days = 0;
    }
    NSInteger temp = ceil(days);
    self.daysLbl.text = [NSString stringWithFormat:@"余  %ld  天",(long)temp];
    [self bigDayByLabel:self.daysLbl highlightString:[NSString stringWithFormat:@"%li",(long)temp]];
    
    if ([params[@"isShare"] integerValue] == 0) {
       [self.mySwitch setOn:NO animated:YES];
    }else
    {
        [self.mySwitch setOn:YES animated:YES];
    }
}

#pragma mark - getter & setter
- (void)setStatus:(TopBannerViewStatus)status
{
    _status = status;
    
    if (_status == TopBannerViewStatusIsDistributing) {
        self.carNumLbl.hidden = YES;
        self.daysLbl.hidden = YES;
        self.mySwitch.hidden = YES;
        
        self.statusLbl.hidden = NO;
        self.refreshBtn.hidden = NO;
    }else
    {
        self.carNumLbl.hidden = NO;
        self.daysLbl.hidden = NO;
        self.mySwitch.hidden = NO;
        
        self.statusLbl.hidden = YES;
        self.refreshBtn.hidden = YES;
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SevenSwitch.SevenSwitch"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - event response
- (void)switchChanged:(SevenSwitch *)sender {
    if (self.mySwitch.on) {//目前是分享状态，点击关闭
        [[self.viewModel.shareCarCommand execute:nil] subscribeError:^(NSError *error) {
            [self.mySwitch setOn:NO animated:YES];
        }];
    }else //目前是未分享状态，点击分享
    {
        [[self.viewModel.unShareCarCommand execute:nil] subscribeError:^(NSError *error) {
             [self.mySwitch setOn:YES animated:YES];
        }];
    }
}

#pragma mark - private
- (void)bigDayByLabel:(UILabel *)label highlightString:(NSString *)string
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.daysLbl.text];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:string].location, [[noteStr string] rangeOfString:string].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromSixteenRGB(0xf66a4e) range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:UIBoldFontFromSize(24) range:redRange];
    [label setAttributedText:noteStr];
}

- (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startD =[inputFormatter dateFromString:beginDate];
    NSDate *endD = [inputFormatter dateFromString:endDate];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:0];
    
    return dateCom.day;
}

#pragma mark - lazyLoad
- (UIImageView *)bgV
{
    if (!_bgV) {
       _bgV = [[UIImageView alloc] initWithImage:UIImageName(@"suspension")];
    }
    return _bgV;
}

- (UILabel *)carNumLbl
{
    if (!_carNumLbl) {
        _carNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _carNumLbl.font = UIFontFromSize(14.0);
        _carNumLbl.textColor = UIColorFromSixteenRGB(0x272727);
        _carNumLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _carNumLbl;
}

- (UILabel *)daysLbl
{
    if (!_daysLbl) {
        _daysLbl = [[UILabel alloc] init];
        _daysLbl.font = UIFontFromSize(14.0);
        _daysLbl.textColor = UIColorFromSixteenRGB(0x272727);
        _daysLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _daysLbl;
}

- (UILabel *)statusLbl
{
    if (!_statusLbl) {
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.font = UIFontFromSize(14.0);
        _statusLbl.textColor = UIColorFromSixteenRGB(0x272727);
        _statusLbl.textAlignment = NSTextAlignmentLeft;
        _statusLbl.text = @"支付成功，正在分配车辆...";
    }
    return _statusLbl;
}

- (SevenSwitch *)mySwitch
{
    if (!_mySwitch) {
        _mySwitch= [[SevenSwitch alloc] initWithFrame:CGRectZero];
        [_mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _mySwitch.inactiveColor = UIColorFromRGB(204.0, 204.0, 204.0);
        _mySwitch.onTintColor = UIColorFromRGB(210.0, 236.0, 168.0);
        _mySwitch.thumbImage = UIImageName(@"switch_off");
        _mySwitch.offLabel.text = @"滑动开启分享";
        _mySwitch.onLabel.textColor = UIColorFromSixteenRGB(0x88d03f);
        _mySwitch.onLabel.text = @"已开始分享";
    }
    return _mySwitch;
}

- (UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = UIFontFromSize(12.0);
        [_refreshBtn setTitleColor:UIColorFromSixteenRGB(0xf66a4e) forState:UIControlStateNormal];
        _refreshBtn.layer.borderWidth = 1.0;
        _refreshBtn.layer.borderColor = UIColorFromSixteenRGB(0xf66a4e).CGColor;
    }
    return _refreshBtn;
}
@end
