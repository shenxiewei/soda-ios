//
//  ShareInviteCodeViewController.m
//  JoyMove
//
//  Created by cty on 15/10/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ShareInviteCodeViewController.h"
#import "FMShare.h"

@interface ShareInviteCodeViewController ()
{
    UIButton *_leftButton;
    //邀请码label
    UILabel *_inviteCodeLabel;
    //分享按钮
    UIButton *_shareInviteCodeButton;
    //旋转的小菊花
    UIActivityIndicatorView *_loadActivityIndicator;
}
@end

@implementation ShareInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationItem];
    [self initUI];
    [self requestShareInviteCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initNavigationItem {
    
    self.title = NSLocalizedString(@"Gift for invitation", nil);
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

-(void)initUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenWidth-250.0/375*kScreenWidth)];
    headImage.image=[UIImage imageNamed:@"shareInviteCodeImage"];
    headImage.contentMode = UIViewContentModeCenter;
    [self.view addSubview:headImage];
    
    UILabel *shareLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, headImage.frame.size.height+headImage.frame.origin.y+32, kScreenWidth - 40, 18.0/667*kScreenHeight)];
    shareLabel.textAlignment=NSTextAlignmentCenter;
    shareLabel.text= NSLocalizedString(@"Share the invitation code with your friends!", nil);
    shareLabel.adjustsFontSizeToFitWidth = YES;
    shareLabel.textColor=UIColorFromSixteenRGB(0x515151);
    shareLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:shareLabel];
    
    UILabel *shareLabel2=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(shareLabel.frame) + 10, kScreenWidth - 40, 0)];
    shareLabel2.textAlignment=NSTextAlignmentCenter;
    shareLabel2.text= NSLocalizedString(@"You and your friends will get 30 RMB coupon after entering the invitation code and registration success.", nil);
//    shareLabel2.adjustsFontSizeToFitWidth = YES;
    shareLabel2.textColor=UIColorFromSixteenRGB(0x515151);
    shareLabel2.font=[UIFont systemFontOfSize:15];
    shareLabel2.numberOfLines = 0;
    [shareLabel2 sizeToFit];
    [self.view addSubview:shareLabel2];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, shareLabel2.frame.origin.y+shareLabel2.frame.size.height+37.0/667*kScreenHeight, kScreenWidth, 15)];
    promptLabel.text=NSLocalizedString(@"Your invitation code is", nil);
    promptLabel.textAlignment=NSTextAlignmentCenter;
    promptLabel.font=[UIFont systemFontOfSize:15];
    promptLabel.textColor=UIColorFromSixteenRGB(0xb6b6b6);
    [self.view addSubview:promptLabel];
    
    _inviteCodeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, promptLabel.frame.size.height+promptLabel.frame.origin.y+17.0/667*kScreenHeight, kScreenWidth, 15)];
    _inviteCodeLabel.textAlignment=NSTextAlignmentCenter;
    _inviteCodeLabel.textColor=UIColorFromSixteenRGB(0xffb85a);
    _inviteCodeLabel.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:_inviteCodeLabel];
    
    _shareInviteCodeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_shareInviteCodeButton setTitle:NSLocalizedString(@"Share invitation code", nil) forState:UIControlStateNormal];
    [_shareInviteCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareInviteCodeButton.titleLabel.font=[UIFont systemFontOfSize:18];
    _shareInviteCodeButton.frame=CGRectMake(14.0/375*kScreenWidth, _inviteCodeLabel.frame.origin.y+_inviteCodeLabel.frame.size.height+42.0/667*kScreenHeight, kScreenWidth-28.0/375*kScreenWidth, 46.0/667*kScreenHeight);
    [_shareInviteCodeButton setBackgroundImage:[UIImage imageNamed:@"shareCodeButtonImage"] forState:UIControlStateNormal];
    [_shareInviteCodeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareInviteCodeButton];
    _shareInviteCodeButton.hidden=YES;
    
    _loadActivityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadActivityIndicator.center=CGPointMake(kScreenWidth/2.0, _inviteCodeLabel.frame.origin.y+7.5/667*kScreenHeight);
    [_loadActivityIndicator startAnimating];
    [self.view addSubview:_loadActivityIndicator];
}

- (void)updateUI
{
    _inviteCodeLabel.text=self.inviteCodeString;
    if (_inviteCodeLabel.text.length>0)
    {
        _shareInviteCodeButton.hidden=NO;
        [_loadActivityIndicator stopAnimating];
        [_loadActivityIndicator setHidesWhenStopped:YES];
    }
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_shareInviteCodeButton==button)
    {
        [FMShare shareInviteCode:self.inviteCodeString];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Request

- (void)requestShareInviteCode
{
    NSDictionary *dic = @{};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlInviteCode) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             if (10000==result)
             {
                 self.inviteCodeString=[response objectForKey:@"invitationCode"];
                 if (self.inviteCodeString.length==0)
                 {
                     self.inviteCodeString=@"";
                 }
                 [self updateUI];
             }
             else if (result==12000)
             {
                 [self createNoNetWorkViewWithReloadBlock:^{
                     
                 }];
             }
             else
             {
                 ;
             }
         }
         else
         {
             [self performSelector:@selector(requestShareInviteCode) withObject:nil afterDelay:5];
         }
     }];
}

@end
