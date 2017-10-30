//
//  SDCWebViewController.m
//  JoyMove
//
//  Created by Soda on 2017/10/12.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import<WebKit/WebKit.h>

@interface SDCWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation SDCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.myWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progressBarView.backgroundColor = UIColorFromRGB(241, 81, 61);
    [_progressView setProgress:0.0 animated:YES];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    JMWeakSelf(self);
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view);
    }];
}


#pragma mark - NJKWebViewProgressDelegate


-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - public
- (void)loadUrl:(NSString *)urlStr
{
    NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.myWebView loadRequest:request];
}
#pragma mark - lazyLoad
- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _myWebView;
}
@end
