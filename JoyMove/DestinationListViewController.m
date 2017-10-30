//
//  DestinationListViewController.m
//  JoyMove
//
//  Created by ethen on 15/4/13.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "DestinationListViewController.h"
#import "SearchPOIViewController.h"
#import "LXRequest.h"
#import "RecommendRoadViewController.h"

@interface DestinationListViewController ()<UITableViewDataSource, UITableViewDelegate, SearchPOIDelegate, UIActionSheetDelegate, RouteDelegate> {
    
    UITableView *_tableView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UISwitch *_switch;
    
    NSArray *_poiArray;
}
@end

@implementation DestinationListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self initUI];
    [self initNavigationItem];
    
    [self requestCheckOrderStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - UI

- (void)initNavigationItem {

    self.title = NSLocalizedString(@"Destinations", nil);
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -15;
    
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"navBackButton"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setImage:[UIImage imageNamed:@"addDestination"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
}

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (_leftButton==button) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Will you discard the changes？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"give up", nil) otherButtonTitles:nil];
        [sheet showInView:self.navigationController.view];
    }else if (_rightButton==button) {
        
        SearchPOIViewController *searchPOIViewController = [[SearchPOIViewController alloc] init];
        searchPOIViewController.delegate = self;
        searchPOIViewController.type = SPTypeNavi;
        [self.navigationController pushViewController:searchPOIViewController animated:YES];
    }else {
        
        _tableView.editing = !_tableView.editing;

        NSString *title = _tableView.editing?NSLocalizedString(@"Done", nil):NSLocalizedString(@"List", nil);
        UIColor *color = _tableView.editing?kThemeColor:UIColorFromRGB(120, 120, 120);
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)changeSwitchValue:(UISwitch *)swit {
    
    if (_switch==swit) {
        
        ;
    }
}

#pragma mark - Request

- (void)requestCheckOrderStatus {

    NSDictionary *dic = @{};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlCheckOrderStatus) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {  //存在未完成的订单
                
                NSString *string = response[@"destination"];
                NSArray *array = (NSArray *)[LXRequest jsonToDictionary:string];
                if (array) {
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                    for (NSDictionary *dic in array) {
                        
                        SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                        [mutableArray addObject:model];
                    }
                    _poiArray = mutableArray;
                    [_tableView reloadData];
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData == result) {  //不存在未完成的订单
                
                ;
            }else {
                
                ;
            }
        }else {
            
            ;
        }
    }];
}

//no.1修改订单的目的地
- (void)requestUpdateDestination {
    
    [self showIndeterminate:@""];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:_poiArray.count];
    for (SearchModel *model in _poiArray) {
        
        NSDictionary *dic = [model dictionary];
        [mutableArray addObject:dic];
    }
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId,
                          @"destination":mutableArray};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlUpdateDestination) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                //no.2修改订单的接力棒模式
                [self requestChangeBatonMode];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//修改订单接力棒模式
- (void)requestChangeBatonMode  {
    
    [self showIndeterminate:@""];
    
    NSInteger batonMode = _switch.on ? 1 : 0;
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId,
                          @"batonMode":@(batonMode)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlChangeBatonMode) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                //no.3回调delegate并且返回上一级界面
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPOIArray:)]) {
                    
                    [self.delegate didSelectedPOIArray:_poiArray];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section) {
        
        return 0;   //待优化：当前版本不支持接力棒模式，隐藏接力棒的开关
    }else if (1==section) {
        
        return 0;   //待优化：当前版本不支持推荐路线模式，隐藏
    }else if (2==section) {
        
        return _poiArray.count?:1;
    }else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return (2==section&&_poiArray.count)?45:0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (!section) {
            
        return @"";
    }else if (1==section) {
        
        return @"";
    }else if (2==section) {
        
        return NSLocalizedString(@"目的地列表", nil);
    }else {
            
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (2==section&&_poiArray.count) {
        
        NSString *title = _tableView.editing?NSLocalizedString(@"Done", nil):NSLocalizedString(@"List", nil);
        UIColor *color = _tableView.editing?kThemeColor:UIColorFromRGB(120, 120, 120);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth, 45);
        button.backgroundColor = UIColorFromRGB(255, 255, 255);
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = UIFontFromSize(13);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return button;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    if (!indexPath.section) {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
        cell.textLabel.backgroundColor = kClearColor;
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = NSLocalizedString(@"接力模式", nil);
        if (!_switch) {
            
            _switch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-51-10, 7, 51, 31)];
            [_switch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventTouchUpInside];
            _switch.on = YES;
        }
        [cell.contentView addSubview:_switch];
        
        return cell;
    }else if (1==indexPath.section) {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
        cell.textLabel.text = NSLocalizedString(@"Recommended route", nil);
        cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
    }else if (2==indexPath.section) {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = UIFontFromSize(15);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if (_poiArray.count>(indexPath.row)) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
            
            SearchModel *model = _poiArray[indexPath.row];
            NSString *title = model.name;
            cell.textLabel.text = title;
        }else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.textLabel.textColor = UIColorFromRGB(200, 200, 200);
            cell.textLabel.text = NSLocalizedString(@"Not added destination", nil);
        }
    }else {
        
        cell.backgroundColor = kThemeColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        cell.textLabel.text = NSLocalizedString(@"Departure", nil);
        cell.textLabel.textColor = UIColorFromRGB(255, 255, 255);
        cell.textLabel.font = UIFontFromSize(18);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (1==indexPath.section) {
        
        RecommendRoadViewController *recommendRouteViewController = [[RecommendRoadViewController alloc] init];
        recommendRouteViewController.routeDelegate = self;
        [self.navigationController pushViewController:recommendRouteViewController animated:YES];
    }else if (2==indexPath.section) {
        
        if (!_poiArray.count) {
            
            SearchPOIViewController *searchPOIViewController = [[SearchPOIViewController alloc] init];
            searchPOIViewController.delegate = self;
            searchPOIViewController.type = SPTypeNavi;
            [self.navigationController pushViewController:searchPOIViewController animated:YES];
        }else {
            
            ;
        }
    }else if (3==indexPath.section) {     //"出发"
        
        if (!_poiArray.count) {
            
            [self showInfo:NSLocalizedString(@"Please add the destination", nil)];
            
            return;
        }
        
        [self requestUpdateDestination]; //提交订单目的地列表
    }else {
    
        ;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_poiArray.count) {
        
        return NO;
    }
    
    if (2==indexPath.section) {
        
        return UITableViewCellEditingStyleDelete;
    }else {
        
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_poiArray.count) {
        
        return NO;
    }
    
    return (2==indexPath.section)?YES:NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if ((sourceIndexPath.section!=2)||(destinationIndexPath.section!=2)) {
        
        [_tableView reloadData];
        return;
    }
    
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    NSMutableArray *mutableArray = [_poiArray mutableCopy];
    id object = mutableArray[fromRow];
    [mutableArray removeObjectAtIndex:fromRow];
    [mutableArray insertObject:object atIndex:toRow];
    _poiArray = mutableArray;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_poiArray.count) {
     
        return;
    }
    
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *mutableArray = [_poiArray mutableCopy];
        [mutableArray removeObjectAtIndex:row];
        _poiArray = mutableArray;
        
        if (_poiArray.count) {
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            
            _tableView.editing = NO;
            [_tableView reloadData];
        }
    }
}


#pragma mark - SearchPOIViewControllerDelegate

- (void)didSelectedPOI:(SearchModel *)model type:(SearchPOIType)type {
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_poiArray];
    [mutableArray addObject:model];
    _poiArray = mutableArray;
    
    [_tableView reloadData];
}

- (void)didSelectedRecommendedRoute:(NSArray *)array name:(NSString *)name {
    
    _poiArray = array;
    
    [_tableView reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (!buttonIndex) {
     
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
