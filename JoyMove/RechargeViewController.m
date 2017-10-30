//
//  RechargeViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/4/2.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "RechargeViewController.h"
#import "ThankYouViewController.h"
#import "Alipay.h"
#import "WXPay.h"

@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITextField *_rechargeText;
    UITableView *_tableView;
    NSInteger _payIndex;
}
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    AddObserver(@"alipaySafepay", alipaySafepay:);
    AddObserver(@"wxPayResult", wxPayResult:);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    RemoveObserver(self, @"alipaySafepay");
    RemoveObserver(self, @"wxPayResult");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UI 

- (void)initUI {

    self.title = @"充值";
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    
    [self initTableView];
}

- (void)initTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    
    //充值button
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rechargeButton.frame = CGRectMake(10, 40, kScreenWidth-20, 40);
    rechargeButton.backgroundColor = kThemeColor;
    rechargeButton.titleLabel.font = UIFontFromSize(17);
    rechargeButton.layer.cornerRadius = 4;
    rechargeButton.layer.masksToBounds = YES;
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:rechargeButton];
    _tableView.tableFooterView = footerView;
}
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (0 == section) {
        
        return 1;
    }else {
    
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (1 == section) {
        
        NSString *title = @"选择支付方式";
        return title;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
        cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
    }else {
    
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    if (0 == indexPath.section) {
        
        //充值栏
        cell.textLabel.text = @"押金";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",cash];
    }else {
    
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!indexPath.row) {
            
            cell.imageView.image = UIImageName(@"alipayLogo");
            cell.textLabel.text = @"支付宝";
        }else {
            
            cell.imageView.image = UIImageName(@"wxpayLogo");
            cell.textLabel.text = @"微信支付";
        }
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 10, 20, 20)];
        [cell.contentView addSubview:checkImageView];
        
        checkImageView.image = (_payIndex==indexPath.row)?UIImageName(@"check_sel"):UIImageName(@"check_nor");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (1 == indexPath.section) {
        
        _payIndex = indexPath.row;
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (void)rechargeButtonClick {

    if (!_payIndex) {
     
        [self requestAliPayOrderReq];
    }else {
    
        [self requestWXPayOrderReq];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_rechargeText resignFirstResponder];
}

#pragma mark - request

//支付宝支付
- (void)requestAliPayOrderReq {

    [LXRequest requestWithJsonDic:@{@"balance":[NSString stringWithFormat:@"%f",cash]} andUrl:kURL(kUrlDepositRecharge) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSString *payString = response[@"zhifubao_code"];
                [[Alipay alloc] pay:payString];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
            
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
        
            [self showError:JMMessageNetworkError];
        }
    }];
}

//微信支付
- (void)requestWXPayOrderReq {
    
    //向曲请求：微信支付用的dic参数
    //请求成功后调用
    [LXRequest requestWithJsonDic:@{@"balance":[NSString stringWithFormat:@"%f",cash]} andUrl:kURL(kUrlDepositRecharge) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSDictionary *paydic = response[@"wx_code"];
                [WXPay pay:paydic];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}
#pragma mark - Notification

- (void)alipaySafepay:(NSNotification *)notif {
    
    NSDictionary *dic = notif.userInfo;
    NSLog(@"接收到来自alipay的notification=%@", dic);
    
    NSDictionary *memoDic = dic[@"memo"];
    NSString *status = memoDic[@"ResultStatus"];
    
    
    switch ([status integerValue]) {
            
        case AlipayCodePaySuccess: {
            
            NSLog(@"充值成功");
            
            [self showSuccess:@"充值成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case AlipayCodePayFail: {
            
            NSLog(@"充值失败");
        }
        case AlipayCodeDealing: {
            
            NSLog(@"正在处理中");
        }
        case AlipayCodeUserCancel: {
            
            NSLog(@"用户中途取消");
        }
        case AlipayCodeFail: {
            
            NSLog(@"网络连接出错");
        }
        default: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值尚未完成" message:@"Please try later" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        }
    }
}

- (void)wxPayResult:(NSNotification *)notif {
    
    NSDictionary *dic = notif.userInfo;
    NSLog(@"接收到来自WXPay的notification=%@", dic);
    
    NSNumber *status = dic[@"errCode"];
    
    switch ([status integerValue]) {
            
        case WXSuccess: {
            
            NSLog(@"支付成功");
            
            [self showSuccess:@"充值成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case WXErrCodeCommon: {
            
            NSLog(@"支付失败");
        }
        case WXErrCodeUserCancel: {
            
            NSLog(@"用户中途取消");
        }
        default: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"payment has not been completed" message:@"Please try later" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        }
    }
}

@end
