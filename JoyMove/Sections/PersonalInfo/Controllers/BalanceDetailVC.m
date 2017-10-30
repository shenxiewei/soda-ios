//
//  BalanceDetailVC.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceDetailVC.h"

#import "BalanceDetailTBCell.h"
#import "BalanceDetailTBViewModel.h"

#import "MJRefresh.h"


static NSString *const MyCellIdentifier1 = @"BalanceDetailTBCell" ; // `cellIdentifier` AND `NibName` HAS TO BE SAME !

@interface BalanceDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) BalanceDetailTBViewModel *tbViewModel;

@end

@implementation BalanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"余额明细";
    
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    JMWeakSelf(self);
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view);
    }];
}

- (void)sdc_addSubviews
{
    [self.view addSubview:self.myTableView];
}

- (void)sdc_bindViewModel
{
    
    
    
    if(self.isMessage)
    {
        self.title = @"奖励消息";
        return;
    }
    
    [self.tbViewModel.refreshDataCommand execute:nil];
    @weakify(self)
    [self.tbViewModel.refreshUISubject subscribeNext:^(id x) {
        @strongify(self)
        
        [self.myTableView reloadData];
    }];
    
    [self.tbViewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.myTableView.mj_header endRefreshing];
        
        switch ([x integerValue]) {
            case SDCFooterRefresh_HasMoreData: {
                
                [self.myTableView.mj_header endRefreshing];
                [self.myTableView.mj_footer resetNoMoreData];
                [self.myTableView.mj_footer endRefreshing];
            }
                break;
            case SDCFooterRefresh_HasNoMoreData: {
                [self.myTableView.mj_header endRefreshing];
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case SDCRefreshError: {
                
                [self.myTableView.mj_footer endRefreshing];
                [self.myTableView.mj_header endRefreshing];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isMessage)
    {
        return self.dataArray.count;
    }
    return self.tbViewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier1] ;
    if (!cell) {
        [UITableViewCell registerTable:tableView nibIdentifier:MyCellIdentifier1] ;
        cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier1];
    }
    if(self.isMessage)
    {
        [cell configure:cell customObj:self.dataArray[indexPath.section] indexPath:indexPath];
    }else
    
    {
        [cell configure:cell customObj:self.tbViewModel.dataArray[indexPath.section] indexPath:indexPath];
    }
    return cell;
}


#pragma mark - layzLoad
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.estimatedRowHeight = 80.0;
        
        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        if(!self.isMessage)
        {
            @weakify(self)
            //默认【下拉刷新】
            MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self)
                [self.tbViewModel.refreshDataCommand execute:nil];
            }];
            //默认【上拉加载】
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self.tbViewModel.nextPageCommand execute:nil];
            }];
            
            footer.stateLabel.textColor = [UIColor grayColor];
            footer.stateLabel.font = [UIFont systemFontOfSize:12.0];
            [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
            
            _myTableView.mj_header = header;
            _myTableView.mj_footer = footer;
        }
    }
    return _myTableView;
}

- (BalanceDetailTBViewModel *)tbViewModel
{
    if (!_tbViewModel) {
        _tbViewModel = [[BalanceDetailTBViewModel alloc] init];
    }
    return _tbViewModel;
}
@end
