//
//  InvoiceHistoryViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/4/25.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "InvoiceHistoryViewController.h"
#import "InvoiceModel.h"

@interface InvoiceHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *invoiceArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InvoiceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Invoice records", nil);
    [self setNavBackButtonStyle:BVTagBack];
    
    [self initUI];
    [self requestInvoiceHistory];
}

- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 21, kScreenWidth, kScreenHeight- 64 - 21) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [self.view addSubview:_tableView];
    
}

- (void)requestInvoiceHistory
{
    _invoiceArray = [@[] mutableCopy];
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlInvoiceHistory) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            
            if (result == JMCodeSuccess) {
                
                NSArray *array = [[NSArray alloc] init];
                array = response[@"invoices"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
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
    
    InvoiceModel *model = [[InvoiceModel alloc] init];
    model = _invoiceArray[indexPath.row];
    
    // 时间label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth * 0.5, 47)];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textColor = UIColorFromSixteenRGB(0x272727);
    timeLabel.text = model.time;
    [cell.contentView addSubview:timeLabel];
    
    // 状态btn
    UIButton *stateBtn = [[UIButton alloc] init];
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [stateBtn setTitleColor:UIColorFromSixteenRGB(0xf87a63) forState:UIControlStateNormal];
    stateBtn.backgroundColor = [UIColor whiteColor];
    // 动态设置btn文字
    [stateBtn setTitle:model.state forState:UIControlStateNormal];
    [stateBtn.titleLabel sizeToFit];
    CGFloat btnW = stateBtn.titleLabel.width + 15;
    stateBtn.frame = CGRectMake(kScreenWidth - 10 - btnW, 15, btnW, 17);
    stateBtn.layer.cornerRadius = 8;
    stateBtn.layer.borderWidth = 0.7;
    stateBtn.layer.borderColor = UIColorFromSixteenRGB(0xf87a63).CGColor;
    stateBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:stateBtn];
    
    // 金钱
    CGFloat X = CGRectGetMaxX(timeLabel.frame);
    CGFloat width = kScreenWidth - X - stateBtn.width - 16 - 10;
    UILabel *totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(X, 0, width, 47)];
    totalMoney.font = [UIFont systemFontOfSize:15];
    totalMoney.adjustsFontSizeToFitWidth = YES;
    totalMoney.textColor = UIColorFromSixteenRGB(0x272727);
    totalMoney.textAlignment = NSTextAlignmentRight;
    totalMoney.text = [NSString stringWithFormat:@"￥%.2f", model.count];
    [cell.contentView addSubview:totalMoney];
    
    return cell;
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
