//
//  RecommendRoadViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "RecommendRoadViewController.h"
#import "RecommendCell.h"
#import "SearchModel.h"

@interface RecommendRoadViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_recommendTableView;         //列表
    NSMutableArray *_dataSource;              //模型
    NSMutableArray *_titleArray;              //标题
    NSMutableArray *_routeArray;              //路线图
    UILabel *_noteLabel;                      //加载提示label
}
@end

@implementation RecommendRoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Recommended route", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    [self initData];
    [self initRecommendTableView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestForGetRoute];
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

- (void)initRecommendTableView {

    _recommendTableView = [[UITableView alloc] init];
    _recommendTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    _recommendTableView.delegate = self;
    _recommendTableView.dataSource = self;
    _recommendTableView.backgroundColor = KBackgroudColor;
    [self.view addSubview:_recommendTableView];
    _recommendTableView.tableFooterView = [[UIView alloc] init];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KBackgroudColor;
    _noteLabel = [[UILabel alloc] init];
    _noteLabel.frame = CGRectMake(0, 120, kScreenWidth, 30);
    _noteLabel.text = NSLocalizedString(@"recommended route Loading...", nil);
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.textColor = UIColorFromRGB(142, 142, 142);
    _noteLabel.font = UIFontFromSize(17);
    [view addSubview:_noteLabel];
    _recommendTableView.backgroundView = view;
}

- (void)initData {

    _titleArray = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _routeArray = [[NSMutableArray alloc] init];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendCell *cell = [[RecommendCell alloc] init];
    cell.route = [_routeArray objectAtIndex:indexPath.row];
    return [cell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"identifier";
    
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.title = [_titleArray objectAtIndex:indexPath.row];
    cell.route = [_routeArray objectAtIndex:indexPath.row];
    [cell updateRecommendCell];
    
    return cell;
}

#pragma mark - UITabeleViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.navigationController popViewControllerAnimated:YES];
    if ([self.routeDelegate respondsToSelector:@selector(didSelectedRecommendedRoute:name:)]) {
        
        [self.routeDelegate didSelectedRecommendedRoute:[_dataSource objectAtIndex:indexPath.row] name:[_titleArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - request

- (void)requestForGetRoute {

    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlRecommendRoute) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            
            if (10000 == result) {
                
                [self dataSourceFromRequestData:response];
                _noteLabel.text = @"";
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
            
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                _noteLabel.text = message;
            }
        }else {
        
            _noteLabel.text = JMMessageNetworkError;
        }
    }];
}

//数据源
- (void)dataSourceFromRequestData:(NSDictionary *)response {

    NSArray *routeArray = response[@"route"];
    NSMutableArray *POIArray = [[NSMutableArray alloc] init];
    for (NSDictionary *cellDic in routeArray) {
        
        [_titleArray addObject:cellDic[@"name"]];
        [POIArray addObject:cellDic[@"POI"]];
    }
    for (NSArray *perPOI in POIArray) {
        
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in perPOI) {
            
            SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
            [modelArray addObject:model];
        }
        [_dataSource addObject:modelArray];
    }
    [self routeFromModel:_dataSource];
}

//从Model提取路线
- (void)routeFromModel:(NSMutableArray *)dataSource {

    for (NSArray *array in dataSource) {
        
        NSMutableString *routeString = [[NSMutableString alloc] init];
        for (int i=0; i<array.count; i++) {
            
            if (0 == i) {
                
                [routeString appendFormat:@"%@",[[array objectAtIndex:i] name]];
            }else {
                
                [routeString appendFormat:@"-->%@",[[array objectAtIndex:i] name]];
            }
        }
        [_routeArray addObject:routeString];
    }
    [_recommendTableView reloadData];
}

@end
