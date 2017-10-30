//
//  PopPayView.m
//  JoyMove
//
//  Created by Soda on 2017/9/15.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "PopPayView.h"
#import "PayViewModel.h"

#import "PayTypeListCell.h"

#import "UserData.h"
#import "MyCar.h"

#import "LoginViewController.h"
#import "UIWindow+Visible.h"

static NSString *const kPayTypeListCellIdentifier = @"PayTypeListCellIdentifier";

@interface PopPayView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectPayType;
}

@property (nonatomic, strong)PayViewModel *viewModel;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *popView;

@property (nonatomic, strong) UITableView *payTableView;
@property (nonatomic, strong) UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *lastLine;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *payLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;

@end

@implementation PopPayView



- (instancetype)initWithViewModel:(id<SDCViewModelProtocol>)viewModel {
    self.viewModel = (PayViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints
{
    [super updateConstraints];
    JMWeakSelf(self);
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakself.frame.size.width, 315.0));
        
        make.left.equalTo(weakself).with.offset(0.0);
        make.right.equalTo(weakself).with.offset(0.0);
        make.top.equalTo(weakself).with.offset(kScreenHeight);
    }];
    
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.lastLine.mas_bottom).with.offset(0.0);
        make.height.equalTo(@(70.0));
        make.left.equalTo(weakself.popView).with.offset(0.0);
        make.right.equalTo(weakself.popView).with.offset(0.0);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.payTableView.mas_bottom).with.offset(15.0);
        make.height.equalTo(@(40.0));
        make.left.equalTo(weakself.popView).with.offset(20.0);
        make.right.equalTo(weakself.popView).with.offset(-20.0);
    }];
}

- (void)sdc_setupViews
{
    _selectPayType = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissAnimation];
    }];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.bgView];
    [self addSubview:self.popView];
    [self.popView addSubview:self.payTableView];
    [self.popView addSubview:self.payButton];
    
    [self updateConstraintsIfNeeded];
}

- (void)sdc_bindViewModel
{
    __block double price = 0.0;
    __block NSInteger packageid = -1;
    @weakify(self)
    RACSignal *zipSigal = [self.viewModel.balanceSubject zipWith:self.viewModel.allPackageSubject];
    [zipSigal subscribeNext:^(id x) {
        RACTuple *tuple = x;
        
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self)
            self.popView.center = CGPointMake(self.popView.center.x, kScreenHeight-self.popView.frame.size.height*0.5);
        }];
        self.balanceLbl.text = [NSString stringWithFormat:@"%.2f元",[UserData share].balance];
        
        for (NSDictionary *response in tuple.allObjects) {
            if (![response isEqual:[NSNull null]]) {
                price = [response[@"balance"] doubleValue];
                packageid = [response[@"id"] integerValue];
                self.totalPriceLbl.text =  [NSString stringWithFormat:@"%.2f元",[response[@"balance"] doubleValue]];
                float needPay = [response[@"balance"] doubleValue]-[UserData share].balance;
                needPay = needPay<=0.0?0.0:needPay;
                
                self.payLbl.text = [NSString stringWithFormat:@"%.2f元",needPay];
            }
        }
        
        self.payButton.enabled = YES;
        [self.payButton setTitle:[NSString stringWithFormat:@"确认支付（%@）",self.payLbl.text] forState:UIControlStateNormal];
        self.payButton.backgroundColor = UIColorFromSixteenRGB(0x0097ed);
    }];
    
    [[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if ([UserData share].balance >= price) { //余额支付
           NSDictionary  *temp = @{@"rentalPackageId":@(packageid),
                       @"accountPay":@(price),
                       @"amount":@0,
                       @"type":@6};
            
            [params addEntriesFromDictionary:temp];
        }else   //减去余额，付剩下下
        {
            double realPayBalance  = price - [UserData share].balance;
            NSDictionary  *temp = @{@"rentalPackageId":@(packageid),
                       @"accountPay":@([UserData share].balance),
                       @"amount":@(realPayBalance),
                       @"type":@(_selectPayType)
                       };
            [params addEntriesFromDictionary:temp];
        }
        if ([MyCar shareIntance].retalID) {
            [params setObject:@([[MyCar shareIntance].retalID integerValue]) forKey:@"id"];
        }
        [self requestPay:params];
    }];
}

#pragma mark - public
- (void)showAnimation
{
    [self.viewModel.balanceCommand execute:nil];
    [self.viewModel.checkPackageCommand execute:nil];
}

- (void)dismissAnimation
{
    JMWeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.popView.center = CGPointMake(weakself.popView.center.x, kScreenHeight+weakself.popView.frame.size.height*0.5);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTypeListCellIdentifier] ;
    if (!cell) {
        cell = [[PayTypeListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPayTypeListCellIdentifier];
    }
    [cell configure:cell customObj:nil indexPath:indexPath];
    //默认选中第一个
    if (indexPath.row == 0) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectPayType = indexPath.row+1;
}

#pragma mark - private
- (void)requestPay:(NSDictionary *)params
{
     [self.viewModel.purchasePackageCommand execute:params];
}

#pragma mark - lazyLoad
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.65;
    }
    return _bgView;
}

- (UIView *)popView
{
    if (!_popView) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PopPayView" owner:self options:nil];
        //得到第一个UIView
        _popView = [nib objectAtIndex:0];
        _popView.backgroundColor = [UIColor whiteColor];
    }
    return _popView;
}

- (UITableView *)payTableView
{
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payTableView.scrollEnabled = NO;
    }
    return _payTableView;
}
- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"计算中" forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 4.0;
        _payButton.titleLabel.font = UIFontFromSize(16.0);
        
        _payButton.enabled = NO;
        _payButton.backgroundColor = UIColorFromRGB(210.0, 210.0, 210.0);
    }
    return _payButton;
}
@end
