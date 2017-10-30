//
//  CouponViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "CouponCellModel.h"
#import "WebViewController.h"

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WebViewDelegate> {
    
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UILabel *_footerLabel;
    UITextField *_addCouponText;  //添加优惠券
}
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    self.title = NSLocalizedString(@"Coupon", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self loadData];
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

    [self initTableView];
}

- (void)initTableView {

    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextFieldEdit)];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addGestureRecognizer:touchGesture];
    [self.view addSubview:_tableView];
    
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _footerLabel.text = NSLocalizedString(@"Loading...", nil);
    _footerLabel.textColor = UIColorFromRGB(200, 200, 200);
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.font = UIFontFromSize(14);
    _tableView.tableFooterView = _footerLabel;
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame = CGRectMake(0, 0, 60, 44);
    [helpButton setTitle:NSLocalizedString(@"Terms", nil) forState:UIControlStateNormal];
    helpButton.titleLabel.font = UIFontFromSize(11);
    [helpButton setTitleColor:UIColorFromRGB(100, 100, 100) forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:helpButton];
}

#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return 60+15;
    if (0 == indexPath.section) {
        
        return 70+45;
    }
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        
        return 1;
    }else {
    
        return _dataArray ? _dataArray.count : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (0 == section) {
        
        return 0;
    }else {
    
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        
        return 0;
    }else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        
        static NSString *identifier1 = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = KBackgroudColor;
        }else {
        
            for (UIView *view in cell.contentView.subviews) {
                
                [view removeFromSuperview];
            }
        }
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.frame = CGRectMake(16, 0, kScreenWidth-16, 30);
        promptLabel.textColor = UIColorFromRGB(107, 108, 108);
        promptLabel.font = [UIFont systemFontOfSize:13];
        promptLabel.text = NSLocalizedString(@"Add coupons", nil);
        [cell.contentView addSubview:promptLabel];
        
        _addCouponText = [[UITextField alloc] init];
        _addCouponText.frame = CGRectMake(16, 30, kScreenWidth-12-40-12-16, 30);
        _addCouponText.borderStyle = UITextBorderStyleRoundedRect;
        _addCouponText.backgroundColor = UIColorFromRGB(241, 240, 240);
        _addCouponText.font = [UIFont systemFontOfSize:12];
        _addCouponText.placeholder = NSLocalizedString(@"Please enter coupons NO.", nil);
        _addCouponText.delegate = self;
        _addCouponText.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:_addCouponText];
        
        UIImage *buttonImg = [UIImage imageNamed:@"addCouponButton"];
        UIButton *addCouponButton = [[UIButton alloc] init];
        addCouponButton.frame = CGRectMake(kScreenWidth-12-40, 32, 40, 26);
        [addCouponButton setBackgroundImage:buttonImg forState:UIControlStateNormal];
        [addCouponButton setTitle:NSLocalizedString(@"Activate", nil) forState:UIControlStateNormal];
        addCouponButton.titleLabel.font = [UIFont systemFontOfSize:12];
        addCouponButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [addCouponButton setTitleColor:UIColorFromRGB(225, 58, 98) forState:UIControlStateNormal];
        [addCouponButton addTarget:self action:@selector(addCouponButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addCouponButton];
        
        //可用优惠券标题
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 70, kScreenWidth, 45);
        [cell.contentView addSubview:view];
        
        //第一条灰线
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, 0, kScreenWidth, 1);
        line1.backgroundColor = UIColorFromRGB(180, 181, 181);
        [view addSubview:line1];
        
        //title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(13, 1, kScreenWidth-13, 28);
        titleLabel.text = NSLocalizedString(@"Available coupon", nil);
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = UIColorFromRGB(107, 108, 108);
        [view addSubview:titleLabel];
        
        //第二条灰线
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(13, 29, kScreenWidth-13, 1);
        line2.backgroundColor = UIColorFromRGB(180, 181, 181);
        [view addSubview:line2];
        
        return cell;
    }else{
    
        static NSString *identifier2 = @"cell2";
        CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            
            cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = KBackgroudColor;
        }
        
        CouponCellModel *cellMode = [_dataArray objectAtIndex:indexPath.row];
        cell.couponBalance = cellMode.couponBalance;
        cell.overdueTime = cellMode.overdueTime;
        cell.startTime = cellMode.startTime;
        [cell updateCellDate];
        
        return cell;
    }
    
}

#pragma mark - Action
//点击事件
- (void)helpButtonClick {
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = NSLocalizedString(@"Coupon Policy", nil);
    webViewController.delegate = self;
    [webViewController loadUrl:kURL(kE2EUrlYouHuiQuan)];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)addCouponButtonClick {

    [_addCouponText resignFirstResponder];
    [self requstForAddCoupon];
}

- (void)resignTextFieldEdit {

    [_addCouponText resignFirstResponder];
}

#pragma mark - 初始化数据
- (void)loadData {
    
    _dataArray = [[NSMutableArray alloc] init];
    [self requstForCoupon];
}

#pragma mark - requst
- (void)requstForCoupon {

    [_dataArray removeAllObjects];
    _dataArray=[_dataArray mutableCopy];
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlCoupon) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                for (NSDictionary *dic in response[@"Coupons"]) {
                    
                    CouponCellModel *cellMode = [[CouponCellModel alloc] initWithDictionary:dic];
                    [_dataArray addObject:cellMode];
                }
                _footerLabel.text = @"";
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
            
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                _footerLabel.text = [NSString stringWithFormat:@"%@",message];
            }
        }else {
        
            _footerLabel.text = JMMessageNetworkError;
        }
        [_tableView reloadData];
    }];
}

#pragma mark - InputCouponRequest

- (void)requstForAddCoupon {
    
    [self showIndeterminate:NSLocalizedString(@"Exchanging", nil)];
    [LXRequest requestWithJsonDic:@{@"code":_addCouponText.text} andUrl:kURL(kUrlExchangeCoupon) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (10000 == result) {

                [self showSuccess:NSLocalizedString(@"Exchange Success", nil)];
                [self requstForCoupon];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

@end
