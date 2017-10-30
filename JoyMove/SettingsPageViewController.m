//
//  SettingsPageViewController.m
//  JoyMove
//
//  Created by ethen on 15/5/4.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "SettingsPageViewController.h"
#import "OfflineMapViewController.h"
#import "WelcomeViewController.h"
#import "AboutUsViewController.h"
#import "WebViewController.h"
#import "PlayViewController.h"

@interface SettingsPageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *urlArray;

@end

@implementation SettingsPageViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self.baseView removeFromSuperview];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = KBackgroudColor;
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = KBackgroudColor;
    self.tableView.tableHeaderView = view;
    
    self.titleArray = @[@"Frequently Asked Questions", @"User Agreement", @"Platform Policy", @"Pice Policy", @"Points policy",@"Legal information", @"Peccancy processing"];
    self.urlArray = @[kE2EUrlChangJianWenTi, kE2EUrlYongHuXieYi, kE2EUrlPingTaiGuiZe, kE2EUrlHuiYuanJiBie, kE2EUrlJiFenShuoMing,kE2EUrlFaLvJieDu, kE2EUrlWeiZhangChuLi];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 9;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else{
        return 21;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KBackgroudColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(118, 118, 119);
    }
    
    if (!indexPath.section) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"How to use", nil);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            lineView.backgroundColor = UIColorFromRGB(201, 201, 201);
            [cell.contentView addSubview:lineView];
        }else if (indexPath.row == 8){
            cell.textLabel.text = NSLocalizedString(@"Customer service（Contact us)", nil);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenWidth, 0.5)];
            lineView.backgroundColor = UIColorFromRGB(201, 201, 201);
            [cell.contentView addSubview:lineView];
        }else {
            
            NSString *localStr = [self.titleArray objectAtIndex:indexPath.row-1];
            cell.textLabel.text = NSLocalizedString(localStr, nil);;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Welcome Page", nil);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            lineView.backgroundColor = UIColorFromRGB(201, 201, 201);
            [cell.contentView addSubview:lineView];
        }else{
            cell.textLabel.text = NSLocalizedString(@"About Us", nil);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenWidth, 0.5)];
            lineView.backgroundColor = UIColorFromRGB(201, 201, 201);
            [cell.contentView addSubview:lineView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (!indexPath.row) {   //How it works
            
            PlayViewController *playViewController = [[PlayViewController alloc] init];
            playViewController.view.frame = [UIScreen mainScreen].bounds;
            [self.navigationController pushViewController:playViewController animated:YES];
        }
//        else if (indexPath.row==2)
//        {
//            WebViewController *webViewController = [[WebViewController alloc] init];
//            webViewController.view.frame = [UIScreen mainScreen].bounds;
//            [webViewController setHideAgreeButton:YES];
//            NSString *localStr = _titleArray[indexPath.row-1];
//            webViewController.title = NSLocalizedString(localStr, nil);
//            NSString *url = _urlArray[indexPath.row-1];
//            [webViewController loadUrl:kURL(url)];
//            [self.navigationController pushViewController:webViewController animated:YES];
//        }
        else if (indexPath.row == 8){
            
            //拨打400电话
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else {
            
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.view.frame = [UIScreen mainScreen].bounds;
            [webViewController setHideAgreeButton:YES];
            
            NSString *localStr = _titleArray[indexPath.row-1];
            webViewController.title = NSLocalizedString(localStr, nil);
            
            NSString *urlStrLocal = _urlArray[indexPath.row-1];
            NSString *url = NSLocalizedString(urlStrLocal, nil);
            
            [webViewController loadUrl:kURL(url)];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            
            WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
            welcomeViewController.view.frame = [UIScreen mainScreen].bounds;
            [self presentViewController:welcomeViewController animated:YES completion:nil];
        }else{
            
            AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
        }
    }
}
@end
