//
//  AKeyRentCarViewController.m
//  JoyMove
//
//  Created by cty on 15/10/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AKeyRentCarViewController.h"
#import "NearbyCarListViewController.h"


@interface AKeyRentCarViewController ()<NearbyCarDelegate>
{
    UIButton *_leftButton;
    UIButton *_showAllButton;
}
@end

@implementation AKeyRentCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationItem];
    [self initUI];
}

#pragma mark - UI

- (void)initNavigationItem {
    
    self.title = @"无可用车辆";
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
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 98.0/568*kScreenHeight, kScreenWidth, 110.0/568*kScreenHeight)];
    headImage.image=[UIImage imageNamed:@"noCarImage"];
    headImage.contentMode = UIViewContentModeCenter;
    [self.view addSubview:headImage];
    
    UILabel *sorryLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, headImage.frame.size.height+headImage.frame.origin.y+32.0/568*kScreenHeight, kScreenWidth, 15.0/568*kScreenHeight)];
    sorryLabel.textAlignment=NSTextAlignmentCenter;
    sorryLabel.text=@"很遗憾";
    sorryLabel.textColor=UIColorFromSixteenRGB(0x515151);
    sorryLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:sorryLabel];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, sorryLabel.frame.origin.y+sorryLabel.frame.size.height+12.0/568*kScreenHeight, kScreenWidth, 12.0/568*kScreenHeight)];
    promptLabel.text=@"您附近一公里无可用车辆";
    promptLabel.textAlignment=NSTextAlignmentCenter;
    promptLabel.font=[UIFont systemFontOfSize:16];
    promptLabel.textColor=UIColorFromSixteenRGB(0xb5b5b5);
    [self.view addSubview:promptLabel];
    
    _showAllButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_showAllButton setTitle:@"显示全部网点" forState:UIControlStateNormal];
    [_showAllButton setTitleColor:UIColorFromSixteenRGB(0x7f7f7f) forState:UIControlStateNormal];
    _showAllButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _showAllButton.frame=CGRectMake(59.0/320*kScreenWidth, promptLabel.frame.origin.y+promptLabel.frame.size.height+64.0/568*kScreenHeight, kScreenWidth-118.0/320*kScreenWidth, 40.0/568*kScreenHeight);
    [_showAllButton setBackgroundImage:[UIImage imageNamed:@"noCarButton"] forState:UIControlStateNormal];
    [_showAllButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showAllButton];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button
{
    if (button==_showAllButton)
    {
        NearbyCarListViewController *nearbyCarListViewController=[[NearbyCarListViewController alloc]init];
        nearbyCarListViewController.isAKeyRentCarFailure=YES;
        nearbyCarListViewController.nearbyCarDelegate = self;
//        nearbyCarListViewController.userLocationCoor = blockSelf->_userLocationCoor;
        nearbyCarListViewController.showType = ShowTypeCars;
        [self.navigationController pushViewController:nearbyCarListViewController animated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
