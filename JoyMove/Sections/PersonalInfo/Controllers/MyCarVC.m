//
//  MyCarVC.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MyCarVC.h"
#import "WebViewController.h"

#import "MyCarCell.h"
#import "MyCarLocationCell.h"

#import "MyCarTBViewModel.h"

#import "UserData.h"
#import "MyCar.h"

#import "PopPayView.h"
#import "PayViewModel.h"

#import "SVProgressHUD.h"
#import "PackagePromotionView.h"

static NSString *const MyCarCellIdentifier = @"MyCarCell2" ;

@interface MyCarVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isOpen;
}

@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) MyCarTBViewModel *myTBViewModel;

@property(nonatomic, strong) UILabel *dayLbl;

@property(nonatomic, strong) UIImageView *noImgView;
@property(nonatomic, strong) UILabel *noLbl;

@property(nonatomic, strong) UIButton *rentNextButton;

@property(nonatomic, strong)PopPayView *myPayView;
@property(nonatomic, strong)PayViewModel *myPayViewModel;

@property(nonatomic, strong)PackagePromotionView *packagePromotionView;

@end

@implementation MyCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    self.title = @"我的车辆";
    JMWeakSelf(self);
    [self customLeftNav:@"navBackButton" touchUpInsideBlock:^{
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self customRightNavWithParams:@{@"title":@"说明",@"color":UIColorFromRGB(0, 172, 238),@"font":UIFontFromSize(14)} touchUpInsideBlock:^{
        
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.view.frame = [UIScreen mainScreen].bounds;
        [webViewController setHideAgreeButton:YES];
        webViewController.title = @"使用说明";
        [webViewController loadUrl:kUrlRetalPackageUseHelpHtml];
        [weakself.navigationController pushViewController:webViewController animated:YES];
        
    }];
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    JMWeakSelf(self);
    if ([UserData share].isRentForMonth) {
        if ([MyCar shareIntance].licenseNum) {
            [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakself.view).with.insets(UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0));
            }];
            
            [self.rentNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50.0));
                make.bottom.mas_equalTo(weakself.view).with.offset(0.0);
            }];
        }else
        {
            [self.noImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakself.view);
                make.bottom.equalTo(weakself.view.mas_centerY).offset(-10.0);
            }];
            
            [self.noLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakself.view);
                make.top.equalTo(weakself.view.mas_centerY).offset(10.0);
            }];
        }
    }else
    {
        [self.packagePromotionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakself.view);
        }];
    }
}

- (void)sdc_addSubviews
{
    if ([UserData share].isRentForMonth) {
        if ([MyCar shareIntance].licenseNum) {
            [self.view addSubview:self.myTableView];
            [self.view addSubview:self.rentNextButton];
            [self.navigationController.view addSubview:self.myPayView];
        }else
        {
            [self.view addSubview:self.noImgView];
            [self.view addSubview:self.noLbl];
        }
    }else
    {
        [self.view addSubview:self.packagePromotionView];
    }
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"purchasePackageSuccess" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)sdc_bindViewModel
{
     [self.myTBViewModel.refreshDataCommand execute:nil];
    @weakify(self)
    [[self.rentNextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        self.myPayView.hidden = NO;
        [self.myPayView showAnimation];
    }];
    
    [self.myPayViewModel.paySuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.myPayView dismissAnimation];
        
        [self.myTBViewModel.refreshDataCommand execute:nil];
    }];
    
    [self.myTBViewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        
        double days = [MyCar shareIntance].expireTime-[MyCar shareIntance].serverTime;
        days =  days/1000/60/60/24;
        if (days <= 0) {
            days = 0;
        }
        NSInteger temp = ceil(days);
        self.dayLbl.text = [NSString stringWithFormat:@"剩余%ld天",(long)temp];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.myTBViewModel.desArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.myTBViewModel.desArray[section];
    if (!array) {
        return 0;
    }
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.0;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row ==0) {
        if (_isOpen) {
            return 380.0;
        }else
        {
            return 80.0;
        }
    }
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KBackgroudColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"MyCarCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(118, 118, 119);
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        
        cell.imageView.image = UIImageName(self.myTBViewModel.desImgArray[indexPath.section][indexPath.row]);
        cell.textLabel.text = self.myTBViewModel.desArray[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = self.myTBViewModel.dataArray[indexPath.section][indexPath.row];
        
        return cell;
    }else if(indexPath.section == 1)
    {
        MyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarCellIdentifier] ;
        if (!cell) {
            cell = [[MyCarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarCellIdentifier];
        }
        cell.textLabel.text = self.myTBViewModel.desArray[indexPath.section][indexPath.row];
        [cell configure:cell customObj:self.myTBViewModel.dataArray[indexPath.section][indexPath.row] indexPath:indexPath];
        return cell;
    }else
    {
        static NSString *identifier = @"MyCarCell3";
        MyCarLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MyCarLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.isOpen = _isOpen;
        cell.desLbl.text = self.myTBViewModel.desArray[indexPath.section][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 2 && indexPath.row == 0) {
//        _isOpen = !_isOpen;
//        [tableView reloadData];
//        //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

#pragma mark - layzLoad
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _myTableView.tableFooterView = footerView;
        
        UIImage *img = UIImageName(@"car_header");
        float height = kScreenWidth*img.size.height/375.0;//img.size.height*375.0/kScreenWidth;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[MyCar shareIntance].car_img_m] placeholderImage:img options:SDWebImageCacheMemoryOnly];
        [imgView addSubview:self.dayLbl];
        
        [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90.0, 32.0));
            make.bottom.mas_equalTo(imgView).with.offset(-10.0);
            make.right.mas_equalTo(imgView).with.offset(-10.0);
        }];
        
        _myTableView.tableHeaderView = imgView;
    }
    return _myTableView;
}

- (MyCarTBViewModel *)myTBViewModel
{
    if (!_myTBViewModel) {
        _myTBViewModel = [[MyCarTBViewModel alloc] init];
    }
    return _myTBViewModel;
}

- (UIImageView *)noImgView
{
    if (!_noImgView) {
        _noImgView= [[UIImageView alloc] initWithImage:UIImageName(@"no_car")];
    }
    return _noImgView;
}

- (UILabel *)dayLbl
{
    if (!_dayLbl) {
        _dayLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLbl.textColor = [UIColor whiteColor];
        _dayLbl.textAlignment = NSTextAlignmentCenter;
        _dayLbl.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        _dayLbl.layer.cornerRadius = 16.0;
        _dayLbl.layer.masksToBounds = YES;
        _dayLbl.font = UIBoldFontFromSize(15.0);
        _dayLbl.adjustsFontSizeToFitWidth = YES;
        
        double days = [MyCar shareIntance].expireTime-[MyCar shareIntance].serverTime;
        days =  days/1000/60/60/24;
        if (days <= 0) {
            days = 0;
        }
        NSInteger temp = ceil(days);
        _dayLbl.text = [NSString stringWithFormat:@"剩余%ld天",(long)temp];
        
    }
    return _dayLbl;
}

- (UILabel *)noLbl
{
    if (!_noLbl) {
        _noLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
        _noLbl.text = @"暂无车辆";
        _noLbl.textColor = UIColorFromRGB(180.0, 180.0, 180.0);
        _noLbl.textAlignment = NSTextAlignmentCenter;
        _noLbl.font = UIFontFromSize(15.0);
    }
    return _noLbl;
}

- (UIButton *)rentNextButton
{
    if (!_rentNextButton) {
        _rentNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rentNextButton.frame = CGRectMake(70.0, 50.0, kScreenWidth-140.0, 50.0);
        _rentNextButton.backgroundColor = UIColorFromRGB(233, 96, 78);
        [_rentNextButton setTitle:@"续  租" forState:UIControlStateNormal];
    }
    return _rentNextButton;
}

- (PopPayView *)myPayView
{
    if (!_myPayView) {
        _myPayView = [[PopPayView alloc] initWithViewModel:self.myPayViewModel];
        _myPayView.frame = CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight);
        _myPayView.hidden = YES;
    }
    return _myPayView;
}

- (PayViewModel *)myPayViewModel
{
    if (!_myPayViewModel) {
        _myPayViewModel = [[PayViewModel alloc] init];
    }
    return _myPayViewModel;
}

- (PackagePromotionView *)packagePromotionView
{
    if (!_packagePromotionView) {
        _packagePromotionView = [[PackagePromotionView alloc] initWithFrame:CGRectZero];
    }
    return _packagePromotionView;
}
@end
