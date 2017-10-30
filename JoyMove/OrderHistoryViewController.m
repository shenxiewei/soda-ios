//
//  OrderHistoryViewController.m
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryCell.h"

@interface OrderHistoryViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    UILabel *_footerLabel;
    
    //data
    NSArray *_dataArray;
//    NSArray *_openArray;
    BOOL isRequest;
    BOOL isEnd;
}

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //获取订单历史
    [self requestListHistoryOrder:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _footerLabel.text = NSLocalizedString(@"Loading...", nil);
    _footerLabel.textColor = UIColorFromRGB(200, 200, 200);
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.font = UIFontFromSize(14);
    _tableView.tableFooterView = _footerLabel;
}

- (void)initNavigationItem {
    
    self.title = NSLocalizedString(@"My Trips", nil);
    [self setNavBackButtonStyle:BVTagBack];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
}

//这个手势加在section的view上，这个是手势的点击事件
/*
- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    NSInteger section = tap.view.tag;
    if (section>_dataArray.count) {
        
        return;
    }
    
    if (!_openArray) {
        
        _openArray = @[];
    }
    NSMutableArray *mutableArray = [_openArray mutableCopy];
    if ([mutableArray containsObject:@(section)]) {
        
        [mutableArray removeObject:@(section)];
    }
    else {
        
        [mutableArray addObject:@(section)];
    }
    _openArray = mutableArray;
    
    //reload
    [_tableView beginUpdates];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}
 */

#pragma mark - Request

//请求历史订单
//从viewwillappear中请求的时候，startid为0,作用应该只是为了显示载入中
- (void)requestListHistoryOrder:(NSInteger)startId {
    
    if (isRequest) {
        
        return;
    }
    isRequest = YES;
    
    NSDictionary *dic = @{@"startId":@(startId)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlListHistoryOrder) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        isRequest = NO;
        if (success) {
            
            if (JMCodeSuccess==result)
            {
                if (response)
                {
                    if (!startId) {
                        
                        _dataArray = @[];
                        isEnd = NO;
                        _footerLabel.text = NSLocalizedString(@"Loading...", nil);
                    }
                    if (!IntegerFormObject(response[@"orderCount"])) {
                        
                        isEnd = YES;
                        _footerLabel.text = NSLocalizedString(@"No more information", nil);
                    }
                    
                    NSMutableArray *mutableArray = [_dataArray mutableCopy];
                    for (NSDictionary *dic in response[@"orders"]) {
                        
                        OrderHistoryModel *model = [[OrderHistoryModel alloc] initWithDictionary:dic];
                        [mutableArray addObject:model];
                    }
                    _dataArray = mutableArray;
                    [_tableView reloadData];
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
                
                _footerLabel.text = response[@"errMsg"];
            }
        }else {
            
            _footerLabel.text = JMMessageNetworkError;
        }
    }];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

//我的行程页布局，view放在section上
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
//    view.backgroundColor = KBackgroudColor;
//    
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor whiteColor];
//    [view addSubview:line];
//    if (!section) {
//        
//        line.frame = CGRectMake(24.5f, 15, 1, 30);
//    }else {
//        
//        line.frame = CGRectMake(24.5f, 0, 1, 45);
//    }
//    
//    UIImage *img = [UIImage imageNamed:@"OrderHistorySectionIcon_1"];
//    if ([_openArray containsObject:@(section)]) {
//        
//        img = [UIImage imageNamed:@"OrderHistorySectionIcon_0"];
//    }
//    else {
//        
//        img = [UIImage imageNamed:@"OrderHistorySectionIcon_1"];
//    }
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//    imageView.frame = CGRectMake(10, 7.5f, 30, 30);
//    [view addSubview:imageView];
//    
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 150, 45)];
//    dateLabel.textColor = UIColorFromRGB(52, 52, 52);
//    dateLabel.font = UIFontFromSize(15);
//    [view addSubview:dateLabel];
//    
//    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, kScreenWidth-200-10, 45)];
//    feeLabel.textColor = UIColorFromRGB(237, 127, 109);
//    feeLabel.textAlignment = NSTextAlignmentRight;
//    feeLabel.font = UIBoldFontFromSize(15);
//    [view addSubview:feeLabel];
//    
//    if (_dataArray.count>section) {
//        
//        OrderHistoryModel *model = _dataArray[section];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat: @"yyyy年M月d日"];
//        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
//        dateLabel.text = [dateFormatter stringFromDate:startDate];
//        
//        feeLabel.text = [NSString stringWithFormat:@"￥%.2f", model.fee];
//    }
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    view.tag = section;
//    view.userInteractionEnabled = YES;
//    [view addGestureRecognizer:tap];
    
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [OrderHistoryCell height];
//    return [_openArray containsObject:@(indexPath.section)]?[OrderHistoryCell height]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OrderHistoryCellIdentifier = @"OrderHistoryCellIdentifier";
    
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderHistoryCellIdentifier];
    
    if (!cell) {
        
        cell = [[OrderHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderHistoryCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [cell initUI];
    }
    
        
    if (_dataArray.count>indexPath.section) {
            
        OrderHistoryModel *model = _dataArray[indexPath.section];
//        BOOL open = [_openArray containsObject:@(indexPath.section)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: NSLocalizedString(@"yyyy/M/d", nil)];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
        cell.dateLabel.text = [dateFormatter stringFromDate:startDate];
        cell.moneyLabel.text=[NSString stringWithFormat:@"实际支付 ￥%.2f", model.payFee];
        cell.couponFeeLbl.text = [NSString stringWithFormat:@"￥-%.2f", model.couponFee];
        cell.totalFeeLbl.text = [NSString stringWithFormat:@"￥%.2f", model.fee];
        
        [cell update:model show:open];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果是已经进入这个页面了，直接return，不会再往下走了
    if (isEnd) {
        
        return;
    }
    
    //push进入页面会调用，把载入中替换成暂无更多记录
    NSInteger i = _dataArray.count-2;
    if (indexPath.section>=(i-1)) {
        
        if (_dataArray.count>indexPath.section) {
            
            OrderHistoryModel *model = [_dataArray lastObject];
            [self requestListHistoryOrder:model.orderId];
        }
    }
}
@end
