//
//  DepositViewController.m
//  JoyMove
//
//  Created by Soda on 2017/3/7.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "DepositViewController.h"
#import "DepositTableViewCell.h"
#import "TradeDetailViewController.h"
#import "RefundStatusViewController.h"
#import "Alipay.h"
#import "WXPay.h"

@interface DepositViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleImages;
    NSArray *titleNames;
    NSInteger currentPayType;
}

@end

@implementation DepositViewController

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPayType = 1;
    
    titleImages = @[UIImageName(@"alipayLogo"),UIImageName(@"wxpayLogo")];
    titleNames = @[NSLocalizedString(@"Alipay", nil),NSLocalizedString(@"WeChat Payment", nil)];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Deposit", nil);
    [self setNavBackButtonStyle:BVTagBack];
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    
    UIButton *cancelNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
    cancelNavigationItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancelNavigationItemButton setTitle:@"明细" forState:UIControlStateNormal];
    [cancelNavigationItemButton setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    [cancelNavigationItemButton addTarget:self action:@selector(tradeDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: cancelNavigationItemButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
    
    if (!self.isNeedCharge) {
        [self initNoramlDeposit];
    }else
    {
        self.title = NSLocalizedString(@"Recharge", nil);
        [self initChargeDeposit];
    }
    
    //通知事件判断支付是否成功
    AddObserver(@"alipaySafepay", alipaySafepay:);
    AddObserver(@"wxPayResult", wxPayResult:);
}

- (void)viewWillDisappear:(BOOL)animated
{
    RemoveObserver(self, @"alipaySafepay");
    RemoveObserver(self, @"wxPayResult");
    [super viewWillDisappear:animated];
}

- (void)initChargeDeposit
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 74.0, kScreenWidth, 20.0)];
    lbl.text = @"金额";
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:lbl];
    
    //[self depositRuleButton:lbl.frame.origin.y+lbl.frame.size.height];
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 104.0, kScreenWidth, 20.0)];
    moneyLbl.text = [NSString stringWithFormat:@"%.2f元",self.defaultAmout-self.balance];
    moneyLbl.font = [UIFont boldSystemFontOfSize:16.0];
    moneyLbl.textAlignment = NSTextAlignmentCenter;
    moneyLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:moneyLbl];
    
    UILabel *deslbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 134.0, kScreenWidth, 20.0)];
    deslbl.text = [NSString stringWithFormat:@"使用苏打出行必须支付%.2f元押金，押金可退还",self.defaultAmout];
    deslbl.font = [UIFont systemFontOfSize:13];
    deslbl.textAlignment = NSTextAlignmentCenter;
    deslbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:deslbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 160.0, kScreenWidth, 1.0)];
    lineView.backgroundColor = UIColorFromRGB(200.0, 200.0, 200.0);
    [self.view addSubview:lineView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 161.0, kScreenWidth, 100.0)];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.scrollEnabled = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.frame = CGRectMake(10, kScreenHeight-10.0-40.0, kScreenWidth-20, 40);
    rechargeBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
    [rechargeBtn setTitle:NSLocalizedString(@"Recharge", nil) forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rechargeBtn.layer.cornerRadius = 4;
    rechargeBtn.layer.masksToBounds = YES;
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
    UILabel *bottomlbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, rechargeBtn.frame.origin.y-5.0-20.0, kScreenWidth, 20.0)];
    bottomlbl.text = @"苏打出行不会以任何形式要求您输入银行账户和密码";
    bottomlbl.font = [UIFont systemFontOfSize:13];
    bottomlbl.textAlignment = NSTextAlignmentCenter;
    bottomlbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomlbl];
}

- (void)initNoramlDeposit
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 104.0, kScreenWidth, 60.0)];
    lbl.text = [NSString stringWithFormat:@"已交纳押金\n%.2f元",self.balance];
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:17];
    lbl.center = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5-64.0);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:lbl];
    
    //[self depositRuleButton:lbl.frame.origin.y+lbl.frame.size.height];
    
//    UIButton *refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    refundBtn.frame = CGRectMake(10, kScreenHeight-10.0-40.0, kScreenWidth-20, 40);
//    refundBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
//    [refundBtn setTitle:NSLocalizedString(@"Refund", nil) forState:UIControlStateNormal];
//    refundBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    refundBtn.layer.cornerRadius = 4;
//    refundBtn.layer.masksToBounds = YES;
//    [refundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [refundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:refundBtn];
    
    float originY = kScreenHeight-10.0-40.0;
    NSString *string = @"苏打出行不会以任何形式要求您输入银行账户和密码";
    //需补齐押金
    if (self.defaultAmout - self.balance > 0) {
        UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rechargeButton.frame = CGRectMake(10, kScreenHeight-10.0-40.0-10.0-40.0, kScreenWidth-20, 40);
        rechargeButton.backgroundColor = UIColorFromRGB(226, 123, 105);
        [rechargeButton setTitle:NSLocalizedString(@"Recharge", nil) forState:UIControlStateNormal];
        rechargeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        rechargeButton.layer.cornerRadius = 4;
        rechargeButton.layer.masksToBounds = YES;
        [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rechargeButton];
        originY = rechargeButton.frame.origin.y;
        string = [NSString stringWithFormat:@"使用苏打出行必须支付%.2f元押金，押金可退还",self.defaultAmout];
    }
    
    UILabel *bottomlbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, originY-5.0-20.0, kScreenWidth, 20.0)];
    bottomlbl.text = string;
    bottomlbl.font = [UIFont systemFontOfSize:13];
    bottomlbl.textAlignment = NSTextAlignmentCenter;
    bottomlbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomlbl];
}

- (void)depositRuleButton:(float)originY
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, originY+10, kScreenWidth-20, 20);
    [button setTitle:@"押金协议" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
//通知事件判断支付是否成功
- (void)alipaySafepay:(NSNotification *)notif {
    
    NSDictionary *dic = notif.userInfo;
    NSLog(@"接收到来自alipay的notification=%@", dic);
    
    //    NSDictionary *memoDic = dic[@"memo"];
    NSString *status = dic[@"resultStatus"];
    //NSString *memoStr = memoDic[@"memo"];
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:memoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
    
    switch ([status integerValue]) {
            
        case AlipayCodePaySuccess: {
            
            NSLog(@"支付成功");
            
            //进入支付成功页
            [self paySuccess];
            break;
        }
        case AlipayCodePayFail: {
            
            NSLog(@"支付失败");
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"payment has not been completed", nil) message:NSLocalizedString(@"Please try later", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        }
    }
}

//微信支付返回的信息
- (void)wxPayResult:(NSNotification *)notif {
    
    NSDictionary *dic = notif.userInfo;
    NSLog(@"接收到来自WXPay的notification=%@", dic);
    
    NSNumber *status = dic[@"errCode"];
    
    switch ([status integerValue]) {
            
        case WXSuccess: {
            
            NSLog(@"支付成功");
            [self paySuccess];
            break;
        }
        case WXErrCodeCommon: {
            
            NSLog(@"支付失败");
        }
        case WXErrCodeUserCancel: {
            
            NSLog(@"用户中途取消");
        }
        default: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"payment has not been completed", nil) message:NSLocalizedString(@"Please try later", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        }
    }
}

- (void)paySuccess
{
    if (self.isPaySuccessPopToRoot) {
        [self.navigationController popViewControllerAnimated:NO];
    }else
    {
        [self showIndeterminate:@""];
        JMWeakSelf(self);
        [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlDepositStatus) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
            
            if (success) {
                
                if (JMCodeSuccess == result) {
                    [weakself hide];
                    //刷新UI
                    for (UIView *lview in self.view.subviews) {
                        [lview removeFromSuperview];
                    }
                    
                    double balance = [response[@"balance"] doubleValue];
                    double defaultAmount = [response[@"defaultAmount"] doubleValue];
                    self.isNeedCharge = defaultAmount > balance?YES:NO;
                    self.balance = balance;
                    self.defaultAmout = defaultAmount;
                    
                    [self initNoramlDeposit];
                }
                else {
                    
                    NSString *message = response[@"errMsg"];
                    message = message&&message.length?message:JMMessageNoErrMsg;
                    [weakself showError:message];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                
                [weakself showError:JMMessageNetworkError];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark - Button Action
- (void)refundAction
{
    NSString *title = @"退款须知";
    NSString *message = @"点击退款不可取消，退款到账需要30个工作日，且在此期间不能用车。";
    if (self.status == DeopositStatusFrozen) {
        title = @"友情提示";
        message = @"您的账户已被冻结，请查询明细或致电4000607927";
    }
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    if (self.status == DeopositStatusNormal) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
    }
    
    JMWeakSelf(self);
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakself.status == DeopositStatusNormal) {
            [weakself refundDeposit];
        }
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)rechargeAction
{
//    DepositViewController *vc = [[DepositViewController alloc] initWithParams:@{}];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (!self.isNeedCharge) {
        
        DepositViewController *vc = [[DepositViewController alloc] init];
        vc.isNeedCharge = YES;
        vc.balance = self.balance;
        vc.defaultAmout = self.defaultAmout;
        vc.isPaySuccessPopToRoot = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        if (currentPayType == 1) {
            [self requestAliPayOrderReq];
        }else
        {
            [self requestWXPayOrderReq];
        }
    }
}


- (void)tradeDetail
{
    TradeDetailViewController *vc = [[TradeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ruleAction
{
    
}

- (void)refundDeposit
{
    [self showIndeterminate:@""];
    JMWeakSelf(self);
    [LXRequest requestWithJsonDic:@{@"amount":@(self.balance)} andUrl:kURL(kUrlRefund) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                [weakself hide];
                [weakself.navigationController popViewControllerAnimated:NO];
                RefundStatusViewController *vc = [[RefundStatusViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
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
#pragma mark - 充值类型
//支付宝支付
- (void)requestAliPayOrderReq {
    
    [LXRequest requestWithJsonDic:@{@"amount":@(self.defaultAmout-self.balance),@"type":@1} andUrl:kURL(kUrlRealDepositReCharge) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSString *payString = response[@"pay_code"];
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
    [LXRequest requestWithJsonDic:@{@"amount":@(self.defaultAmout-self.balance),@"type":@2} andUrl:kURL(kUrlRealDepositReCharge) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSString *paydic = response[@"pay_code"];
                NSData *data = [paydic dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [WXPay pay:tempDict];
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

#pragma mark - UITableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DepositTableViewCell *cell = [DepositTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = titleImages[indexPath.row];
    cell.textLabel.text = titleNames[indexPath.row];
    if (indexPath.row == 0) {
         [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - UITableview Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"支付宝"]) {
        currentPayType = 1;
    }else if ([cell.textLabel.text isEqualToString:@"微信支付"])
    {
        currentPayType = 2;
    }
}
@end
