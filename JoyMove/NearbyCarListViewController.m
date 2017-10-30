//
//  NearbyCarListViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/6/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "NearbyCarListViewController.h"
#import "NearbyCarCell.h"
#import "ViewControllerServant.h"

enum {
    //控制展示距离：附近 全部
    ShowDistaceNearby = 10000,
    ShowDistanceLong
};

@interface NearbyCarListViewController () <UITableViewDataSource,UITableViewDelegate,NearbyCarCellDelegate>
{
    UISegmentedControl *_segment;      //分段选择器
    UITableView *_tableView;           //列表
    UILabel *_footerLabel;             //列表的footer
    NSMutableArray *_nearbyDataArray;  //数据源数组-附近车
    NSMutableArray *_allDataArray;      //数据源数组－全部
    BOOL _isRequst;                    //控制是否请求
}
@end

@implementation NearbyCarListViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (_isReturnCarFailure==YES)
    {
        [self requestForDistance:ShowDistanceLong andShowDataFromSkip:0 andShowType:_showType andSegmentTag:0];
        self.title = NSLocalizedString(@"Vehicles", nil);
    }
    else if (_isAKeyRentCarFailure==YES)
    {
        [self requestForDistance:ShowDistanceLong andShowDataFromSkip:0 andShowType:_showType andSegmentTag:0];
        self.title = NSLocalizedString(@"Vehicles", nil);
    }
    else
    {
        [self requestForDistance:ShowDistaceNearby andShowDataFromSkip:0 andShowType:_showType andSegmentTag:0];
        self.title = NSLocalizedString(@"Near", nil);
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setNavBackButtonStyle:BVTagBack];
    _isRequst = YES;
    _nearbyDataArray = [@[] mutableCopy];
    _allDataArray = [@[] mutableCopy];
    
    [self initUI];
}

#pragma mark - UITabeleView定义

- (void)initUI {
    
    //分段选择器
//    _segment = [[UISegmentedControl alloc] initWithItems:@[@"附近",@"全部"]];
//    _segment.frame = CGRectMake((kScreenWidth-153)/2, 7, 153, 30);
//    if (_isReturnCarFailure==YES)
//    {
//        _segment.selectedSegmentIndex = 1;
//    }
//    else
//    {
//        _segment.selectedSegmentIndex = 0;
//    }
//    _segment.tintColor = kThemeColor;
//    _segment.backgroundColor = [UIColor whiteColor];
//    [_segment addTarget:self action:@selector(selectShowCarsData) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = _segment;
    
    
    //列表
//    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor=KBackgroudColor;
    _tableView.tableHeaderView=headView;
    
    //UItableView——footerView
    UIView *footerView = [[UIView alloc] init];
    _footerLabel = [[UILabel alloc] init];
    _footerLabel.text=NSLocalizedString(@"No more", nil);
    _footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 40);
    _footerLabel.font = UIFontFromSize(12);
    _footerLabel.textColor = UIColorFromRGB(200, 200, 200);
    _footerLabel.backgroundColor = KBackgroudColor;
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:_footerLabel];
    _tableView.tableFooterView = footerView;
    
}

#pragma mark - Action
//分段选择器触发事件
- (void)selectShowCarsData {

    [_nearbyDataArray removeAllObjects];
    [_allDataArray removeAllObjects];
    [_tableView reloadData];
    if (0 == _segment.selectedSegmentIndex) {
        
        [self requestForDistance:ShowDistaceNearby andShowDataFromSkip:0 andShowType:_showType andSegmentTag:_segment.selectedSegmentIndex];
    }else {
    
        [self requestForDistance:ShowDistanceLong andShowDataFromSkip:0 andShowType:_showType andSegmentTag:_segment.selectedSegmentIndex];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (0 == _segment.selectedSegmentIndex) {
    
       return _nearbyDataArray ? _nearbyDataArray.count : 0;
//    }else {
//    
//        return _allDataArray ? _allDataArray.count : 0;
//    }
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, kScreenWidth, 30);
//    label.font = UIFontFromSize(14);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithRed:0.525f green:0.525f blue:0.533f alpha:1.00f];
//    if (ShowTypeCars == _showType) {
//        
//        if (0 == _segment.selectedSegmentIndex) {
//            
//           label.text = @"附近可用车辆";
//        }else {
//        
//            label.text = @"全部可用车辆";
//        }
//    }else if (ShowTypePowerbars == _showType) {
//        
//        if (0 == _segment.selectedSegmentIndex) {
//            
//            label.text = @"附近可用充电桩";
//        }else {
//            
//            label.text = @"全部可用充电桩";
//        }
//    }else {
//        
//        if (0 == _segment.selectedSegmentIndex) {
//            
//            label.text = @"附近可用停车场";
//        }else {
//            
//            label.text = @"全部可用停车场";
//        }
//    }
//    [view addSubview:label];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    NearbyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[NearbyCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.nearbyCarCellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array;
//    if (0 == _segment.selectedSegmentIndex) {
//        
        array = _nearbyDataArray;
//    }else {
//        
//        array = _allDataArray;
//    }
    
    POIModel *poiModel = [array objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.index = indexPath.row;
    [cell updateCellWithModel:poiModel andUserLocationCoor:self.userLocationCoor];
    
    return cell;
}

//当将要展示最后一个cell时，发送请求
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    /* 后台bug，会重复显示。暂时禁用
    NSArray *array;
    if (0 == _segment.selectedSegmentIndex) {
        
        array = _nearbyDataArray;
    }else {
        
        array = _allDataArray;
    }
    
    if (array.count == indexPath.row+1 && _isRequst) {
    
        _footerLabel.text = @"加载中...";
        if (0 == _segment.selectedSegmentIndex) {
            
            [self requestForDistance:ShowDistaceNearby andShowDataFromSkip:array.count andShowType:_showType andSegmentTag:_segment.selectedSegmentIndex];
        }else {
            
            [self requestForDistance:ShowDistanceLong andShowDataFromSkip:array.count andShowType:_showType andSegmentTag:_segment.selectedSegmentIndex];
        }
    }
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self didClickCeckButton:indexPath.row];
}

#pragma mark - requst
//数据请求
- (void)requestForDistance:(NSInteger)distance andShowDataFromSkip:(NSInteger)skip andShowType:(ShowType)showType andSegmentTag:(NSInteger)tag {

    //_footerLabel.text = @"加载中...";
    float userLatitude  = self.userLocationCoor.latitude;
    float userLongitude = self.userLocationCoor.longitude;
    NSDictionary *dic;
    if (ShowDistaceNearby == distance) {
        
        dic = @{@"userLatitude":@(userLatitude),
                @"userLongitude":@(userLongitude),
                @"scope":@(1000),
                @"skip":@(skip)};
    }else if (ShowDistanceLong == distance) {
    
        dic = @{@"userLatitude":@(userLatitude),
                @"userLongitude":@(userLongitude),
                @"scope":@(10000000000),
                @"skip":@(skip)};
    }else {
    
        ;
    }
    
    //url->附近车、充电桩或事停车场(这里目前只显示附近的车)
    NSString *url;
    if (ShowTypeCars == showType) {
        
        url = kE2EUrlGetNearByAvailableCars;
    }else if (ShowTypePowerbars == showType) {
    
        url = kUrlGetNearByPowerBars;
    }else {
    
        url = kUrlGetNearByParks;
    }

    //数据请求
    [LXRequest requestWithJsonDic:dic andUrl:kURL(url) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            _isRequst = NO;
            NSMutableArray *dataArray = [@[] mutableCopy];;
            if (JMCodeSuccess == result)
            {
                //临时数组存储附近车、充电桩或是停车场
                NSArray *array;
                if (ShowTypeCars == showType) {
                    
                    array = response[@"cars"];
                }else if (ShowTypePowerbars == showType) {
                    
                    array = response[@"powerbars"];
                }else {
                
                    array = response[@"parks"];
                }
                
                if (0 == array.count) {
                    
                    _footerLabel.text = NSLocalizedString(@"No more", nil);
                }else {
                    
                    for (NSDictionary *dic in array) {
                        
                        POIModel *poiModel = [[POIModel alloc] initWithDictionary:dic];
                        [dataArray addObject:poiModel];
                    }
                    
                    if (0 == [dic[@"skip"] integerValue]) {
                        
                        _nearbyDataArray = [@[] mutableCopy];
                        _allDataArray = [@[] mutableCopy];
                    }
                    
                    if (0 == tag) {
                        
                        //防止网速慢引起的数据错
                        [_nearbyDataArray addObjectsFromArray:dataArray];
                    }else {
                    
                        [_allDataArray addObjectsFromArray:dataArray];
                    }
                    
                    _isRequst = YES;
                }

            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData == result) {
            
                _footerLabel.text = NSLocalizedString(@"No more", nil);
            }else {
            
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                _footerLabel.text = message;
            }
        }else {
        
            _footerLabel.text = JMMessageNetworkError;
        }
        
        [_tableView reloadData];
    }];
}

#pragma  mark - nearbyCarCell代理
//向上级页面传递数据
- (void)didClickCeckButton:(NSInteger)index {
    
    NSArray *array;
    if (0 == _segment.selectedSegmentIndex) {
        
        array = _nearbyDataArray;
    }else {
    
        array = _allDataArray;
    }
    
    if (array.count > index) {
        
        POIModel *poiModel = [array objectAtIndex:index];
        [self.nearbyCarDelegate didSelectNearbyCar:poiModel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
