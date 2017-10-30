//
//  MonthRentVC.m
//  JoyMove
//
//  Created by Soda on 2017/9/10.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MonthRentVC.h"
#import "LoginViewController.h"

#import "FMShare.h"

#import "PopPayView.h"
#import "PayViewModel.h"

#import "UIAlertController+Blocks.h"

@interface MonthRentVC ()

@property(nonatomic, strong)UIButton *joinButton;

@property(nonatomic, strong)PopPayView *myPayView;
@property(nonatomic, strong)PayViewModel *myPayViewModel;

@property(nonatomic, strong) UIButton *callServiceBtn;
@end

@implementation MonthRentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JMWeakSelf(self);
//    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
//        [weakself.navigationController popViewControllerAnimated:YES];
//    }];
//
//    [self customRightNavWithParams:@{@"title":@"分享",@"color":UIColorFromRGB(0, 172, 238),@"font":UIFontFromSize(14)} touchUpInsideBlock:^{
//        [FMShare shareRentForMonthActivityURL:kUrlRetalPackageHtml title:@"月租1800，把车开回家。" image:@"http://static.sodacar.com/package/wxShareIcon.jpg"];
//    }];
    
    [self sdc_addSubviews];
    [self sdc_bindViewModel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"rent vc");
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    JMWeakSelf(self);
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.left.equalTo(weakself.view).with.offset(0);
        make.bottom.equalTo(weakself.view).with.offset(0);
        make.right.equalTo(weakself.view).with.offset(0);
    }];
    
    [self.callServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42.0, 42.0));
        make.top.equalTo(weakself.view).with.offset(20.0+64.0);
        make.right.equalTo(weakself.view).with.offset(-25);
    }];
}

- (void)sdc_addSubviews
{
    
    [self.view addSubview:self.joinButton];
    [self.view addSubview:self.callServiceBtn];
    [self.navigationController.view addSubview:self.myPayView];
    
    [self loadUrl:kUrlRetalPackageHtml];
}

- (void)sdc_bindViewModel
{
    @weakify(self)
    
    [[self.joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        self.myPayView.hidden = NO;
        [self.myPayView showAnimation];
    }] ;
    
    [self.myPayViewModel.paySuccessSubject subscribeNext:^(id x) {
       @strongify(self)
        [self.myPayView dismissAnimation];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.callServiceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self callService];
    }];
}

#pragma mark - private
- (void)callService
{
    NSString *message = [NSString stringWithFormat:@"您确定要拨打客服电话\n%@",serviceTelephoneDes];
    UIAlertController *alertController = [UIAlertController showAlertInViewController:self withTitle:@"联系客服" message:message cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil
 tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
     if (buttonIndex == 1) {
         NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     }
 }];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:serviceTelephoneDes].location, [[noteStr string] rangeOfString:serviceTelephoneDes].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromSixteenRGB(0x0096ed) range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:UIBoldFontFromSize(16) range:redRange];
    
    [alertController setValue:noteStr forKey:@"attributedMessage"];
}

#pragma mark - lazyLoad
- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"立即参与" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.backgroundColor = UIColorFromSixteenRGB(0xf66a4e);
    }
    return _joinButton;
}

- (PopPayView *)myPayView
{
    if (!_myPayView) {
        _myPayView = [[PopPayView alloc] initWithViewModel:self.myPayViewModel];
        _myPayView.frame = CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight);
        _myPayView.hidden = YES;
    }
    return _myPayView;
}

- (PayViewModel *)myPayViewModel
{
    if (!_myPayViewModel) {
        _myPayViewModel = [[PayViewModel alloc] init];
    }
    return _myPayViewModel;
}

- (UIButton *)callServiceBtn
{
    if (!_callServiceBtn) {
        _callServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callServiceBtn setImage:UIImageName(@"customer_service") forState:UIControlStateNormal];
        [_callServiceBtn sizeToFit];
    }
    return _callServiceBtn;
}
@end
