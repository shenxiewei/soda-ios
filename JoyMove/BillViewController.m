//
//  BillViewController.m
//  JoyMove
//
//  Created by ethen on 15/3/25.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BillViewController.h"
#import "BillModel.h"
#import "CouponCellModel.h"
#import "Budget.h"
#import "Alipay.h"
#import "NSString+dataFormat.h"
#import "WXPay.h"
#import "PayView.h"
#import "BillModelDetailed.h"
#import "MarkViewController.h"

typedef NS_ENUM(NSInteger, PayWayType) {
    
    PayWayTypeAlipay = 0,    /**< 支付宝 */
    PayWayTypeWxpay,         /**< 微信支付 */
    PayWayTypeCreditCard,    /**< 信用卡支付 */
};

@interface BillViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, PayViewDelegate> {
    
    //显示计费详情用到的两个数组，一个显示费用详情标题，一个显示费用
    NSMutableArray *_costArray;
    NSMutableArray *_titleArray;
    
    UIButton *_rightButton;
    UITableView *_tableView;
    PayView *_payView;
    
    //data
    //订单费用详情
    BillModelDetailed *_billModelDetailed;
    BillModel *_billModel;
    NSArray *_coupons;
    NSArray *_couponsIndexArray;
    
    //是否显示所有优惠劵(YES是显示所有)
    BOOL _showAllCoupons;
    NSInteger _payIndex;
    
    //当用户对一张优惠劵反复点击时，判断是否是选中状态
    BOOL _isClickCoupon;
    //优惠券大于一个时，只能选择一个优惠劵,用于记住上次选择的是哪个优惠劵，便于删除
//    NSInteger _deleteLastTimeCoupon;  //判断用户是否是否已经点击过优惠劵（未点击时值为-1）/**天元测试**/
    NSIndexPath *_deleteLastTimeIndexPath;
    
    // 活动优惠字符串
    UILabel *_discountLabel;
}

@end

@implementation BillViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self initUI];
    
    _isClickCoupon=NO;
    //设定初始值为-1
//    _deleteLastTimeCoupon=-1;  /**天元测试**/
    
    //获取订单详情和优惠券
    [self requestGetOrderDetail];
    [self requestCoupon];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGetOrderDetail) name:@"isPayEnd" object:nil];
    
    //通知事件判断支付是否成功
    AddObserver(@"alipaySafepay", alipaySafepay:);
    AddObserver(@"wxPayResult", wxPayResult:);
   
    // 处理链接热点或打电话 状态栏增加20导致UI错位
    AddObserver(UIApplicationWillChangeStatusBarFrameNotification, layoutControllerSubViews:);
    
    [self layoutControllerSubViews];
}

// 处理链接热点或打电话 状态栏增加20导致UI错位
- (void)layoutControllerSubViews:(NSNotification *)notification
{
    [self layoutControllerSubViews];
}

- (void)layoutControllerSubViews
{
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    if (statusBarRect.size.height == 40) {
        
        _payView.y = kScreenHeight - [PayView height] - 20;
    }else{
        
        _payView.y = kScreenHeight - [PayView height];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    RemoveObserver(self, @"isPayEnd");

    RemoveObserver(self, @"alipaySafepay");
    RemoveObserver(self, @"wxPayResult");
}

// 调整cell分割线
-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
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
            MarkViewController *markViewController = [[MarkViewController alloc] init];
            [self.navigationController pushViewController:markViewController animated:YES];
            
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
            
            //进入支付成功页
            MarkViewController *markViewController = [[MarkViewController alloc] init];
            [self.navigationController pushViewController:markViewController animated:YES];
            
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

#pragma mark - UI

- (void)initUI {

    self.view.backgroundColor = KBackgroudColor;
    
    float payViewHeight = [PayView height];
    
    //支付页面的tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-payViewHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth, 30)];
    _discountLabel.font = [UIFont systemFontOfSize:12];
    _discountLabel.adjustsFontSizeToFitWidth = YES;
    _discountLabel.textColor = UIColorFromSixteenRGB(0x868686);
    [footerView addSubview:_discountLabel];
    _tableView.tableFooterView = footerView;
    
    _payView = [[PayView alloc] initWithFrame:CGRectMake(0, kScreenHeight-payViewHeight, kScreenWidth, payViewHeight)];
    _payView.delegate = self;
    [_payView initUI];
    [self.view addSubview:_payView];
}

//导航条
- (void)initNavigationItem {
    
    self.title = NSLocalizedString(@"payment details", nil);
    self.navigationItem.hidesBackButton = YES;
    
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:NSLocalizedString(@"Update", nil) forState:UIControlStateNormal];
    [_rightButton setTitleColor:UIColorFromRGB(100, 100, 100) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(11);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_rightButton==button) {
        
        _billModel = nil;
        _coupons = nil;
        [_tableView reloadData];
        
        //获取订单详情和优惠券
        [self requestGetOrderDetail];
        [self requestCoupon];
    }else {
        
        ;
    }
}

#pragma mark - Request

- (void)getOrderDetail {
    
//    if (PayWayTypeAlipay==_payIndex) {
//        
//        [self requestPayOrderReq];
//    }else {
//        
//        [self requestPayOrderReqWx];
//    }
    [self pay];
}

//请求订单详情
- (void)requestGetOrderDetail {
    
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId)};
    
    _costArray=[[NSMutableArray alloc]init];
    _titleArray=[[NSMutableArray alloc]init];
//    [_costArray addObject:@"123"];
//    [_titleArray addObject:@"超出费用"];
//    
//    [_costArray addObject:@"312"];
//    [_titleArray addObject:@"是"];
    
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetOrderDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess==result)
            {
                if (response) {
            
                    NSInteger state = [response[@"state"] integerValue];
                    /*
                     0，无订单
                     1，租用中
                     2，等待支付
                     3，已支付完成
                     */
                    if (0==state) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order Error", nil) message:NSLocalizedString(@"No order", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else if (1==state) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Order Error", nil)  message:NSLocalizedString(@"Under rental", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else if (2==state) {
                        
                        _billModel = [[BillModel alloc] initWithDictionary:response];
                        if (_billModel.discountString) {
                            _discountLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"NOTE：", nil), _billModel.discountString];
                        }

                        NSString *feeDetails=response[@"feeDetails"];
                        
                        //判断是否显示订单金额详情
                        if (feeDetails.length>0)
                        {
                            NSData *jsonData = [feeDetails dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *err;
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&err];
                            _billModelDetailed=[[BillModelDetailed alloc] initWithDictionary:dic];
                            if (_billModelDetailed.mileageFee!=0)
                            {
                                [_costArray addObject:[NSString stringWithFormat:@"%.2f",_billModelDetailed.mileageFee]];
                                [_titleArray addObject:[NSString stringWithFormat:NSLocalizedString(@"mileage fee", nil)]];
                            }
                            if (_billModelDetailed.timeFee!=0)
                            {
                                [_costArray addObject:[NSString stringWithFormat:@"%.2f",_billModelDetailed.timeFee]];
                                [_titleArray addObject:[NSString stringWithFormat:NSLocalizedString(@"time fee", nil)]];
                            }
                            if (_billModelDetailed.dayFee!=0)
                            {
                                [_costArray addObject:[NSString stringWithFormat:@"%.2f",_billModelDetailed.dayFee]];
                                [_titleArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Daily rental", nil)]];
                            }
                            if (_billModelDetailed.nightFee!=0)
                            {
                                [_costArray addObject:[NSString stringWithFormat:@"%.2f",_billModelDetailed.nightFee]];
                                [_titleArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Night rental", nil)]];
                            }
                            if (_billModelDetailed.extendFee!=0)
                            {
                                [_costArray addObject:[NSString stringWithFormat:@"%.2f",_billModelDetailed.extendFee]];
                                [_titleArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Additional fee", nil)]];
                            }
                        }
                        
                        [_tableView reloadData];
                        [OrderData orderData].stopTime = _billModel.stopTime;
                        
                        //update payView
                        _payView.orderPrice = _billModel.fee;
                        [_payView update];
                    }else if (3==state) {
                        
                        MarkViewController *markViewController = [[MarkViewController alloc] init];
                        [self.navigationController pushViewController:markViewController animated:YES];
                    }
                    else {
                        
                        ;
                    }
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
                
                ;   //不提示error message
            }
        }else {
            
            ;   //不提示error message
        }
    }];
}

//请求优惠券数据
- (void)requestCoupon {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlCoupon) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess==result) {
                
                NSArray *coupons = response[@"Coupons"];
                NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:coupons.count];
                for (NSDictionary *dic in coupons) {
                    
                    CouponCellModel *model = [[CouponCellModel alloc] initWithDictionary:dic];
                    [mutableArray addObject:model];
                }
                _coupons = mutableArray;
                
                [_tableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData==result) {
                
                _coupons = @[];
                
                [_tableView reloadData];
            }else {
                
                ;   //不提示error message
            }
        }else {
            
            ;   //不提示error message
        }
    }];
}

//支付
- (void)pay {

    [self showIndeterminate:NSLocalizedString(@"Order verifying", nil)];
    
    NSArray *couponsId = [self selectedCouponsId];
    NSString *priceStr = [self actualPayment];
    
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId),
                          @"coupons":couponsId,
                          @"zhifubao":priceStr,
                          @"type":[NSString stringWithFormat:@"%ld",_payIndex+1]};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlPayOrderReq) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess==result) {
                
                [self hide];
                
                //优惠券抵扣后,仍有需支付金额,跳转支付宝;无需支付金额,直接进入支付成功页
                NSString *zhifubaoString = response[@"zhifubao"];
                float zhifubao = [zhifubaoString floatValue];
                if (zhifubao>0) {
                    
                    if (0 == _payIndex) {
                        
                        NSString *zhifubao_code = response[@"zhifubao_code"];
                        [[Alipay alloc] pay:zhifubao_code];
                    }else if (1 == _payIndex) {
                    
                        NSDictionary *payDic = response[@"wx_code"];
                        [WXPay pay:payDic];
                    }else {
                    
                        MarkViewController *markViewController = [[MarkViewController alloc] init];
                        [self.navigationController pushViewController:markViewController animated:YES];
                    }
                }else {
                    
                    MarkViewController *markViewController = [[MarkViewController alloc] init];
                    [self.navigationController pushViewController:markViewController animated:YES];
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeHasBeenPaid==result) {
                
                [self hide];
                
                MarkViewController *markViewController = [[MarkViewController alloc] init];
                [self.navigationController pushViewController:markViewController animated:YES];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//支付确认（支付宝）
- (void)requestPayOrderReq {
    
    [self showIndeterminate:NSLocalizedString(@"Order verifying", nil)];
    
    NSArray *couponsId = [self selectedCouponsId];
    NSString *priceStr = [self actualPayment];

    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId),
                          @"coupons":couponsId,
                          @"zhifubao":priceStr};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlPayOrderReq) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess==result) {
                
                [self hide];
                
                //优惠券抵扣后,仍有需支付金额,跳转支付宝;无需支付金额,直接进入支付成功页
                NSString *zhifubaoString = response[@"zhifubao"];
                float zhifubao = [zhifubaoString floatValue];
                if (zhifubao>0) {
                    
                    NSString *zhifubao_code = response[@"zhifubao_code"];
                    [[Alipay alloc] pay:zhifubao_code];
                }else {
                
                    ;
                }
            }else if (JMCodeHasBeenPaid==result) {
                
                [self hide];
                
                MarkViewController *markViewController = [[MarkViewController alloc] init];
                [self.navigationController pushViewController:markViewController animated:YES];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError  ];
        }
    }];
}

//微信支付
- (void)requestPayOrderReqWx {
    
    [self showIndeterminate:NSLocalizedString(@"Order verifying", nil)];
    
    NSArray *couponsId = [self selectedCouponsId];
    NSString *priceStr = [self actualPayment];
    
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId),
                          @"coupons":couponsId,
                          @"zhifubao":priceStr};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlPayOrderReq) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess==result) {
                
                [self hide];
                
                //优惠券抵扣后,仍有需支付金额,跳转支付宝;无需支付金额,直接进入支付成功页
                NSString *zhifubaoString = response[@"zhifubao"];
                float zhifubao = [zhifubaoString floatValue];
                if (zhifubao>0) {
                    
                    NSDictionary *payDic = response[@"wx_code"];
                    [WXPay pay:payDic];
                }else {

                    MarkViewController *markViewController = [[MarkViewController alloc] init];
                    [self.navigationController pushViewController:markViewController animated:YES];
                }
            }else if (JMCodeHasBeenPaid==result) {
                
                [self hide];
                
                MarkViewController *markViewController = [[MarkViewController alloc] init];
                [self.navigationController pushViewController:markViewController animated:YES];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//获取用户面部识别信息
- (void)getUserGid:(void (^)(NSString *gid))block {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlGetBioLogicalinfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        NSLog(@"======%ld",result);
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSString *gid = response[@"face_info"];
                block(gid);
            }else {
                
                NSLog(@"获取失败");
                block(@"");
            }
        }else {
            
            NSLog(@"面部识别验证失败");
            block(@"");
        }
    }];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_costArray.count>0)
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section) { //订单信息
        
        return 2;
    }else if (1 == section) {   //优惠券
        
        NSInteger couponsCount = _coupons.count?:1;
        if (_showAllCoupons) {
            
            return couponsCount+1;
        }else {
            
            return couponsCount<=2?couponsCount:3;
        }
    }else if (2 == section) { //支付方式
        
        return 2;
    }
    else if (3==section &&_costArray.count>0)
    {
        //付款明细
        return _costArray.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    if (3==section) {
//        
//        return 20.f;
//    }else {
    
        return 0.f;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textColor = UIColorFromSixteenRGB(0x7d7d7d);
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
        
            [view removeFromSuperview];
        }
    }
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1);
//    lineView.backgroundColor = [UIColor grayColor];
//    [cell addSubview:lineView];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = UIImageName(@"");
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.font = UIFontFromSize(15);
    cell.detailTextLabel.textColor = UIColorFromSixteenRGB(0x1e1e1e);
    
    if (!indexPath.section) {   //订单信息
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *imageName = [NSString stringWithFormat:@"billCellImage_%li", (long)indexPath.row];
        cell.imageView.image = UIImageName(imageName);
        
        if (!indexPath.row) {
            
            cell.textLabel.text = NSLocalizedString(@"Miles", nil);
            
            if (-1!=_billModel.mile) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@", _billModel.mile, NSLocalizedString(@"Km" , nil)];
            }else {
                
                cell.detailTextLabel.text = NSLocalizedString(@"Loading...", nil);
            }
        }else if (1 == indexPath.row) {
            
            cell.textLabel.text = NSLocalizedString(@"Time", nil);
            
            if (-1!=_billModel.stopTime) {
                
                cell.detailTextLabel.text = [NSString compareStopTime:_billModel.stopTime/1000 startTime:_billModel.startTime/1000];
            }else {
                
                cell.detailTextLabel.text = NSLocalizedString(@"Loading...", nil);
            }
        }else {
            
//            cell.textLabel.text = @"金额";
//            
//            if (-1!=_billModel.fee) {
//                
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元", _billModel.fee];
//            }else {
//                
//                cell.detailTextLabel.text = @"载入中...";
//            }
        }
    }else if (1==indexPath.section) {   //优惠券
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.font = UIFontFromSize(13);
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 75, 18.2, 14, 7.5)];
        UILabel *couponsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImg.frame) + 5, 0, 130, cell.frame.size.height)];
        couponsLabel.textColor = UIColorFromSixteenRGB(0x939393);
        couponsLabel.font = UIFontFromSize(13);
        
        
        if (!_showAllCoupons&&2==indexPath.row) {     //"显示全部优惠券"
            
            cell.textLabel.text = @"";
            arrowImg.image = [UIImage imageNamed:@"arrowImg_down"];
//            couponsLabel.text = [NSString stringWithFormat:@"显示全部%lu张优惠券", (unsigned long)_coupons.count];
            couponsLabel.text = NSLocalizedString(@"show all", nil);
            [cell.contentView addSubview:arrowImg];
            [cell.contentView addSubview:couponsLabel];
        }else if (_showAllCoupons&&_coupons.count==indexPath.row) {     //"收起"
            
            cell.textLabel.text = @"";
            arrowImg.image = [UIImage imageNamed:@"arrowImg_up"];
//            couponsLabel.text = [NSString stringWithFormat:@"只显示前%lu张优惠券", _coupons.count<=2?_coupons.count:2];
            couponsLabel.text = NSLocalizedString(@"show some", nil);
            [cell.contentView addSubview:arrowImg];
            [cell.contentView addSubview:couponsLabel];
        }else if (_coupons.count>indexPath.row) {                    //优惠券

            cell.imageView.image = UIImageName(@"billCellImage_3");
            
            CouponCellModel *model = _coupons[indexPath.row];
            /*天元测试*/
            cell.textLabel.text = [NSString stringWithFormat:@"%ld元", (long)model.couponBalance];
//             cell.textLabel.text = [NSString stringWithFormat:@"%ld元", (long)model.couponBalance];
            
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 10, 20, 20)];
            [cell.contentView addSubview:checkImageView];
            
            if ([_couponsIndexArray containsObject:indexPath]) {
                
                checkImageView.image = UIImageName(@"check_sel");
            }else {
                checkImageView.image = UIImageName(@"check_nor");
            }
        }else if (!_coupons) {
            
            cell.textLabel.text = NSLocalizedString(@"Loading...", nil);
        }else if (!_coupons.count) {
            
            cell.textLabel.text = NSLocalizedString(@"No available coupon", nil);
        }else {
            
            ;
        }
    }else if (2==indexPath.section) {   //支付方式
        
        if (0 == indexPath.row) {
            
            cell.imageView.image = UIImageName(@"alipayLogo");
            cell.textLabel.text = NSLocalizedString(@"Alipay", nil);
        }else{
            
            cell.imageView.image = UIImageName(@"wxpayLogo");
            cell.textLabel.text = NSLocalizedString(@"WeChat Payment", nil);
        }
//        else {
//        
//            cell.imageView.image = UIImageName(@"creditCardPayLogo");
//            cell.textLabel.text = @"信用卡支付";
//        }
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 10, 20, 20)];
        [cell.contentView addSubview:checkImageView];
        
        checkImageView.image = (_payIndex==indexPath.row)?UIImageName(@"check_sel"):UIImageName(@"check_nor");
    }
    else if (3==indexPath.section &&_costArray.count>0)
    {
          //付款明细
        if (indexPath.row<_titleArray.count && indexPath.row<=_costArray.count)
        {
            cell.textLabel.text=_titleArray[indexPath.row];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"￥%@",_costArray[indexPath.row]];
            cell.detailTextLabel.textColor = UIColorFromRGB(255, 111, 104);
        }
    }
    else
    {
        //合计
        if (!indexPath.row) {
            
            cell.textLabel.text = NSLocalizedString(@"Total", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f", _billModel.fee];
            cell.detailTextLabel.textColor = UIColorFromSixteenRGB(0xfa6e6f);
            
        }
        else
        {

//            cell.textLabel.text=@"超出费用";
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%.2f", [self selectedCouponsBalance]];
//            cell.detailTextLabel.textColor = UIColorFromRGB(255, 111, 104);
//            cell.textLabel.text = @"绿币";
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%.2f", 0.f];
//            cell.detailTextLabel.textColor = UIColorFromRGB(255, 111, 104);
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!indexPath.section) {

        if (!indexPath.row) {
            
            ;
        }else if (1 == indexPath.row) {
            
            ;
        }else {
            
            ;
        }
    }else if (1 == indexPath.section) {
        
        if (!_showAllCoupons&&2==indexPath.row) {     //"显示全部优惠券"
            
            _showAllCoupons = YES;
        }else if (_showAllCoupons&&_coupons.count==indexPath.row) {     //"收起"
            
            _showAllCoupons = NO;
        }else if (_coupons.count>indexPath.row) {                    //选中优惠券/取消优惠券
            
            /****天元测试***/
//            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_couponsIndexArray];
            /*
            if (_coupons.count==1)
            {
                mutableArray = [@[indexPath] mutableCopy];
                if ([mutableArray containsObject:indexPath]) {
                    
                    [mutableArray removeObject:indexPath];
                }else {
                    
                    [mutableArray addObject:indexPath];
                }
            }
#pragma mark - 优惠券大于一个时，只能选择一个优惠劵
           else
           {
               if ([mutableArray containsObject:indexPath]) {
                   
                   [mutableArray removeObject:indexPath];
               }else {
                   if (_deleteLastTimeCoupon>-1)
                   {
                       [mutableArray removeObject:_deleteLastTimeIndexPath];
                   }
                   [mutableArray addObject:indexPath];
                   _deleteLastTimeCoupon=0;
                   _deleteLastTimeIndexPath=indexPath;
               }
           }
             */
            
            
            
            if(_deleteLastTimeIndexPath==indexPath && _isClickCoupon==YES)
            {
                _couponsIndexArray=nil;
                _isClickCoupon=NO;
            }
            else
            {
                _couponsIndexArray = @[indexPath];
                _deleteLastTimeIndexPath=indexPath;
                _isClickCoupon=YES;
            }
            
            
            //update payView
            _payView.couponPrice = [self selectedCouponsBalance];
            [_tableView reloadData];
            [_payView update];
        }else {
            
            ;
        }
        //reload
        [_tableView beginUpdates];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }else if (2 == indexPath.section) {
        
        _payIndex = indexPath.row;
        
        //reload
        [_tableView beginUpdates];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }else {
        
        ;
    }
}

#pragma mark -

//获取被用户选定的优惠券数据
- (NSArray *)selectedCoupons {
    
    NSMutableArray *mutableArray = [@[] mutableCopy];
    
    for (NSInteger i=0; i<_couponsIndexArray.count; i++) {
        
        NSIndexPath *indexPath = _couponsIndexArray[i];
        NSInteger row = indexPath.row;
        
        if (_coupons.count>row) {
            
            CouponCellModel *model = _coupons[row];
            [mutableArray addObject:model];
        }
    }
    NSArray *array = mutableArray;
    
    return array;
}

//获取被用户选定的优惠券id
- (NSArray *)selectedCouponsId {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *array = [self selectedCoupons];
    for (CouponCellModel *model in array) {
        
        NSString *couponId = [NSString stringWithFormat:@"%li", (long)model.couponId];
        [mutableArray addObject:couponId];
    }
    NSArray *arr = mutableArray;
    
    return arr;
}

//获取被用户选定的优惠券金额
- (double)selectedCouponsBalance {
    
    double couponBalance = 0;
    NSArray *array = [self selectedCoupons];
    for (CouponCellModel *model in array) {
        
        couponBalance += model.couponBalance;
    }
    
    return couponBalance;
}

//获取支付宝、微信需支付的金额(订单价格-优惠券金额)
- (NSString *)actualPayment {
    
    double balance = [self selectedCouponsBalance];
    
    NSString *feeStr = [NSString stringWithFormat:@"%.2f", _billModel.fee];
    double fee = [feeStr floatValue];
    double price = fee-balance;
    
    return [NSString stringWithFormat:@"%.2f", price];
}

#pragma mark - PayViewDelegate

- (void)payViewDidClicked {
    
    [self showIndeterminate:NSLocalizedString(@"Please wait", nil)];
    [self getOrderDetail];  //支付确认
    
    /*
    [[ISV isv] isISV:^(BOOL isRegistered) {
        
        [self hide];
        
        [self getUserGid:^(NSString *gid) {
            
            BOOL isRegisteredFace = gid.length;
            //根据生物识别的注册情况，进行处理
            if (isRegisteredFace && isRegistered) {     //声纹和脸部都已注册
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"通过你注册的声纹或脸部特征，选择一项进行身份验证。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"声纹识别", @"脸部识别", nil];
                [actionSheet showInView:self.navigationController.view];
            }else if (isRegistered) {    //只注册了声纹
                
                ISVRegisterViewController *iSVRegisterViewController = [[ISVRegisterViewController alloc] init];
                iSVRegisterViewController.delegate = self;
                iSVRegisterViewController.type = ISVTypeValidation;
                [self.navigationController pushViewController:iSVRegisterViewController animated:YES];
            }else if (isRegisteredFace) {    //只注册了脸部
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    FaceViewController *faceViewController = [[FaceViewController alloc]init];
                    faceViewController.faceVerifyDelegate = self;
                    faceViewController.faceParameter = FaceVerify;
                    [self presentViewController:faceViewController animated:YES completion:nil];
                }else {
                    
                    NSString *title = @"抱歉";
                    NSString *message = @"你的设备不支持相机功能，不能进行脸部识别。";
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }else {      //均未注册
                
                [self getOrderDetail];  //支付确认
            }
        }];
    }];
     */
}

#pragma mark - ISVValidationDelegate

//声纹识别验证成功
- (void)isvValidationSucess {

    [self getOrderDetail];  //支付确认
}

#pragma mark - FaceVerifyDelegate

- (void)isFaceVerifySuccess {
 
    [self getOrderDetail];  //支付确认
}



//- (void)isFaceVerifyFail {
//    
//    [self showPromptBox:@"脸部识别失败，请稍候重试"];
//}

- (void)pushResult:(UIViewController *)viewController {
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIActionSheet代理

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (!buttonIndex) {     //选择用声纹识别验证
//        
//        ISVRegisterViewController *iSVRegisterViewController = [[ISVRegisterViewController alloc] init];
//        iSVRegisterViewController.delegate = self;
//        iSVRegisterViewController.type = ISVTypeValidation;
//        [self.navigationController pushViewController:iSVRegisterViewController animated:YES];
//    }else if (1==buttonIndex) {      //选择用脸部识别验证
//        
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            FaceViewController *faceViewController = [[FaceViewController alloc]init];
//            faceViewController.faceVerifyDelegate = self;
//            faceViewController.faceParameter = FaceVerify;
//            [self presentViewController:faceViewController animated:YES completion:nil];
//        }else {
//            
//            NSString *title = @"抱歉";
//            NSString *message = @"你的设备不支持相机功能，不能进行脸部识别。";
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }else {
//        
//        ;
//    }
//}

@end
