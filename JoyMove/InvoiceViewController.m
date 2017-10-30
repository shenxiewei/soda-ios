//
//  InvoiceViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/4/21.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "InvoiceViewController.h"
#import "InvoiceModel.h"
#import "InvoiceCell.h"
#import "IssuedInvoicingViewController.h"
#import "InvoiceHistoryViewController.h"

@interface InvoiceViewController () <UITableViewDelegate,UITableViewDataSource>{
    
    // 导航右button
    UIButton *_rightButton;
    UITableView *_tableView;
    UILabel *_totalMoney;
    UIButton *_nextButton;
    // 行程数组
    NSMutableArray *_invoiceArray;
    // 总金额
    double _moneySum;
    // 金额字符串
    NSString *_moneySumString;
    // 订单ID 数组
    NSMutableArray *_orderIDArray;
    // indexpath 数组
    NSMutableArray *_indexpathArray;
    // 发票最低限额
    double _minAmount;
    // 发票最低限额
    double _maxAmount;
    // 提示Lbael
    UILabel *_tipLabel;
    
}


@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initNavigation];
    _indexpathArray = [[NSMutableArray alloc] init];
    _orderIDArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 回调清楚数据
    [_indexpathArray removeAllObjects];
    [_orderIDArray removeAllObjects];
    _totalMoney.text = @"¥0.00";
    _moneySum = 0;
    
    [self requestInvoiceList];
}

- (void)requestInvoiceList
{
    _invoiceArray = [@[] mutableCopy];
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlInvoiceList) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {

            if (result == JMCodeSuccess) {
                
                _minAmount = kDoubleFormObject(response[@"config"][@"min"]);
                _maxAmount = kDoubleFormObject(response[@"config"][@"max"]);
                if (_minAmount > 0) {
                     _tipLabel.text = [NSString stringWithFormat:@"%@ ￥%.2f",NSLocalizedString(@"minimum amount for invoice", nil), _minAmount];
                    
//                    [_tipLabel sizeToFit];
                }else{
                    _tipLabel.text = @"";
                }
               
                
                NSArray *array = [[NSArray alloc] init];
                array = response[@"orders"];
                [_invoiceArray removeAllObjects];
                for (NSDictionary *dic in array) {
                    
                    InvoiceModel *invoiceModel = [[InvoiceModel alloc] initWithDictionary:dic];
                    [_invoiceArray addObject:invoiceModel];
                }
            }else if (result == JMCodeNeedLogin)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
        [_tableView reloadData];
    }];
    
}

- (void)initUI{
    
    UIView *nextView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 60)];
    nextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nextView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [nextView addSubview:lineView];
    
    // 按钮
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 95, 0, 95, 60)];
    _nextButton.backgroundColor = UIColorFromSixteenRGB(0xf67a62);
    [_nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_nextButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:_nextButton];
    
    // 合计
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(11.5, 14, 0, 0)];
    total.text = NSLocalizedString(@"Total：", nil);
    total.font = [UIFont systemFontOfSize:15];
    total.textColor = [UIColor blackColor];
    [total sizeToFit];
    [nextView addSubview:total];
    
    //金额合计
    _totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(total.frame), 10, 0, 0)];
    _totalMoney.font = [UIFont systemFontOfSize:21];
    _totalMoney.text = @"￥0.00";
    _totalMoney.textColor = UIColorFromSixteenRGB(0xf67a62);
    [_totalMoney sizeToFit];
    [nextView addSubview:_totalMoney];
    
    // 提示
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_totalMoney.frame), CGRectGetMaxY(_totalMoney.frame), kScreenWidth - 170, 30)];
    _tipLabel.text = @"";
    _tipLabel.font = [UIFont systemFontOfSize:11];
    _tipLabel.adjustsFontSizeToFitWidth = YES;
    _tipLabel.textColor = UIColorFromSixteenRGB(0x868686);
    [nextView addSubview:_tipLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 21, kScreenWidth, kScreenHeight- 64 - 21 - 60) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [self.view addSubview:_tableView];
}

- (void)initNavigation{
    
    self.title = NSLocalizedString(@"Invoice", nil);
    [self setNavBackButtonStyle:BVTagBack];
    
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 50, 44);
    _rightButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightButton setTitle:NSLocalizedString(@"Invoice records", nil) forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(12);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

- (void)buttonClicked:(UIButton *)button
{
    
    if (button == _nextButton) {
        if (_maxAmount != 0) {
            
            if (_moneySum >= _minAmount && _moneySum <= _maxAmount) {
                
                IssuedInvoicingViewController *viewController = [[IssuedInvoicingViewController alloc] init];
                viewController.count = _moneySumString;
                viewController.orderIds = _orderIDArray;
                __weak typeof(self) weakSelf= self;
                viewController.popViewController=^
                {
                    // 回调清除数据
                    [_indexpathArray removeAllObjects];
                    [_orderIDArray removeAllObjects];
                    _totalMoney.text = @"¥0.00";
                    _moneySum = 0;
                    [weakSelf requestInvoiceList];
                };
                [self.navigationController pushViewController:viewController animated:YES];
                
            }else if(_moneySum < _minAmount){
                
                [self showError:NSLocalizedString(@"less than the minimum amount for invoice", nil)];
            }else{
                [self showError:NSLocalizedString(@"Higher than the maximum amount for invoice" , nil)];
            }
        }else{
            if (_moneySum >= _minAmount) {
                
                IssuedInvoicingViewController *viewController = [[IssuedInvoicingViewController alloc] init];
                viewController.count = _moneySumString;
                viewController.orderIds = _orderIDArray;
                __weak typeof(self) weakSelf= self;
                viewController.popViewController=^
                {
                    // 回调清楚数据
                    [_indexpathArray removeAllObjects];
                    [_orderIDArray removeAllObjects];
                    _totalMoney.text = @"¥0.00";
                    _moneySum = 0;
                    [weakSelf requestInvoiceList];
                };
                [self.navigationController pushViewController:viewController animated:YES];
                
            }else{
                
                [self showError:NSLocalizedString(@"less than the minimum amount for invoice", nil)];
            }
        }
        
    }else{
        
        InvoiceHistoryViewController *viewController = [[InvoiceHistoryViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _invoiceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    InvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[InvoiceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //第一行最后一行增加分割线
    if (indexPath.row == 0) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
        [cell.contentView addSubview:lineView];
    }else if (indexPath.row == _invoiceArray.count - 1){
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
        [cell.contentView addSubview:lineView];
    }
    
    cell.invoiceModel = _invoiceArray[indexPath.row];
    
    // 用_indexpathArray判断选中状态
    if ([_indexpathArray containsObject:indexPath]) {
        
        cell.selectedImg.image = [UIImage imageNamed:@"invoice_sel"];
    }else{
        
        cell.selectedImg.image = [UIImage imageNamed:@"invoice_nor"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InvoiceModel *model = [[InvoiceModel alloc] init];
    model = _invoiceArray[indexPath.row];
    
    if ([_indexpathArray containsObject:indexPath]) {
        
        [_orderIDArray removeObject:model.orderId];
        _moneySum -= model.fee;
        [_indexpathArray removeObject:indexPath];
    }else{
        
        [_orderIDArray addObject: model.orderId];
        _moneySum += model.fee;
        [_indexpathArray addObject:indexPath];
    }

    _moneySumString = [NSString stringWithFormat:@"%.2f", _moneySum > 0.f ? _moneySum : 0.f];
    _totalMoney.text = [NSString stringWithFormat:@"￥%@", _moneySumString];
    [_totalMoney sizeToFit];
    [tableView reloadData];
    
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
@end
