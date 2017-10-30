//
//  ReturnCarInfoVC.m
//  JoyMove
//
//  Created by Soda on 2017/9/8.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "ReturnCarInfoVC.h"
#import "AddPicTBCell.h"
#import "ReturnCarTBCell.h"

#import "OrderData.h"

#import "ReturnCellViewModel.h"
#import "SVProgressHUD.h"

static NSString *const MyCellIdentifier = @"ReturnCarTBCell" ; // `cellIdentifier` AND `NibName` HAS TO BE SAME !

@interface ReturnCarInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_defaultDetailArray;
}

@property(strong, nonatomic) UITableView *myTableView;
@property(strong, nonatomic) UIButton *commitBtn;

@property(strong, nonatomic) ReturnCellViewModel *myTBViewModel;
@end

@implementation ReturnCarInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    self.title = @"我的车辆";
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    _titleArray = @[@"",@"停车位置:",@"层数"];
    _defaultDetailArray = @[@"",@"正在定位中",@"请选择停车场层数"];

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
    
    @weakify(self)
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        [self updateInfo];
    }];
    
    [self.myTBViewModel.parkInfoSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        self.dismissCompleteBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加图片
    if (indexPath.row == 0) {
        AddPicTBCell *cell = [AddPicTBCell cellWithTableView:tableView];
        return cell;
    }else //正常
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier] ;
        if (!cell) {
            [UITableViewCell registerTable:tableView nibIdentifier:MyCellIdentifier] ;
            cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        }
        [cell configure:cell customObj:nil indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma  mark - private

- (void)updateInfo{

    AddPicTBCell *cell1 = (AddPicTBCell *)[self.myTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ReturnCarTBCell *cell2 = (ReturnCarTBCell *)[self.myTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ReturnCarTBCell *cell3 = (ReturnCarTBCell *)[self.myTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (cell1.allPhotos.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传图片" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (cell3.contentLbl.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择停车场层数" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:cell1.allPhotos.count];
    for (int i = 0; i < cell1.allPhotos.count; i++) {
        UIButton *temp = cell1.allPhotos[i];
        NSData *data = UIImageJPEGRepresentation([temp imageForState:UIControlStateNormal], .4f);
        NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [array addObject:dataStr];
    }
    
    NSDictionary *params = @{@"name":cell2.contentLbl.text,@"floor":cell3.contentLbl.text,@"carId":[OrderData orderData].carId,@"photos":array};
    [self.myTBViewModel.returnCommand execute:params];
}
#pragma mark - layzLoad
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64.0) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.estimatedRowHeight = 180.0;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, 90.0)];
        [footerView addSubview:self.commitBtn];
        _myTableView.tableFooterView = footerView;
    }
    return _myTableView;
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(70.0, 50.0, kScreenWidth-140.0, 40.0);
        _commitBtn.backgroundColor = UIColorFromRGB(233, 96, 78);//UIColorFromRGB(210, 210, 210);
        [_commitBtn setTitle:@"确认还车" forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 4.0;
        //_commitBtn.enabled = NO;
    }
    return _commitBtn;
}

- (ReturnCellViewModel *)myTBViewModel
{
    if (!_myTBViewModel) {
        _myTBViewModel = [[ReturnCellViewModel alloc] init];
    }
    return _myTBViewModel;
}
@end
