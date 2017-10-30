//
//  WebViewController.m
//  PetBar
//
//  Created by zhangYuan on 14-6-27.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import "WebViewController.h"
#import "Macro.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "FMShare.h"

#import "DepositData.h"
#import "RefundStatusViewController.h"

@interface WebViewController () <UIScrollViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate> {
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIButton *_rightActivityButton;
    UIWebView *_webView;
    
    BOOL isShow;
    
    NSString *_shareURL;
    NSString *_imageURL;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.baseView removeFromSuperview];
    [self isActivityPush:NO];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    isShow = YES;
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    isShow = NO;
    [_progressView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI

-(void)isActivityPush:(BOOL)isActivity
{
    if (isActivity==YES)
    {
        [self initActivityNavigationItem];
        isActivity=NO;
    }
    else
    {
        [self initNavigationItem];
    }
}

- (BOOL)isShow {

    return isShow;
}

- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
//    _webView.delegate = self;
    [self.view addSubview: _webView];
    //_webView.alpha = 0;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)initActivityNavigationItem
{
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIImage *image = [UIImage imageNamed:@"navBackButton"];
    [_leftButton setImage:image forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftItem];
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    
    _rightActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightActivityButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightActivityButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    _rightActivityButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightActivityButton setTitleColor:UIColorFromRGB(0, 172, 238) forState:UIControlStateNormal];
    _rightActivityButton.titleLabel.font = UIFontFromSize(17);
    [_rightActivityButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightActivityButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightItem];
}

- (void)initNavigationItem {
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIImage *image = [UIImage imageNamed:@"navCancelButton"];
    [_leftButton setImage:image forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftItem];
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:NSLocalizedString(@"Agree", nil) forState:UIControlStateNormal];
    _rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightButton setTitleColor:UIColorFromRGB(0, 172, 238) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(17);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightItem];
    _rightButton.hidden = YES;
}

- (void)loadHTML:(NSString *)htmlName {
    
    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
    NSString *path = [mainBundleDirectory stringByAppendingPathComponent:htmlName];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)loadUrl:(NSString *)urlStr {
    _shareURL=urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void)getImageURL:(NSString *)imageURL
{
    _imageURL=imageURL;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //禁止复制,黏贴
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [UIView animateWithDuration:1.f animations:^{
        
        webView.alpha = 1;
    } completion:^(BOOL finished) {
        
        ;
    }];
}

#pragma mark - Action
- (void)buttonClicked:(UIButton *)button {
    
    if (_leftButton==button) {
        
        if (self.navigationController.viewControllers.count>=2) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (_rightButton==button) {

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Agree to enjoy the journey!", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Agree", nil), nil];
        [alert show];
        
    }
    else if (_rightActivityButton==button)
    {
        if (_shareURL.length>0 && self.title.length>0 && _imageURL.length>0)
        {
            [FMShare shareActivityURL:_shareURL title:self.title image:_imageURL];
        }
        else
        {
            
        }
    }
    else {
        
        ;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [OrderData orderData].isWriting = YES;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAgreed)]) {
            
            [self.delegate didAgreed];
        }
    }
}

- (void)setHideAgreeButton:(BOOL)isHide {

    _rightButton.hidden = isHide;
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - 押金
- (void)isDepositPush
{
    if ([DepositData shareIntance].balance > 0.0) {
        UIButton *refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refundBtn.frame = CGRectMake(10, kScreenHeight-10.0-40.0, kScreenWidth-20, 40);
        refundBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
        [refundBtn setTitle:NSLocalizedString(@"Refund", nil) forState:UIControlStateNormal];
        refundBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        refundBtn.layer.cornerRadius = 4;
        refundBtn.layer.masksToBounds = YES;
        [refundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundBtn];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        _webView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-refundBtn.frame.size.height-20.0);
    }
}

- (void)refundAction
{
    
    NSString *title = @"退款须知";
    NSString *message = @"点击退款不可取消，退款到账需要30个工作日，且在此期间不能用车。";
    if ([DepositData shareIntance].status == DeopositStatusFrozen) {
        title = @"友情提示";
        message = @"您的账户已被冻结，请查询明细或致电4000607927";
    }
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    if ([DepositData shareIntance].status == DeopositStatusNormal) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
    }
    
    JMWeakSelf(self);
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([DepositData shareIntance].status == DeopositStatusNormal) {
            [weakself refundDeposit];
        }
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
     
}

- (void)refundDeposit
{
    
    [self showIndeterminate:@""];
    JMWeakSelf(self);
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[DepositData shareIntance].balance]];
    
    [LXRequest requestWithJsonDic:@{@"amount":number} andUrl:kURL(kUrlRefund) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                [weakself hide];
                
                [weakself showInfo:@"退款成功"];
                if (weakself.dismissCompleteBlock) {
                    weakself.dismissCompleteBlock();
                }
                [weakself dismissViewControllerAnimated:NO completion:nil];
            }
            else {
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [weakself showError:message];
            }
        }else {
            
            [weakself showError:JMMessageNetworkError];
        }
    }];
    
}

@end
