//
//  OfficialBillViewController.m
//  JoyMove
//
//  Created by ethen on 15/7/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OfficialBillViewController.h"
#import "BillModel.h"
#import "ThankYouViewController.h"
#import "NSString+dataFormat.h"

@interface OfficialBillViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    UIButton *_rightButton;
    UITableView *_tableView;
    UITextField *_startingPointTextField;
    UITextField *_destinationTextField;
    UITextField *_memoTextField;
    
    //data
    BillModel *_billModel;
}

@end

@implementation OfficialBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationItem];
    [self initUI];
    
    //获取订单详情
    [self requestGetOrderDetail];
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

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)initNavigationItem {
    
    self.title = @"公车出行";
    self.navigationItem.hidesBackButton = YES;
    
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:@"更新" forState:UIControlStateNormal];
    [_rightButton setTitleColor:UIColorFromRGB(100, 100, 100) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(11);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_rightButton==button) {
        
        _billModel = nil;
        [_tableView reloadData];
        
        //获取订单详情
        [self requestGetOrderDetail];
    }else {
        ;
    }
}

#pragma mark - Request

//请求订单详情
- (void)requestGetOrderDetail {
    
    NSDictionary *dic = @{@"orderId":@([OrderData orderData].orderId)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetOrderDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success)
        {
            
            if (JMCodeSuccess==result)
            {
                
                if (response)
                {
                    
                    NSInteger state = [response[@"state"] integerValue];
                    if (OrderStatusNoOrder==state) {    //已支付
                        
                        ThankYouViewController *thankYouViewController = [[ThankYouViewController alloc] init];
                        [self.navigationController pushViewController:thankYouViewController animated:YES];
                    }else { //未支付
                        
                        _billModel = [[BillModel alloc] initWithDictionary:response];
                        [_tableView reloadData];
                        [OrderData orderData].stopTime = _billModel.stopTime;
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

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section) {             //订单信息
        
        return 3;
    }else if (1 == section) {   //填写出发地
        
        return 1;
    }else if (2 == section) {   //填写目的地
        
        return 1;
    }else if (3 == section) {   //填写用车事由
        
        return 1;
    }else {                     //提交按钮
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (4==section) {
        
        return 40.f;
    }else {
        return 35.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, kScreenWidth, 20);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColorFromRGB(120, 120, 120);
    
    if (0 == section) {
        
        titleLabel.text = @"";
    }else if (1 == section) {
        
        titleLabel.text = @"   出发地";
    }else if (2 == section) {
        
        titleLabel.text = @"   目的地";
    }else if (3 == section) {
        
        titleLabel.text = @"   用车事由";
    }else {
        
        titleLabel.text = @"";
    }
    
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (4==section) {
        
        return 20.f;
    }else {
        
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    cell.imageView.image = UIImageName(@"");
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.font = UIFontFromSize(15);
    cell.detailTextLabel.textColor = UIColorFromRGB(120, 120, 120);
    
    if (!indexPath.section) {       //订单信息
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *imageName = [NSString stringWithFormat:@"billCellImage_%li", (long)indexPath.row];
        cell.imageView.image = UIImageName(imageName);
        
        if (!indexPath.row) {
            
            cell.textLabel.text = @"里程";
            
            if (_billModel.mile) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f公里", _billModel.mile];
            }else {
                
                cell.detailTextLabel.text = @"载入中...";
            }
        }else if (1 == indexPath.row) {
            
            cell.textLabel.text = @"计时";
            
            if (_billModel.stopTime) {
                
                cell.detailTextLabel.text = [NSString compareStopTime:_billModel.stopTime/1000 startTime:_billModel.startTime/1000];
            }else {
                
                cell.detailTextLabel.text = @"载入中...";
            }
        }else {
            
            cell.textLabel.text = @"金额";
            
            if (_billModel.fee) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元", _billModel.fee];
            }else {
                
                cell.detailTextLabel.text = @"载入中...";
            }
        }
    }else if (1 == indexPath.section) {     //填写出发地
        
        cell.backgroundColor = KBackgroudColor;
        if (!_startingPointTextField) {
            
            _startingPointTextField = [[UITextField alloc] init];
            _startingPointTextField.delegate = self;
            _startingPointTextField.frame = CGRectMake(10, 0, kScreenWidth-20, 40);
            _startingPointTextField.borderStyle = UITextBorderStyleRoundedRect;
            _startingPointTextField.font = UIFontFromSize(14);
            _startingPointTextField.returnKeyType = UIReturnKeyDone;
            _startingPointTextField.placeholder = @"必填";
        }
        [cell.contentView addSubview:_startingPointTextField];
        
    }else if (2 == indexPath.section) {     //填写目的地
        
        cell.backgroundColor = KBackgroudColor;
        if (!_destinationTextField) {
            
            _destinationTextField = [[UITextField alloc] init];
            _destinationTextField.delegate = self;
            _destinationTextField.frame = CGRectMake(10, 0, kScreenWidth-20, 40);
            _destinationTextField.borderStyle = UITextBorderStyleRoundedRect;
            _destinationTextField.font = UIFontFromSize(14);
            _destinationTextField.returnKeyType = UIReturnKeyDone;
            _destinationTextField.placeholder = @"必填";
        }
        [cell.contentView addSubview:_destinationTextField];
    }else if (3 == indexPath.section) {     //填写用车事由
        
        cell.backgroundColor = KBackgroudColor;
        if (!_memoTextField) {
            
            _memoTextField = [[UITextField alloc] init];
            _memoTextField.delegate = self;
            _memoTextField.frame = CGRectMake(10, 0, kScreenWidth-20, 40);
            _memoTextField.borderStyle = UITextBorderStyleRoundedRect;
            _memoTextField.font = UIFontFromSize(14);
            _memoTextField.returnKeyType = UIReturnKeyDone;
            _memoTextField.placeholder = @"必填";
        }
        [cell.contentView addSubview:_memoTextField];
    }else {     //提交按钮
        
        cell.backgroundColor = KBackgroudColor;
        
        //提现button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(10, 0, kScreenWidth-20, 40);
        button.titleLabel.font = UIFontFromSize(17);
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = UIColorFromRGB(110, 185, 167);
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_startingPointTextField resignFirstResponder];
    [_destinationTextField resignFirstResponder];
    [_memoTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
