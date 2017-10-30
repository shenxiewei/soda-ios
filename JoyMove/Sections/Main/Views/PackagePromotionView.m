//
//  PackagePromotionView.m
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "PackagePromotionView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import<WebKit/WebKit.h>

#import "PopPayView.h"
#import "PayViewModel.h"

#import "UIAlertController+Blocks.h"
#import "UIWindow+Visible.h"

#import "Macro.h"
#import "FMShare.h"

@interface PackagePromotionView()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    UINavigationController *_myNav;
}
@property(nonatomic, strong) UIWebView *myWebView;

@property(nonatomic, strong)UIButton *joinButton;

@property(nonatomic, strong)PopPayView *myPayView;
@property(nonatomic, strong)PayViewModel *myPayViewModel;

@property(nonatomic, strong) UIButton *callServiceBtn;
@property(nonatomic, strong) UIButton *shareBtn;

@end

@implementation PackagePromotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _progressProxy = [[NJKWebViewProgress alloc] init];
        self.myWebView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = _myNav.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, 0, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressBarView.backgroundColor = UIColorFromRGB(241, 81, 61);
        [_progressView setProgress:0.0 animated:YES];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
         [self addSubview:_progressView];
    }
    return self;
}

- (void)dealloc
{
    [_progressView removeFromSuperview];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    JMWeakSelf(self);
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.left.equalTo(weakself).with.offset(0);
        make.bottom.equalTo(weakself).with.offset(0);
        make.right.equalTo(weakself).with.offset(0);
    }];
    
    [self.callServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42.0, 42.0));
        make.top.equalTo(weakself).with.offset(20.0);
        make.right.equalTo(weakself).with.offset(-25);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.0, 35.0));
        make.top.equalTo(weakself).with.offset(20.0);
        make.left.equalTo(weakself).with.offset(20.0);
    }];
}

- (void)sdc_setupViews
{
    _myNav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    
    [self addSubview:self.myWebView];
    [self addSubview:self.joinButton];
    [self addSubview:self.callServiceBtn];
    [self addSubview:self.shareBtn];
    
    [_myNav.view addSubview:self.myPayView];
    
    [self loadUrl:kUrlRetalPackageHtml];
    
    [self updateConstraintsIfNeeded];
}

- (void)sdc_bindViewModel
{
    @weakify(self)
    
    [[self.joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        self.myPayView.hidden = NO;
        [self.myPayView showAnimation];
    }] ;
    
    [[self.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [FMShare shareRentForMonthActivityURL:kUrlRetalPackageHtml title:@"苏打出行，限时特价" image:@"http://static.sodacar.com/package/wxShareIcon.jpg"];
    }];
    
    [self.myPayViewModel.paySuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.myPayView dismissAnimation];
        //[self.navigationController popViewControllerAnimated:YES];
        
        //切换到主页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchasePackageSuccess" object:nil];
    }];
    
    [[self.callServiceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self callService];
    }];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - public
- (void)loadUrl:(NSString *)urlStr
{
    NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.myWebView loadRequest:request];
}

#pragma mark - private
- (void)callService
{
    NSString *message = [NSString stringWithFormat:@"您确定要拨打客服电话\n%@",serviceTelephoneDes];
    UIAlertController *alertController = [UIAlertController showAlertInViewController:[[UIApplication sharedApplication].keyWindow visibleViewController] withTitle:@"联系客服" message:message cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil
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

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:UIImageName(@"ic_share") forState:UIControlStateNormal];
        [_shareBtn sizeToFit];
    }
    return _shareBtn;
}

- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _myWebView;
}
@end
