//
//  TradeDetailViewController.m
//  JoyMove
//
//  Created by Soda on 2017/3/9.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeDetailTableViewCell.h"
#import "DepBillDetailViewController.h"
#import "RefundStatusViewController.h"
#import "WebViewController.h"

#import "UIViewController+Base.h"
#import "WalletViewController.h"

@interface TradeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSouce;
    UILabel *footerLabel;
    UITableView *myTableview;
}
@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //测试数据
    dataSouce = [[NSMutableArray alloc] init];
//    dataSouce = @[@{
//    @"statusString":@"退款失败",@"blanceString":@"+200",@"timeString":@"2017-03-09",@"tradeString":@"支付宝"},
//  @{@"statusString":@"退款成功",@"blanceString":@"+100",@"timeString":@"2017-03-19",@"tradeString":@"支付宝"},
//  @{@"statusString":@"退款失败",@"blanceString":@"+2300",@"timeString":@"2017-02-09",@"tradeString":@"微信"},
//  @{@"statusString":@"退款成功",@"blanceString":@"+2000",@"timeString":@"2017-01-09",@"tradeString":@"微信"},
//  @{@"statusString":@"退款失败",@"blanceString":@"+1200",@"timeString":@"2017-03-29",@"tradeString":@"支付宝"}];
    
    self.title = @"明细";
    [self setNavBackButtonStyle:BVTagBack];
    
    myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64.0) style:UITableViewStylePlain];
    myTableview.backgroundColor = KBackgroudColor;
    myTableview.delegate = self;
    myTableview.dataSource = self;
    [self.view addSubview:myTableview];
    
    UIView *footerView = [[UIView alloc] init];
    footerLabel = [[UILabel alloc] init];
    footerLabel.text=NSLocalizedString(@"No more", nil);
    footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 40);
    footerLabel.font = UIFontFromSize(12);
    footerLabel.textColor = UIColorFromRGB(200, 200, 200);
    footerLabel.backgroundColor = KBackgroudColor;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLabel];
    myTableview.tableFooterView = footerView;
    
    myTableview.rowHeight = UITableViewAutomaticDimension;
    myTableview.estimatedRowHeight = 80.0;
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    
    UIButton *rightNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    rightNavigationItemButton.frame = CGRectMake(0, 0, 84, 44);
    rightNavigationItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightNavigationItemButton setTitle:@"退款说明" forState:UIControlStateNormal];
    [rightNavigationItemButton setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    [rightNavigationItemButton addTarget:self action:@selector(refundInstuctionAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: rightNavigationItemButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
    
    [self loadData];
}

- (void)refundInstuctionAction
{
    WebViewController *webViewController = [[WebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = @"退款说明";//NSLocalizedString(@"Coupon Policy", nil);
    [webViewController isDepositPush];
    JMWeakSelf(self);
    webViewController.dismissCompleteBlock = ^(){
        NSArray *temArray = weakself.navigationController.viewControllers;
        
        for(UIViewController *temVC in temArray)
        {
            if ([temVC isKindOfClass:[WalletViewController class]])
            {
                [weakself.navigationController popToViewController:temVC animated:NO];
            }
        }
    };
    //webViewController.delegate = self;
    [webViewController loadUrl:kE2EUrlYaJinShuoMing];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)loadData
{
    //数据请求
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlDepositDetail) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            if (JMCodeSuccess == result)
            {
                [dataSouce addObjectsFromArray:response[@"records"]];
                if (dataSouce.count == 0) {
                    footerLabel.text = NSLocalizedString(@"No more", nil);
                }
            }
            else if (JMCodeNoData == result) {
                
                footerLabel.text = NSLocalizedString(@"No more", nil);
            }else {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                footerLabel.text = message;
            }
        }else {
            
            footerLabel.text = JMMessageNetworkError;
        }
        
        [myTableview reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSouce.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = KBackgroudColor;
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeDetailTableViewCell *cell = [TradeDetailTableViewCell cellWithTableView:tableView];
    TradeModel *model = [TradeModel groupWithDict:dataSouce[indexPath.section]];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TradeDetailTableViewCell class]]) {
        NSDictionary *dict = dataSouce[indexPath.section];
        if ([dict[@"type"] integerValue] == 2 ||
            [dict[@"type"] integerValue] == 4)
        {
            RefundStatusViewController *vc = [[RefundStatusViewController alloc] init];
            NSString *detailString = dict[@"detail"];
            if (![detailString isEqual:[NSNull null]]) {
                NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                vc.tradeID = tempDict[@"refundId"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            DepBillDetailViewController *vc = [[DepBillDetailViewController alloc] init];
            vc.params = dataSouce[indexPath.section];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == myTableview)    {
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }   
    }
}
@end
