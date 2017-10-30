//
//  SodaClassViewController.m
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SodaClassViewController.h"

@interface SodaClassViewController ()<UIWebViewDelegate>


@property(strong, nonatomic)UIBarButtonItem *closeItem;

@end

@implementation SodaClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.myWebView.delegate = self;
     [self loadUrl:@"http://static.sodacar.com/task/pages/index.html"];
    
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself backNative];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.myWebView canGoBack]) {
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        [self addNavCloseItem];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SD_BEGIN_LOGN(NSStringFromClass([self class]));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    SD_END_LOGN(NSStringFromClass([self class]));
}

#pragma mark - 添加关闭按钮

//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.myWebView canGoBack]) {
        //如果有则返回
        [self.myWebView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        
    } else {
        [self closeNative];
    }
}


//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNavCloseItem
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.navigationItem.leftBarButtonItems.count+1];
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
        [array addObject:item];
    }
    if (![array containsObject:self.closeItem]) {
         [array addObject:self.closeItem];
    }
    self.navigationItem.leftBarButtonItems = array;
}

#pragma mark - lazyLoad

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
         [_closeItem setTintColor:UIColorFromRGB(120.0, 120.0, 120.0)];
    }
    return _closeItem;
}
@end
