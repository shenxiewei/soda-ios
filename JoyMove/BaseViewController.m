//
//  BaseViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UMMobClick/MobClick.h"
#import "Reachability.h"
#import "OfflineMapViewController.h"
#import "AFNetworking.h"


@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) OfflineMapViewController *offlineMap;
@property(nonatomic,strong) LoginViewController *loginViewController;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    self.view.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    // 增加侧滑返回手势，不用实现代理
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self initBackgroundView];
    
    // Wi-Fi状态自动下载地图
//    self.offlineMap = [[OfflineMapViewController alloc] init];
//    [self getWiFiStatusAndDownloadMap];
}
// Wi-Fi状态自动离线地图
- (void)getWiFiStatusAndDownloadMap{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 // 回调处理
                 [weakSelf.offlineMap downloadCities];
                 break;
             default:
                 break;
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createNoNetWorkViewWithReloadBlock:(PushLoginBlock)reloadData
{
    
    if (!_loginViewController)
    {
        [self hide];
        [UserData logout];
        _loginViewController=[[LoginViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_loginViewController];
        
        _loginViewController.pushRootViewController=^
        {
            _loginViewController=nil;
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

-(void)loginViewControllerNil
{
    if (_loginViewController)
    {
        _loginViewController=nil;
    }
}

- (BOOL)isLogin {
    
    if (![UserData isLogin]) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
        return NO;
    }else {
        
        return YES;
    }
}

- (void)initBackgroundView {

    _baseView = [[UIView alloc]init];
    _baseView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    _baseView.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    _baseView.userInteractionEnabled = YES;
    [self.view addSubview:_baseView];
}

- (void)setNavBackButtonTitle:(NSString *)title {

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = title ?: @"";
    self.navigationItem.backBarButtonItem = backButton;
}

//导航栏 返回和取消
- (void)setNavBackButtonStyle:(BaseViewTag)style {

    self.navigationItem.hidesBackButton = YES;
    
    if (BVTagBack == style) {
        
        UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        leftSpacer.width = -15;
        
        UIButton *backNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
        backNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
        backNavigationItemButton.tag = BVTagBack;
        [backNavigationItemButton setImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal];
        [backNavigationItemButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backNavigationItemButton];
        self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
    }else {
    
        UIButton *cancelNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
        cancelNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
        cancelNavigationItemButton.tag = BVTagCancel;
        [cancelNavigationItemButton setImage:[UIImage imageNamed:@"navCancelButton"] forState:UIControlStateNormal];
        [cancelNavigationItemButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: cancelNavigationItemButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

- (void)setNavRightButton:(UIButton *)button {
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
}

#pragma mark - Action
//导航栏返回、取消点击事件
- (void)navButtonClicked:(UIButton *)button {

    if (BVTagBack == button.tag) {

        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - HUD

- (void)showIndeterminate:(NSString *)text {
    
    if (!text||!text.length) {
        
        text = NSLocalizedString(@"Please wait", nil);
    }
    
    [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeBlack];
}

- (void)showSuccess:(NSString *)text {
    
    [SVProgressHUD showSuccessWithStatus:text maskType:SVProgressHUDMaskTypeBlack];
}

- (void)showError:(NSString *)text {
    
    [self showInfo:text];
}

- (void)showInfo:(NSString *)text {
    
    [SVProgressHUD showInfoWithStatus:text maskType:SVProgressHUDMaskTypeBlack];
}

- (void)showProgress:(float)progress text:(NSString *)text {
    
    [SVProgressHUD showProgress:progress status:text maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hide {
    
    [SVProgressHUD dismiss];
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     
     [SVProgressHUD dismiss];
     });
     */
}

@end
