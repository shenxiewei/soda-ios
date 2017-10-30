//
//  ReportViewController.m
//  JoyMove
//
//  Created by ethen on 15/3/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UIButton *_rightButton;
    UITableView *_tableView;
    
    //data
    NSArray *_sectionTitles;
    NSArray *_titles0;
    NSArray *_titles1;
    NSInteger _selectedIndexForSection0;
    NSInteger _selectedIndexForSection1;
}

@end

@implementation ReportViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)initNavigationItem {
    
    self.title = @"故障申报";
    [self setNavBackButtonStyle:BVTagBack];
    
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [_rightButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    _rightButton.titleLabel.font = UIFontFromSize(14);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

- (void)initData {
    
    _sectionTitles = @[@"车辆故障", @"车辆出险"];
    _titles0 = @[@"人为操作不当", @"车辆本身无法正常行驶", @"特殊天气(下雨,涉水等)"];
    _titles1 = @[@"单方出险", @"双方出险"];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_rightButton==button) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"故障申报成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
        ;
    }
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section) {
        
        return _titles0.count;
    }else if (1 == section) {
        
        return _titles1.count;
    }else {
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return _sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = UIFontFromSize(14);
    }
    
    BOOL isSelected;
    if (!indexPath.section) {
        
        isSelected = (indexPath.row==_selectedIndexForSection0);
        cell.textLabel.text = _titles0[indexPath.row];
    }else {
        
        isSelected = (indexPath.row==_selectedIndexForSection1);
        cell.textLabel.text = _titles1[indexPath.row];
    }
    
    cell.imageView.image = isSelected ? UIImageName(@"check_sel") : UIImageName(@"check_nor");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.section) {
        
        _selectedIndexForSection0 = indexPath.row;
    }else {
        
        _selectedIndexForSection1 = indexPath.row;
    }
    
    [_tableView reloadData];
}

@end
