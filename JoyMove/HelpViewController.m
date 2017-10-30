//
//  HelpViewController.m
//  JoyMove
//
//  Created by ethen on 15/5/26.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "WebViewController.h"
#import "PlayViewController.h"
#import "Config.h"
#import "Tool.h"

@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_urlArray;
    NSArray *_iconArray;
}
@end

enum {

    cellImageTag = 300,
    cellTextLabelTag
};

@implementation HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.baseView removeFromSuperview];
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    self.title = @"帮助";
    [self loadData];
    [self initUI];
}

- (void)initUI {
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = KBackgroudColor;
    [self.view addSubview:_tableView];
    
    NSString *string = [NSString stringWithFormat:@"客服电话：%@", serviceTelephone];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(160, 160, 160) forState:UIControlStateNormal];
    button.titleLabel.font = UIFontFromSize(14);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, kScreenWidth, 40);
    _tableView.tableFooterView = button;
    
//    if ([_tableView respondsToSelector: @selector(setSeparatorInset:)]) // 分割线留白100
//    {
//        [_tableView setSeparatorInset: UIEdgeInsetsMake(0, 90, 0, 0)];
//    }
}

- (void)loadData {
    
    _titleArray = @[@"常见问题", @"用户协议", @"平台规则", @"计费说明", @"Points policy",@"法律解读", @"违章处理"];
    _urlArray = @[kE2EUrlChangJianWenTi, kE2EUrlYongHuXieYi, kE2EUrlPingTaiGuiZe, kE2EUrlHuiYuanJiBie, kE2EUrlJiFenShuoMing,kE2EUrlFaLvJieDu, kE2EUrlWeiZhangChuLi];
     _iconArray = @[@"problems",@"userAgreement",@"platformRule",@"cashDeclare",@"vipRule",@"lawDeclare",@"problems"];
}

- (void)buttonClicked:(UIButton *)button {
    
    //拨打400电话
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1+_titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KBackgroudColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KBackgroudColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(118, 118, 119);
    }

    if (0 == indexPath.row) {
        
        cell.imageView.image = [UIImage imageNamed:@"howToWork"];
        cell.textLabel.text = @"如何使用";
    }
    else {
        
        cell.imageView.image = [UIImage imageNamed:[_iconArray objectAtIndex:indexPath.row-1]];
        cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row-1];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!indexPath.row) {   //How it works
        
        PlayViewController *playViewController = [[PlayViewController alloc] init];
        playViewController.view.frame = [UIScreen mainScreen].bounds;
        [self.navigationController pushViewController:playViewController animated:YES];
    }
    
    else if (indexPath.row==2)
    {
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.view.frame = [UIScreen mainScreen].bounds;
        [webViewController setHideAgreeButton:YES];
//        NSString *userAgreement=[Tool getCache:@"UserAgreement"];
//        if (userAgreement.length>0)
//        {
//            webViewController.title = _titleArray[indexPath.row-1];
//            [webViewController loadUrl:userAgreement];
//            [self.navigationController pushViewController:webViewController animated:YES];
//        }
//        else
//        {
            webViewController.title = _titleArray[indexPath.row-1];
            NSString *url = _urlArray[indexPath.row-1];
            [webViewController loadUrl:kURL(url)];
            [self.navigationController pushViewController:webViewController animated:YES];
//        }
    }
    
    else {
        
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.view.frame = [UIScreen mainScreen].bounds;
        [webViewController setHideAgreeButton:YES];
        webViewController.title = _titleArray[indexPath.row-1];
        NSString *url = _urlArray[indexPath.row-1];
        [webViewController loadUrl:kURL(url)];

        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

@end
