//
//  DestinationViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "DestinationViewController.h"
#import "SearchPOIViewController.h"

@interface DestinationViewController ()<UITableViewDataSource, UITableViewDelegate, SearchPOIDelegate> {
    
    UITableView *_tableView;
    UIButton *_saveButton;
    NSMutableDictionary *_addressDic;
    NSMutableDictionary *_saveDic;
}
@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _addressDic = [[NSMutableDictionary alloc] init];
    _saveDic = [[NSMutableDictionary alloc] init];
    [self requstForGetCommonDestination];
    [self initNavigationItem];
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

#pragma mark - UI

- (void)initNavigationItem {
    
    self.title = @"常用地址";
    [self setNavBackButtonStyle:BVTagBack];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(0, 0, 44, 44);
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:UIColorFromRGB(255, 107, 108) forState:UIControlStateNormal];
    _saveButton.titleLabel.font = UIFontFromSize(14);
    [_saveButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_saveButton];
}

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_saveButton==button) {
    
        [self requstForSaveDestination];
    }else {
    
    }
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
    }
    
    SearchModel *model;
    if (!indexPath.row) {
        
        cell.textLabel.text = @"家";
        cell.tag = SPTypeAddressHome;
        model = [_addressDic objectForKey:@"home"];
    }else {
        
        cell.textLabel.text = @"公司";
        cell.tag = SPTypeAddressCompany;
        model = [_addressDic objectForKey:@"corp"];
    }
    cell.detailTextLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchPOIViewController *searchPOIViewController = [[SearchPOIViewController alloc] init];
    searchPOIViewController.delegate = self;
    if (!indexPath.row) {
        
        searchPOIViewController.type = SPTypeAddressHome;
    }else {
        
        searchPOIViewController.type = SPTypeAddressCompany;
    }
    [self.navigationController pushViewController:searchPOIViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SearchPOIViewControllerDelegate

- (void)didSelectedPOI:(SearchModel *)model type:(SearchPOIType)type {

    UITableViewCell *cell = (UITableViewCell *)[_tableView viewWithTag:type];
    cell.detailTextLabel.text = model.name;
    
    NSDictionary *dic = [model dictionary];
    if (type == SPTypeAddressHome) {
        
        [_saveDic setValue:dic forKey:@"home"];
    }else {
    
        [_saveDic setValue:dic forKey:@"corp"];
    }
}

#pragma mark - requst

- (void)requstForGetCommonDestination {

    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlGetCommonDestination) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSArray *keyArray = @[@"home",@"corp"];
                for (NSString *keyString in keyArray) {
                    
                    SearchModel *searchModel = [[SearchModel alloc]initWithDictionary:response[keyString]];
                    if (response[keyString][@"name"] != [NSNull null]) {
                        [_saveDic setValue:response[keyString] forKey:keyString];
                    }
                    [_addressDic setValue:searchModel forKey:keyString];
                }
                [_tableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

- (void)requstForSaveDestination {

    [LXRequest requestWithJsonDic:_saveDic andUrl:kURL(kUrlupdateCommonDestination) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self showSuccess:@"保存成功"];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
            
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
        
            [self showError:JMMessageNetworkError];
        }
    }];
}

@end
