//
//  ModifyPhoneViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ModifyPhoneViewController.h"

@interface ModifyPhoneViewController ()
{
    UILabel *_phoneLabel;
}
@end

@implementation ModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号";
    [self setNavBackButtonStyle:BVTagBack];
    [self initUI];
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

- (void)initUI {

    //手机图片
    UIImageView *phoneView = [[UIImageView alloc] init];
    phoneView.frame = CGRectMake(kScreenWidth/2-15, 15, 30, 30);
    phoneView.backgroundColor = [UIColor lightGrayColor];
    [self.baseView addSubview:phoneView];
    
    //手机号
    UILabel *label = [[UILabel alloc] init];
    _phoneLabel = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 60, kScreenWidth, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"你的手机号: %@",_phoneLabel.text];
    label.font = [UIFont systemFontOfSize:13];
    [self.baseView addSubview:label];
    
    //更换手机号button
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    phoneButton.frame = CGRectMake(15, 110, kScreenWidth-30, 30);
    [phoneButton setTitle:@"更换手机号" forState:UIControlStateNormal];
    phoneButton.backgroundColor = UIColorFromRGB(255, 107, 108);
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.baseView addSubview:phoneButton];
}

@end
