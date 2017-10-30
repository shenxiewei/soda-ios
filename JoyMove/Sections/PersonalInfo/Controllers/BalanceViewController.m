//
//  BalanceViewController.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceViewController.h"

#import "BalanceViewModel.h"

#import "UserData.h"

@interface BalanceViewController ()

@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UILabel *balanceLbl;
@property(nonatomic, strong) UILabel *earnLbl;

@property(nonatomic, strong) UIImageView *noImgView;
@property(nonatomic, strong) UILabel *noLbl;

@property(nonatomic, strong) BalanceViewModel *viewModel;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的余额";
    
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self customRightNavWithParams:@{@"title":@"余额明细",@"color":UIColorFromRGB(0, 172, 238),@"font":UIFontFromSize(14),@"frame":NSStringFromCGRect(CGRectMake(0.0, 0.0, 88.0, 44.0))} touchUpInsideBlock:^{
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"BalanceDetail" actionName:@"balanceDetailViewController" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)sdc_addSubviews
{
    
}

- (void)sdc_bindViewModel
{
    [self.viewModel.checkBalanceCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.successSubject subscribeNext:^(NSDictionary *response) {
        @strongify(self)
        double balance = [response[@"balance"] doubleValue];
        double shareRevenue = [response[@"shareRevenue"] doubleValue];
        
        if (balance <= 0.0 && shareRevenue <= 0.0) {
            [self.view addSubview:self.noImgView];
            [self.view addSubview:self.noLbl];
            [self layoutNoMoneyUI];
        }else
        {
            [self.view addSubview:self.imgView];
            [self.view addSubview:self.balanceLbl];
            [self.view addSubview:self.earnLbl];
            
            self.earnLbl.text = [NSString stringWithFormat:@"已通过分享车辆赚取%.2f元 ",shareRevenue];
            self.balanceLbl.text = [NSString stringWithFormat:@"￥%.2f",balance];
            
            [self layoutMoneyUI];
        }
    }];
}

#pragma mark - private
- (void)layoutNoMoneyUI
{
    JMWeakSelf(self);
    [self.noImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view.mas_centerY).offset(-10.0);
    }];
    
    [self.noLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.view.mas_centerY).offset(10.0);
    }];
}

- (void)layoutMoneyUI
{
    JMWeakSelf(self);
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.view).with.offset(84.0);
    }];
    
    [self.balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 60));
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.imgView.mas_bottom).with.offset(10.0);
    }];
    
    [self.earnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [weakself.earnLbl.text sizeWithAttributes:@{NSFontAttributeName:weakself.earnLbl.font}];
        
        make.size.mas_equalTo(CGSizeMake(size.width, 20));
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.balanceLbl.mas_bottom).with.offset(10.0);
    }];
}
#pragma mark - lazyLoad
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:UIImageName(@"my_wallet")];
    }
    return _imgView;
}

- (UILabel *)balanceLbl
{
    if (!_balanceLbl) {
        _balanceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _balanceLbl.textAlignment = NSTextAlignmentCenter;
        _balanceLbl.textColor = UIColorFromSixteenRGB(0xf2624b);
        _balanceLbl.font = UIFontFromSize(36.0);
    }
    return _balanceLbl;
}

- (UILabel *)earnLbl
{
    if (!_earnLbl) {
        _earnLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _earnLbl.textAlignment = NSTextAlignmentCenter;
        _earnLbl.backgroundColor = UIColorFromSixteenRGB(0xdff3ff);
        _earnLbl.textColor = UIColorFromSixteenRGB(0x787878);
        _earnLbl.font = UIFontFromSize(18.0);
    }
    return _earnLbl;
}

- (UIImageView *)noImgView
{
    if (!_noImgView) {
        _noImgView= [[UIImageView alloc] initWithImage:UIImageName(@"no_money")];
    }
    return _noImgView;
}

- (UILabel *)noLbl
{
    if (!_noLbl) {
        _noLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
        _noLbl.text = @"空空如也";
        _noLbl.textColor = UIColorFromRGB(180.0, 180.0, 180.0);
        _noLbl.textAlignment = NSTextAlignmentCenter;
        _noLbl.font = UIFontFromSize(15.0);
    }
    return _noLbl;
}

- (BalanceViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[BalanceViewModel alloc] init];
    }
    return _viewModel;
}
@end
