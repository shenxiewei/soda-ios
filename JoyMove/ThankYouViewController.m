//
//  ThankYouViewController.m
//  JoyMove
//
//  Created by ethen on 15/3/26.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ThankYouViewController.h"
#import "FMShare.h"
#import "Macro.h"
#import "AFNetworking.h"

@interface ThankYouViewController () {
    
    UIButton *_shareBtn;
    UIButton *_leftButton;
    //要分享出去的图片
    NSString *_backImageName;
    
}

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.shareImageArray=[[NSArray alloc]init];
    
    [self initNavigationItem];
    [self initUI];
    [self requestShareImage];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [OrderData orderData].state = OrderStatusNoOrder;
}

#pragma mark - UI

- (void)initNavigationItem {
    
    self.title = @"支付完成";
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
}

- (void)initUI {
    
    [self.baseView removeFromSuperview];
    self.view.backgroundColor=UIColorFromRGB(46, 48, 60);
//    UIImage *image = UIImageName(@"thankYou");
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-image.size.width)/2, (kScreenHeight-64)/2-125, image.size.width, image.size.height)];
//    imageView.image = image;
//    [self.view addSubview:imageView];
//    
    self.uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight-64)/2, kScreenWidth, 25)];
    self.uploadLabel.textColor = UIColorFromRGB(120, 120, 120);
    self.uploadLabel.textAlignment = NSTextAlignmentCenter;
    self.uploadLabel.font = UIFontFromSize(14);
    [self.view addSubview:self.uploadLabel];
    
    self.backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth)];
    [self.view addSubview:self.backImageView];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareBtn.frame = CGRectMake(40, self.backImageView.frame.origin.y+self.backImageView.frame.size.height+80.0/667*kScreenHeight, kScreenWidth-80, 44);
    if (kIphone5)
    {
        _shareBtn.frame = CGRectMake(40, self.backImageView.frame.origin.y+self.backImageView.frame.size.height+50, kScreenWidth-80, 44);
    }
    if (kIphone4)
    {
        _shareBtn.frame = CGRectMake(40, self.backImageView.frame.origin.y+self.backImageView.frame.size.height+30, kScreenWidth-80, 44);
    }
    [_shareBtn setBackgroundImage:UIImageName(@"shareButtonImage") forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享旅程" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
    _shareBtn.hidden=YES;
}

- (void)updateUI
{
    if (self.shareImageArray.count>0)
    {
        int value = (arc4random() % _shareImageArray.count) + 1;
        int randomValue=value-1;
        if (randomValue<0 || randomValue>_shareImageArray.count-1)
        {
            randomValue=0;
        }
        
        if (self.shareImageArray[randomValue]==nil)
        {
            self.backImageView.image=[UIImage imageNamed:@"shareImageFrist"];   //天元测试
        }
        else
        {
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.shareImageArray[randomValue]]];
        }

        _backImageName=self.shareImageArray[randomValue];
        _shareBtn.hidden=NO;
    }
    else
    {
        ;
    }
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_shareBtn==button) {
        
        [FMShare shareImage:_backImageName];
    }else {
        
        //发送消息通知首页, 并且pop回首页
        [self.navigationController popToRootViewControllerAnimated:YES];
        PostNotification(@"orderStatusDidChange");
    }
}

#pragma mark - Request

- (void)requestShareImage
{
    self.uploadLabel.text = @"载入中...";
    
    NSDictionary *dic = @{};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlShareImage) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             self.shareImageArray=response[@"posters"];
             [self updateUI];
             if (result==12000)
             {
                 [self createNoNetWorkViewWithReloadBlock:^{
                     
                 }];
             }
         }
         else
         {
             [self performSelector:@selector(requestShareImage) withObject:nil afterDelay:5];
         }
     }];
}

@end
