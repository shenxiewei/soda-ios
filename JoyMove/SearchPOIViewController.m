//
//  SearchPOIViewController.m
//  JoyMove
//
//  Created by ethen on 15/3/23.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "SearchPOIViewController.h"
#import "SearchModel.h"

@interface SearchPOIViewController ()<AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    AMapSearchAPI *_search;
    UITableView *_tableView;
    UITextField *_textField;
    
    //data
    NSArray *_pois;             //本期搜索结果列表
    NSArray *_poiStory;         //搜索历史记录列表
    SearchModel *_homeModel;    //常用地址-家
    SearchModel *_corpModel;    //常用地址-公司
}

@end

@implementation SearchPOIViewController

const int poisCount         = 20;
const int poiStoryCount     = 20;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //记得替换
//    _search = [[AMapSearchAPI alloc] initWithSearchKey:mapApiKey Delegate:self];
//    _search.language = AMapSearchLanguage_zh_CN;
    
    //读取历史记录列表
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"poiStory"]) {
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"poiStory"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dic in array) {
            
            SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
            [mutableArray addObject:model];
        }
        _poiStory = mutableArray;
    }
    
    [self initNavigationItem];
    [self initUI];
    
    //导航模式下,需请求常用地址数据
    if (SPTypeNavi==self.type) {
        
        [self requestGetCommonDestination];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //[_textField becomeFirstResponder];
    
    AddObserver(UITextFieldTextDidChangeNotification, textFieldDidChange);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_textField resignFirstResponder];
    
    RemoveObserver(self, UITextFieldTextDidChangeNotification);
    
    //写入历史记录列表
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:_poiStory.count];
    for (SearchModel *model in _poiStory) {
        
        NSDictionary *dic = [model dictionary];
        [mutableArray addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"poiStory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UI

- (void)initNavigationItem {
    
    [self setNavBackButtonStyle:BVTagBack];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-88, 44)];
    titleView.backgroundColor = kClearColor;
    self.navigationItem.titleView = titleView;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(-15, 7, titleView.bounds.size.width, 30)];
    _textField.delegate = self;
    _textField.backgroundColor = kClearColor;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.placeholder = NSLocalizedString(@"Search", nil);
    _textField.font = UIFontFromSize(15);
    [titleView addSubview:_textField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    label.text = NSLocalizedString(@"Enter keyword", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = kThemeColor;
    label.font = UIFontFromSize(15);
    _textField.inputAccessoryView = label;
    label.alpha = .75f;
}

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = KBackgroudColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.view.center = CGPointMake(self.view.center.x, kScreenHeight/2-135);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.view.center = CGPointMake(self.view.center.x, kScreenHeight/2);
}

- (void)textFieldDidChange {
    
    if (_textField.text.length) {
        
        //构造AMapPlaceSearchRequest对象，配置关键字搜索参数,记得替换
//        AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
//        poiRequest.searchType = AMapSearchType_PlaceKeyword;
//        poiRequest.keywords = _textField.text;
//        poiRequest.city = @[@"beijing"];
//        poiRequest.requireExtension = YES;
//
//        //发起POI搜索
//        [_search AMapPlaceSearch: poiRequest];
    }else {
        
        _pois = @[];
        [_tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
}

#pragma mark - Request

//请求常用地址
- (void)requestGetCommonDestination {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlGetCommonDestination) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success)
        {
            if (JMCodeSuccess == result)
            {
                _homeModel = [[SearchModel alloc] initWithDictionary:response[@"home"]];
                _corpModel = [[SearchModel alloc] initWithDictionary:response[@"corp"]];
                
                [_tableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                ;
            }
        }else {
            
            ;
        }
    }];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (SPTypeNavi==self.type) {
        
        return 2;
    }else {
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (SPTypeNavi==self.type) {
        
        if (!section) {
            
            return 2;
        }else {
            
            ;
        }
    }
    
    if (_pois.count) {
        
        return _pois.count < 20 ? _pois.count : 20;
    }else {
        
        return _poiStory.count ? _poiStory.count+1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (SPTypeNavi==self.type) {
        
        if (!section) {
        
            return NSLocalizedString(@"Common address", nil);
        }else {
            
            ;
        }
    }
  
    if (_pois.count) {
     
        return NSLocalizedString(@"Search Results", nil);
    }else {
        
        return _poiStory.count ? NSLocalizedString(@"History", nil) : @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = kClearColor;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        
        [view removeFromSuperview];
    }
    
    if (SPTypeNavi==self.type) {
       
        if (!indexPath.section) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
            cell.textLabel.font = UIFontFromSize(16);
            
            SearchModel *model;
            if (!indexPath.row) {
                
                model = _homeModel;
                cell.textLabel.text = NSLocalizedString(@"Home", nil);
            }else {
                
                model = _corpModel;
                cell.textLabel.text = NSLocalizedString(@"Home", nil);
            }
            cell.detailTextLabel.text = model.name;
            
            return cell;
        }else {
            
            ;
        }
    }
    
    /* 目的地模糊查询和历史记录查询
     * 3种情况都会执行下面的代码:
     * SPTypeNavi模式下的(1==indexPath.section)
     * SPTypeAddressHome模式下的(0==indexPath.section)
     * SPTypeAddressCompany模式下的(0==indexPath.section) */
    
    if (_pois.count) {      //目的地模糊查询列表
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
        cell.textLabel.font = UIFontFromSize(16);
        cell.detailTextLabel.text = @"";
        
        if (_pois.count > indexPath.row) {
            
            SearchModel *model = _pois[indexPath.row];
            cell.textLabel.text = model.name;
        }
    }else {      //历史记录列表
        
        if (_poiStory.count > indexPath.row) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = UIColorFromRGB(52, 52, 52);
            cell.textLabel.font = UIFontFromSize(16);
            
            SearchModel *model = _poiStory[indexPath.row];
            cell.textLabel.text = model.name;
        }else {
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
            cell.textLabel.font = UIFontFromSize(14);
            
            cell.textLabel.text = NSLocalizedString(@"Clear All History", nil);
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchModel *model;
    if (SPTypeNavi==self.type) {
        
        if (!indexPath.section) {
            
            if (!indexPath.row) {
                
                model = _homeModel;
            }else {
                
                model = _corpModel;
            }
            
            if (model && model.latitude && model.longitude) {
            
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPOI:type:)]) {
                    
                    [self.delegate didSelectedPOI:model type:self.type];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            return;
        }else {
            
            ;
        }
    }

    /* 目的地模糊查询和历史记录查询
     * 3种情况都会执行下面的代码:
     * SPTypeNavi模式下的(1==indexPath.section)
     * SPTypeAddressHome模式下的(0==indexPath.section)
     * SPTypeAddressCompany模式下的(0==indexPath.section) */
    
    if (_pois.count) {      //目的地模糊查询列表

        if (_pois.count > indexPath.row) {
            
            model = _pois[indexPath.row];
            if (model) {
                
                //添加搜索历史记录
                NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_poiStory];
                
                //历史记录超出限定个数,清除最早的一条记录
                while (mutableArray.count>=poiStoryCount) {
                    
                    [mutableArray removeLastObject];
                }
                
                //将记录倒叙插入
                [mutableArray insertObject:model atIndex:0];
                _poiStory = mutableArray;
            }
        }else {
            
            return;
        }
    }else {      //历史记录列表
        
        if (_poiStory.count > indexPath.row) {

            model = _poiStory[indexPath.row];
        }else {
            
            //清空并写入历史记录列表
            _poiStory = @[];
            [[NSUserDefaults standardUserDefaults] setObject:_poiStory forKey:@"poiStory"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_tableView reloadData];
            
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPOI:type:)]) {
            
        [self.delegate didSelectedPOI:model type:self.type];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_textField resignFirstResponder];
}

#pragma mark - AMapSearchDelegate
//记得替换
/*
//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response {
    
    if (response.pois.count) {
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:response.pois.count];
        for (AMapPOI *poi in response.pois) {
            
            NSDictionary *dic = @{@"name":poi.name,
                                  @"latitude":@(poi.location.latitude),
                                  @"longitude":@(poi.location.longitude)};
            SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
            [mutableArray addObject:model];
            
            //只需导入限定个数以内的数据
            if (mutableArray.count>=poisCount) {
                
                break;
            }
        }
        _pois = mutableArray;
        [_tableView reloadData];
    }
}
*/
@end
