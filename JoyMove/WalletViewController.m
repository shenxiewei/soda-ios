//
//  WalletViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/4/27.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "WalletViewController.h"
#import "CouponViewController.h"
#import "CreditViewController.h"
#import "InvoiceViewController.h"
#import "DepositViewController.h"
#import "DepBillDetailViewController.h"
#import "RefundStatusViewController.h"

#import "DepositData.h"

@interface WalletViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Wallet", nil);
    [self setNavBackButtonStyle:BVTagBack];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64 + 21, kScreenWidth,  kScreenHeight- 64 - 21);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [self.view addSubview:_tableView];
    
    _nameArray = @[@"Balance",@"Coupon", @"Points",@"Deposit", @"Invoice"];
    _imageArray = @[@"walletBalance",@"walletCoupon", @"walletCredit",@"walletDeposit",@"walletInvoice"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //第一行最后一行增加分割线
    if (indexPath.row == 0) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
        [cell.contentView addSubview:lineView];
    }else if (indexPath.row == 1){
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
        [cell.contentView addSubview:lineView];
    }
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    NSString *localStr = NSLocalizedString(_nameArray[indexPath.row], nil);
    cell.textLabel.text = localStr;
    cell.textLabel.textColor = UIColorFromSixteenRGB(0x272727);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"Balance" actionName:@"balanceViewController" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        
        CouponViewController *couponViewController = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:couponViewController animated:YES];
    }else if (indexPath.row == 2){
        
        CreditViewController *creditViewCotroller = [[CreditViewController alloc] init];
        [self.navigationController pushViewController:creditViewCotroller animated:YES];
    }
    else if (indexPath.row ==3)
    {
        [self checkDeposit];
    }else if (indexPath.row == 4)
    {
        InvoiceViewController *invoiceViewController = [[InvoiceViewController alloc] init];
        [self.navigationController pushViewController:invoiceViewController animated:YES];
    }
}


// 调整cell分割线
-(void)viewDidLayoutSubviews {

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

#pragma mark - 押金逻辑

- (void)checkDeposit
{
    [self showIndeterminate:@""];
    JMWeakSelf(self);
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlDepositStatus) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            
            if (JMCodeSuccess == result) {
                [weakself hide];
                [weakself depositLogic:response];
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

- (void)depositLogic:(NSDictionary *)response
{
    NSString *refundingID = response[@"refundingId"];
    NSInteger status = [response[@"state"] integerValue];
    [DepositData shareIntance].refundID = refundingID;
    //有退款记录
    if (![refundingID isEqual:[NSNull null]]) {
        RefundStatusViewController *vc = [[RefundStatusViewController alloc] init];
        vc.tradeID = refundingID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else
    {
        double balance = [response[@"balance"] doubleValue];
        double defaultAmount = [response[@"defaultAmount"] doubleValue];
        
        DepositViewController *vc = [[DepositViewController alloc] init];
        vc.isNeedCharge = balance ==0 ?YES:NO;
        vc.balance = balance;
        vc.status = (DeopositStatus)status;
        vc.defaultAmout = defaultAmount;
        [DepositData shareIntance].balance = balance;
        [DepositData shareIntance].status = (DeopositStatus)status;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
