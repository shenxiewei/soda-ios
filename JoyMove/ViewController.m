//
//  ViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerDefine.h"
#import "RefundStatusViewController.h"
#import "DepositViewController.h"

#import "TopBannerView.h"
#import "TopBannerViewModel.h"

#import "HintRentView.h"
#import "HintRentViewModel.h"

#import "MyCar.h"
#import "SDWebImageManager.h"

#import "SDCSegmentedcontrol.h"

#import "MainShareView.h"
#import "MainShareViewModel.h"

#import "IndicatorLoadingView.h"
#import "NavTitleView.h"

typedef NS_ENUM(NSInteger, VCAlertTag) {
    
    VCAlertTagLocationAuthorization = 100,
    VCAlertTagNavigationWizard,
    VCAlertTagMapAllocError,
    VCAlertTagBlueToothDisconnect = 10000,
    
};

typedef NS_ENUM(NSInteger, VCSheetTag) {
    
    VCSheetTagDrivingToolMore = 100,
    VCSheetTagNavigationMore,
    VCSheetTagDrivingToolMorePetrol,
};

@interface ViewController ()kViewControllerDelegate {
    
    Central         *_central;                                 //蓝牙模块
    Location        *_location;                                //开启高德导航后，高德获取用户位置的接口失效，开启它不停获取用户位置
    LocationEngine  *_footLocationEngine;                      //步行导航引擎
    BillViewController *_billViewController;                   //订单页
    
    //view
    UIButton        *_leftButton;
    UIButton        *_rightButton;
    //UIImageView     *_titleImageView;
    UIImageView     *_searchImageView;
    UITextField     *_textField;
    UIButton        *_locationButton;
    UIButton        *_howToUseButton;
    UIImageView     *_focusImageView;
    //启动页
    UIImageView     *_startPage;
    //一键用车按钮
    //    UIButton        *_AKeyRentCarButton;
    
    MAPinAnnotationView     *_userPinAnnotationView;           //用户位置的图钉（可即时获取用户位置的朝向，更新图钉的角度）
    LateralSpreadsView      *_lateralSpreadsView;              //侧滑
    CarDetailsView          *_carDetailsView;                  //车辆详情栏（底部）
    DrivingNavigationView   *_drivingNavigationView;           //行车信息栏（navigationBar下方的横幅）
    DrivingToolView         *_drivingToolView;                 //行车工具栏（底部）
    NavigationTipView       *_navigationTipView;               //行车提示栏（顶部，显示XXX到了）
    
    //map
    MAMapView               *_mapView;
    AMapNaviWalkManager         *_naviManager;
    AMapNaviWalkView  *_naviViewController;
    
    //data
    CLLocationCoordinate2D _userLocationCoor;   //记录上次更新的用户位置
    NSArray *_group;                            //分组的数据(poiModel)
    NSArray *_cars;                             //空闲车的数据(poiModel)
    NSArray *_drivingCars;                      //驾驶中的车的数据(poiModel)
    NSArray *_stop;                             //导航目标的数据(poiModel)
    NSArray *_powerBars;                        //电桩的数据(poiModel)
    NSArray *_parks;                            //停车场的数据(poiModel)
    
    NSArray *_groupAnnotations;                 //分组图钉的数据(NavPointAnnotation)
    NSArray *_carsAnnotations;                  //空闲车图钉的数据(NavPointAnnotation)
    NSArray *_drivingCarsAnnotations;           //驾驶中的车的图钉的数据(NavPointAnnotation)
    NSArray *_stopAnnotations;                  //导航目标图钉的数据(NavPointAnnotation)
    NSArray *_powerBarAnnotations;              //电桩图钉的数据(NavPointAnnotation)
    NSArray *_parksAnnotations;                 //停车场图钉的数据(NavPointAnnotation)
    
    POIModel    *_targetPOI;                    //当前选定的图钉数据
    MAPolyline  *_polyline;                     //当前选定目标的步行导航
    
    NSMutableDictionary *_carIconDic;           //保存图标大头针
    
    //lock
    BOOL _isEnterBackground;        //接收app delegate的广播,记录app当前在前台还是后台
    BOOL _needFly;                  //mapView创建（或退出导航界面mapView被重新创建）首次更新用户位置时,进行将当前用户位置置于地图中心,并缩放地图比例的动画
    BOOL _workingForNaviManager;    //开启步行导航-->绘制线路之间的锁,避免重复发起相同业务
    BOOL _workingForCar;
    BOOL _workingForGroup;
    BOOL _workingForFence;
    BOOL _isShowCar;                //YES:当前需展示车的图钉；NO:当前需展示分组的图钉
    BOOL _isOpenSpeechSynthesizer;
    BOOL _notUpdateOrderStatus;     //不在下次viewWillAppear时重新请求订单状态
    BOOL _notDeselectAnnotation;                        //通过点击附近车列表跳转，不要执行didDeselectAnnotationView:后续的代码，直接return
    BOOL _isRentCar;                //BOOL值为YES，表明在租用中
    BOOL _isStartPush;              //判断用户是否开启定位
    BOOL _isCityCodeFirst;          //是否开启程序走完第一次定位
    
    //心跳timer
    NSTimer *_ackHeartbeatTimer;            //轮询租车后的ack
    NSTimer *_requestPinHeartbeatTimer;    //轮询图钉所需的数据
    
    PromptView *_promptView;               //租车还车提示信息
    
    PromptView *_promptFailureView;        //还车失败提示信息
    
    PromptView *_promptAKeyFailureView;    //一键还车失败view
    
    //一键还车按钮的view
    AKeyRentCarButtonView *_aKeyRentCarButtonView;
    
    //活动页面
    ActivityView *_activityView;
    
    //添加点击手势:当从附近的车或者一键还车选中的大头针，让用户再点击其他地方收起底端view
    UITapGestureRecognizer *_hideBottomViewTap;
    
    //添加推送提示
    UIAlertView *_pushAlert;
    //版本号
    UIAlertView *_versionNumber;
    //使用蓝牙开门
    UIAlertView *_isBluetoothOpen;
    //使用蓝牙锁门
    UIAlertView *_isBluetoothClose;
    //使用蓝牙闪灯
    UIAlertView *_isBluetoothFlash;
    // 更新
    UIAlertView *_isVersionUpdate;
    // 更新URL
    NSString *_updateUrl;
    
    //记得替换
    //添加反地里编码
    AMapSearchAPI *_searchCity;
    //添加进入地图后反地理编码
    AMapSearchAPI *_searchMapCity;
    
    //是否是电车
    NSInteger _isTramCar;
}


@property (strong, nonatomic)UIButton *bannerBtn;
@property (strong, nonatomic)TopBannerView *topBannerView;
@property (strong, nonatomic)TopBannerViewModel *topBannerViewModel;
@property (strong, nonatomic)UIButton *coinShareBtn;

@property (strong, nonatomic)HintRentView *hintRentView;
@property (strong, nonatomic)HintRentViewModel *hintRentViewModel;

@property (strong, nonatomic)SDCSegmentedcontrol *segmentedControl;

@property (strong, nonatomic) UIView *navTitleView;

@property (strong, nonatomic) UIView *mainRentView;
@property (strong, nonatomic) MainShareView *mainShareView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //配置启动页
    [self loadStartPage];
    
    _carIconDic=[[NSMutableDictionary alloc]init];
    
    
    _central = [[Central alloc] init];
    _central.delegate = self;
    
    [self.view addSubview:self.mainRentView];
    [self.view addSubview:self.mainShareView];
    //创建导航栏
    [self initNavigationItem];
    [self initUI];
    
    //未显示过欢迎页面时:进入欢迎页面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeWelcome"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeWelcome"];
        [NSUserDefaults standardUserDefaults];
        
        [self welcome];
    }
    
    // 信用卡通知
    //    AddObserver(@"guideCertification",      presentCreditCardView);
    AddObserver(@"presentDriverLicence",    presentDriverLicence);
    AddObserver(@"orderStatusDidChange",    orderStatusDidChange:);
    AddObserver(@"reloadMap",               reloadMap);
    AddObserver(@"unlock",                  unlockWithWatch);
    AddObserver(@"lock",                    lockWithWatch);
    AddObserver(@"pingCar",                 pingWithWatch);
    
    //设置推送的初始值
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstallationAPP"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstInstallationAPP"];
        [NSUserDefaults standardUserDefaults];
        
        _isStartPush=YES;
    }
    
    [self blindViewModel];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    JMWeakSelf(self);
    
    //    [self.topBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        float scale = kScreenWidth/375.0;
    //
    //        make.size.mas_equalTo(CGSizeMake(345*scale, 82.0*scale));
    //
    //        make.top.equalTo(weakself.view).with.offset(15+64.0);
    //        make.centerX.equalTo(weakself.view);
    //    }];
    //
    //    [self.coinShareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(37.0 ,70.0));
    //        make.top.equalTo(weakself.topBannerView.mas_bottom).with.offset(-5.0);
    //        make.right.equalTo(weakself.view).with.offset(-20.0);
    //    }];
    
    //    [self.hintRentView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(@40.0);
    //        make.left.equalTo(weakself.mainRentView).with.offset(0);
    //        make.right.equalTo(weakself.mainRentView).with.offset(0);
    //        make.bottom.equalTo(weakself.mainRentView).with.offset(0);
    //    }];
    
    if (!kIphone5) {
        [self.navTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-108.0, 44));
        }];
    }
    
    [self.segmentedControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@32.0);
        make.width.mas_equalTo(@170.0);
        make.centerX.centerY.equalTo(weakself.segmentedControl.superview);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    //    [self.navigationController.view.window addSubview:_lateralSpreadsView];
    //每次将订单状态置为未知,然后重新拉取状态
    if (!_notUpdateOrderStatus) {
        
        [OrderData orderData].state = OrderStatusUnknown;
        [self orderStatusChanged];
        
        [self requestCheckOrderStatus]; //订单状态查询
    }
    
    self.bannerBtn.hidden = YES;
    self.topBannerView.hidden = YES;
    self.coinShareBtn.hidden = YES;
    
    [self requestUserPackageCheck];
    
    _notUpdateOrderStatus = NO;
    
    [self updateAnnotations];   //重载mapView上的图钉(刷新用户头像)
    
    AddObserver(@"applicationEnterBackgroundOrForeground", applicationEnterBackgroundOrForeground:);
    
    // 处理链接热点或打电话 状态栏增加20导致UI错位
    AddObserver(UIApplicationWillChangeStatusBarFrameNotification, layoutControllerSubViews:);
    
    [self.mainShareView removeAllChildren];
    [self.mainShareView reloadData];
    
    [self layoutControllerSubViews];
}

// 处理链接热点或打电话 状态栏增加20导致UI错位
- (void)layoutControllerSubViews:(NSNotification *)notification
{
    [self layoutControllerSubViews];
}

- (void)layoutControllerSubViews
{
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    if (statusBarRect.size.height == 40) {
        _carDetailsView.isMoreUp = YES;
        
        if (_drivingToolView.isShow) {
            _drivingToolView.y =  kScreenHeight - _drivingToolView.height - 20;
        }
    }else{
        _carDetailsView.isMoreUp = NO;
        
        if (_drivingToolView.isShow) {
            _drivingToolView.y =  kScreenHeight - _drivingToolView.height;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navTitleView.hidden = NO;
    self.navTitleView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.navTitleView.alpha = 1.0;
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self requestPin];
    [_requestPinHeartbeatTimer invalidate];
    _requestPinHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:poiHeartbeatDelay target:self selector:@selector(requestPin) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(authorizationStatus) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(checkMapAppearBecomeWatchStartFirst) withObject:nil afterDelay:3.f];
    [self performSelector:@selector(isAllowedNotification) withObject:nil afterDelay:1.5];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navTitleView.hidden = YES;
    RemoveObserver(self, @"applicationEnterBackgroundOrForeground");
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [_requestPinHeartbeatTimer invalidate];
}

#pragma mark - blind viewmodel
- (void)blindViewModel
{
    @weakify(self)
    [self.topBannerViewModel.tapSubject subscribeNext:^(id x) {
        @strongify(self)
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MyCar" actionName:@"myCarViewController" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.topBannerViewModel.shareCarSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        self.coinShareBtn.hidden = NO;
    }];
    
    [self.topBannerViewModel.unShareCarSuccessSubject subscribeNext:^(id x) {
        @strongify(self)
        self.coinShareBtn.hidden = YES;
    }];
    
    [self.hintRentViewModel.tapSubject subscribeNext:^(id x) {
        @strongify(self);
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MyCar" actionName:@"myCarViewController" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"purchasePackageSuccess" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.segmentedControl.selectedIndex = 0;
        [self SDCSegmentControlClickedIndex:0];
    }];
}
#pragma mark - UI
//加载启动页
-(void)loadStartPage
{
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    _startPage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _startPage.contentMode=UIViewContentModeScaleAspectFill;
    if (imageFromWeb)
    {
        [_startPage setImage:imageFromWeb];
    }
    else
    {
        if (kIphone4)
        {
            _startPage.image=[UIImage imageNamed:@"startImage4"];
        }
        else if (kIphone5)
        {
            _startPage.image=[UIImage imageNamed:@"startImage5"];
        }
        else if (kIphone6)
        {
            _startPage.image=[UIImage imageNamed:@"startImage6"];
        }
        else
        {
            _startPage.image=[UIImage imageNamed:@"startImage6p"];
        }
    }
    
    [self appearStartPage];
    [self.navigationController.view.window addSubview:_startPage];
}

//添加活动弹出页面
-(void)pushActivityView:(NSString *)cityCode
{
    if (!_activityView && [OrderData orderData].state ==OrderStatusNoOrder)
    {
        _activityView=[[ActivityView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
        [_activityView requestActivityImage:cityCode];
        __block ViewController *blockSelf = self;
        _activityView.pushLoginViewController=^
        {
            [blockSelf createNoNetWorkViewWithReloadBlock:^{
                
            }];
        };
        _activityView.CloseActivityButtonClick=^
        {
            [blockSelf->_activityView removeFromSuperview];
        };
        _activityView.pushActivityController=^
        {
            
            if ([_activityView.detailsTitle isEqualToString:@"即享"]) {
                [blockSelf->_activityView removeFromSuperview];
                blockSelf.segmentedControl.selectedIndex = 1;
                [blockSelf SDCSegmentControlClickedIndex:1];
            }else{
                WebViewController *webViewController=[[WebViewController alloc]init];
                webViewController.view.frame = [UIScreen mainScreen].bounds;
                [webViewController setHideAgreeButton:YES];
                [webViewController getImageURL:blockSelf->_activityView.imageURL];
                [webViewController isActivityPush:YES];
                webViewController.title = blockSelf->_activityView.detailsTitle;
                [webViewController loadUrl:blockSelf->_activityView.html5URL];
                [blockSelf->_activityView removeFromSuperview];
                [blockSelf.navigationController pushViewController:webViewController animated:YES];
            }
             
        };
        [self.navigationController.view addSubview:_activityView];
    }
}

//用户订单状态改变后的UI update
- (void)orderStatusChanged {
    
    //[self removeRoute]; //清除路线规划
    
    //根据订单状态的变化,切换视图的风格
    switch ([OrderData orderData].state) {
            
        case OrderStatusUnknown: {
            
            _mapView.userTrackingMode = MAUserTrackingModeNone;
            //_focusImageView.hidden = NO;
            [self showTitleView:YES];
            [_carDetailsView hide];
            //显示一键租车按钮
            [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
            [_drivingNavigationView hide];
            self.bannerBtn.hidden = [UserData share].isRentForMonth;
            [_drivingToolView hide];
            _rightButton.hidden = YES;
        }
            break;
        case OrderStatusNoOrder: {
            
            //            [self pushActivityView];
            
            _mapView.userTrackingMode = MAUserTrackingModeNone;
            //_focusImageView.hidden = NO;//
            _textField.text = @"";
            [self showTitleView:YES];
            [_carDetailsView hide];
            //显示一键租车按钮
            [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
            [_drivingNavigationView hide];
            self.bannerBtn.hidden = [UserData share].isRentForMonth;
            self.topBannerView.hidden = ![UserData share].isRentForMonth;
            [_drivingToolView hide];
            
            //清空poi中导航目标和电桩的数据
            _stop = @[];
            _powerBars = @[];
            _parks = @[];
            _drivingCars = @[];
            [_mapView removeAnnotations:_stopAnnotations];
            [_mapView removeAnnotations:_powerBarAnnotations];
            [_mapView removeAnnotations:_parksAnnotations];
            [_mapView removeAnnotations:_drivingCarsAnnotations];
            
            _rightButton.hidden = NO;
        }
            break;
        case OrderStatusRent: {
            
            _mapView.userTrackingMode = MAUserTrackingModeFollow;
            //_focusImageView.hidden = NO;
            [self showTitleView:NO];
            [_carDetailsView hide];
            //显示一键租车按钮
            [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
            [_drivingNavigationView show];
            self.bannerBtn.hidden = YES;
            [_drivingToolView show];
            [self layoutControllerSubViews];
            _howToUseButton.hidden = NO;
            //清空poi中车的数据
            _cars = @[];
            [_mapView removeAnnotations:_carsAnnotations];
            
            _rightButton.hidden = YES;
            
            self.topBannerView.hidden = YES;
            self.bannerBtn.hidden = YES;
            self.coinShareBtn.hidden = YES;
        }
            break;
            
        case OrderStatusWaitingForPayment: {
            
            if (![self.navigationController.viewControllers containsObject:_billViewController]) {
                
                _billViewController = [[BillViewController alloc] init];
                [self.navigationController pushViewController:_billViewController animated:NO];
            }
            
            _rightButton.hidden = YES;
        }
            break;
            
        case OrderStatusRequestRent: {
            
            ;
        }
            break;
            
        case OrderStatusRequestTerminate: {
            
            ;
        }
            break;
            
        default:
            break;
    }
}

//导航栏
- (void)initNavigationItem {
    
    self.title = @"";
    
    UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -10;
    
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:UIImageName(@"appLeft") forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _leftButton];
    self.navigationItem.leftBarButtonItems = @[leftSpacer, leftButtonItem];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    //    [_rightButton setImage:UIImageName(@"appRight") forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"MainNavigationRightImage"] forState:UIControlStateNormal];
    //    [_rightButton setTitle:@"附近的车" forState:UIControlStateNormal];
    
    //    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    rightSpacer.width = -25;
    
    //    [_rightButton setTitleColor:UIColorFromRGB(50, 50, 50) forState:UIControlStateNormal];
    //    _rightButton.titleLabel.font = UIFontFromSize(12);
    [_rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:_rightButton];
    //    [self setNavRightButton:_rightButton];
    //    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _rightButton];
    //    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
    
    self.navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.navTitleView.backgroundColor = kClearColor;
    self.navTitleView.contentMode=UIViewContentModeCenter;
    self.navigationItem.titleView = self.navTitleView;
    [self.navTitleView addSubview:self.segmentedControl];
    
    //self.segmentedControl.alpha = 0.0;
    // [self.navTitleView.layer insertSublayer:self.shadowLayer below:self.segmentedControl.layer];
    //    UIImage *titleImage = UIImageName(@"appTitle");
    //    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-44-64, 44)];
    //    _titleImageView.image = titleImage;
    //    _titleImageView.contentMode = UIViewContentModeCenter;
    //    [titleView addSubview:_titleImageView];
    //    _titleImageView.alpha = 0;
    
    UIImage *searchImage = UIImageName(@"navSearchBar");
    _searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5f, self.navTitleView.bounds.size.width, 29)];
    _searchImageView.image = [searchImage stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    //[self.navTitleView addSubview:_searchImageView];
    _searchImageView.alpha = 0;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, self.navTitleView.bounds.size.width-30, 30)];
    _textField.delegate = self;
    _textField.backgroundColor = kClearColor;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.placeholder = NSLocalizedString(@"Add Destination", nil);
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"查找目的地，开启导航" attributes:@{NSForegroundColorAttributeName:kThemeColor}];
    _textField.font = UIFontFromSize(13);
    //[self.navTitleView addSubview:_textField];
    _textField.alpha = 0;
}

- (void)initUI {
    
    self.view.backgroundColor = UIColorFromRGB(230, 230, 230);
    
    //地图中心的焦点
    UIImage *focusImage = UIImageName(@"POIFocus");
    _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-focusImage.size.width)/2, kScreenHeight/2-focusImage.size.height, focusImage.size.width, focusImage.size.height)];
    _focusImageView.image = focusImage;
    _focusImageView.userInteractionEnabled = NO;
    [self.mainRentView addSubview:_focusImageView];
    _focusImageView.hidden = YES;
    
    [self initMapView];
    
    // [self.mainRentView addSubview:self.hintRentView];
    
    //跳转用户当前位置的按钮
    UIImage *locationImage = [UIImage imageNamed:@"myLocation"];
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(10, kScreenHeight-130-locationImage.size.height, locationImage.size.width, locationImage.size.height);
    [_locationButton setImage:locationImage forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainRentView addSubview:_locationButton];
    
    //一键用车按钮
    _aKeyRentCarButtonView=[[AKeyRentCarButtonView alloc]initWithFrame:CGRectMake((kScreenWidth-132.0)/2, kScreenHeight-50-47.0, 132.0, 47.0)];
    [_aKeyRentCarButtonView initUI];
    [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
    __weak typeof(self) weakSelf= self;
    _aKeyRentCarButtonView.AKeyRentCarButtonClick=^
    {
        [weakSelf requestCheckNearByCar];
    };
    [self.mainRentView addSubview:_aKeyRentCarButtonView];
    //    _AKeyRentCarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    _AKeyRentCarButton.frame=CGRectMake(125.0/320*kScreenWidth, 466.0/568*kScreenHeight, kScreenWidth-250.0/320*kScreenWidth, 79.0/568*kScreenHeight);
    //    [_AKeyRentCarButton setTitle:@"用车" forState:UIControlStateNormal];
    //    [_AKeyRentCarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5.0/568*kScreenHeight, 0)];
    //    _AKeyRentCarButton.titleLabel.font=[UIFont systemFontOfSize:20];
    //    [_AKeyRentCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_AKeyRentCarButton setBackgroundImage:[UIImage imageNamed:@"AKeyRentCarButton"] forState:UIControlStateNormal];
    //    [_AKeyRentCarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_AKeyRentCarButton];
    
    //车辆如何使用
    _howToUseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _howToUseButton.frame = CGRectMake(20+locationImage.size.width, kScreenHeight-130-locationImage.size.height, 100, locationImage.size.height);
    _howToUseButton.frame = CGRectMake(279.5 / 375 * kScreenWidth, 22.5, 71.5, 34);
    [_howToUseButton setBackgroundImage:[UIImage imageNamed:@"howToUse"] forState:UIControlStateNormal];
    [_howToUseButton setTitle:NSLocalizedString(@"Description", nil) forState:UIControlStateNormal];
    _howToUseButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_howToUseButton setTitleColor:UIColorFromRGB(52, 166, 240) forState:UIControlStateNormal];
    _howToUseButton.titleLabel.font = UIFontFromSize(15);
    [_howToUseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _howToUseButton.hidden = YES;
    
    //行车信息栏
    _drivingNavigationView = [[DrivingNavigationView alloc] initWithFrame:CGRectMake(0, 64, [DrivingNavigationView size].width, [DrivingNavigationView size].height)];
    [_drivingNavigationView initUI];
    [self.mainRentView addSubview:_drivingNavigationView];
    
    //车辆详情栏
    CGSize carDetailsViewSize = [CarDetailsView size];
    _carDetailsView = [[CarDetailsView alloc] initWithFrame:CGRectMake((kScreenWidth-carDetailsViewSize.width)/2, kScreenHeight-carDetailsViewSize.height, carDetailsViewSize.width, carDetailsViewSize.height)];
    _carDetailsView.delegate = self;
    [_carDetailsView initUI];
    [_carDetailsView addSubview:_howToUseButton];
    [self.mainRentView addSubview:_carDetailsView];
    
    //行车工具栏
    _drivingToolView = [[DrivingToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight, [DrivingToolView size].width, [DrivingToolView size].height)];
    [_drivingToolView initUI];
    _drivingToolView.delegate = self;
    [self.mainRentView addSubview:_drivingToolView];
    
    //导航提示栏（驾车）
    _navigationTipView = [[NavigationTipView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _navigationTipView.delegate = self;
    _navigationTipView.viewController = self.navigationController;
    [_navigationTipView initUI];
    
    //步行距离引擎
    _footLocationEngine = [[LocationEngine alloc] init];
    
    //侧滑
    _lateralSpreadsView = [[LateralSpreadsView alloc] init];
    _lateralSpreadsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _lateralSpreadsView.delegate = self;
    [_lateralSpreadsView initUI];
    [self.navigationController.view.window addSubview:_lateralSpreadsView];
    
    
    UIView *lateralSpreadsRemnantsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 10, kScreenHeight-64)];
    lateralSpreadsRemnantsView.userInteractionEnabled = YES;
    [self.view addSubview:lateralSpreadsRemnantsView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [lateralSpreadsRemnantsView addGestureRecognizer:pan];
}

- (void)initMapView {
    
    [AMapServices sharedServices].enableHTTPS = YES;
    if (!_mapView) {
        
        _mapView = [[MAMapView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }else {
        
        [_mapView removeFromSuperview];
    }
    [self.mainRentView addSubview:_mapView];
   //[self.mainRentView insertSubview:_mapView belowSubview:_focusImageView];
    //将_focusImageView放在_mapView上，_focusImageView暂时隐藏
    
    _needFly = YES;
    
    //_mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_mapView setDelegate:self];
    
    _mapView.backgroundColor = [UIColor whiteColor];
    _mapView.logoCenter = CGPointMake(0, kScreenHeight-_mapView.logoSize.height);
    _mapView.showsCompass = NO;
    _mapView.rotateEnabled = NO;
    _mapView.distanceFilter = 10;
    _mapView.headingFilter = 5;
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES; //重写精度圈
    [self showCoordinate:CLLocationCoordinate2DMake(39.906921f, 116.397551f) delta:150.f animated:NO];
    
    //    [self showRouteWithNaviRoute:[[_naviManager naviRoute] copy]];     //画线
    
    [self requestFence:@"" mapView:_mapView];    //请求电子围栏数据并绘制
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
}

//激活离线地图
- (void)reloadMap {
    
    [_mapView reloadMap];
}

//模出欢迎页面
- (void)welcome {
    
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
    welcomeViewController.view.frame = [UIScreen mainScreen].bounds;
    welcomeViewController.loginNilBlock=^{
        
        [self loginViewControllerNil];
    };
    [self presentViewController:welcomeViewController animated:YES completion:nil];
}

//显示导航栏上的搜索框或者苏打的icon
- (void)showTitleView:(BOOL)isShow {
    [UIView animateWithDuration:.4f animations:^{
        
        //self.navTitleView.alpha = isShow;
        _searchImageView.alpha = !isShow;
       // _textField.alpha = !isShow;
    } completion:nil];
}
- (void)pushUploadParkInfo
{
    UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"ReturnCarInfo" actionName:@"returnCarInfoViewController" params:nil];
    JMWeakSelf(self);
    vc.dismissCompleteBlock = ^()
    {
        [weakself requestRentCarTerminateReq];      //请求结束订单
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//还车成功，进入订单页
- (void)pushBill {
    
    [self hide];
    
    [_ackHeartbeatTimer invalidate];    //终止心跳
    
    //结束navigationTip提醒
    [_navigationTipView stop];
    
    //进入订单详情页
    [OrderData orderData].state = OrderStatusWaitingForPayment; //手动切换状态，确保watch端数据正确
    
    _billViewController = [[BillViewController alloc] init];
    [self.navigationController pushViewController:_billViewController animated:YES];
}

//推出一键租车失败页面
-(void)pushAKeyRentCarFailureView
{
    if (!_promptAKeyFailureView)
    {
        _promptAKeyFailureView=[[PromptView alloc]initWithPromptViewStyle:AKeyRentCarFailureTag];
    }
    _promptAKeyFailureView.promptViewDelegate = self;
    [self.navigationController.view addSubview:_promptAKeyFailureView];
    [self promptViewAKeyFailureButtonClick];
    [self UrgeSiteButtonClick];
}

#pragma mark - 下载图片

-(void)getImageURL:(NSString *)imageURL
{
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    //Get Image From URL
    UIImage * imageFromURL = [self getImageFromURL:imageURL];
    
    //Save Image to Directory
    [self saveImage:imageFromURL withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    //Load Image From Directory
    UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    //    [img setImageWithURL:[NSURL URLWithString:imageURL]];
    //    img.backgroundColor=[UIColor blackColor];
    [img setImage:imageFromWeb];
    //    img.image=imageFromWeb;
    //    [self.navigationController.view addSubview:img];
    
    //取得目录下所有文件名
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
    //NSLog(@"%d",[file count]);
    NSLog(@"%@",file);
    
    //如何获取下载的文件的完整路径?
    //    NSString *documentsDirectory2 = [path2 objectAtIndex:0]; //path数组里貌似只有一个元素
    //    //字符串拼接得到文件完整路径
    //    NSString *filestr = @"/MyImage.jpg";
    //    NSString *newstr = [documentsDirectory2 stringByAppendingString:filestr];
    //    NSLog(@"完整路径是:%@",newstr);
    //
    //    NSData *dd = [NSData dataWithContentsOfFile:newstr];
    //    [img222 setImage:[UIImage imageWithData:dd]];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

#pragma mark - Action

-(NSArray *)BubbleSort:(NSArray *)originalArray
{
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 doubleValue] > [string2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 doubleValue] < [string2 doubleValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
    
    return resultArray;
}

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    
    [self performSelector:@selector(appearClosePage)
               withObject:block
               afterDelay:delay];
}


//启动页三秒淡进淡出
-(void)appearStartPage
{
    __weak typeof(self) weakSelf= self;
    [UIView animateWithDuration:0 animations:^{
        _startPage.alpha = 1;
    } completion:^(BOOL finished) {
        _startPage.hidden=NO;
        
        [weakSelf performSelector:@selector(appearClosePage) withObject:nil afterDelay:2.6f];
        
    }];
}

-(void)appearClosePage
{
    
    [UIView animateWithDuration:.4f animations:^{
        _startPage.alpha = 0;
    } completion:^(BOOL finished) {
        _startPage.hidden=YES;
    }];
}


//判断用户是否开启推送
-(void)isAllowedNotification
{
    
    //iOS8 check if user allow notification
    if (kAboveIOS8) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types)
        {
            NSLog(@"开启推送");
            _isStartPush=YES;
        }
        else
        {
            if (_isStartPush==NO)
            {
                NSLog(@"关闭推送");
                //                _pushAlert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"如果关闭定位，您将无法租用车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                //                _pushAlert.tag = 20;
                //                [_pushAlert show];
            }
            _isStartPush=NO;
        }
        
    }
    else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
        {
            NSLog(@"开启推送");
        }
        else
        {
            NSLog(@"关闭推送");
            //            _pushAlert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"如果关闭定位，您将无法租用车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            //            _pushAlert.tag = 20;
            //            [_pushAlert show];
            
        }
    }
    
    
}

//- (void)presentCreditCardView {
//
//    CreditCardViewController *creditCardViewController = [[CreditCardViewController alloc] init];
//    creditCardViewController.isPresentView = YES;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:creditCardViewController];
//    [self presentViewController:navigationController animated:YES completion:nil];
//}

- (void)presentDriverLicence {
    
    DriveViewController *driveViewController = [[DriveViewController alloc] init];
    driveViewController.isPresentView = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:driveViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)buttonClicked:(UIButton *)button {
    
    if (_leftButton == button) {
        if ([self isLogin]){
            
            if ([_lateralSpreadsView isShow]) {
                
                [_lateralSpreadsView hide];
            }else {
                
                [_lateralSpreadsView show];
            }
        }
    }else if (_rightButton == button) {
        //        BillViewController *a=[[BillViewController alloc]init];
        //        [self.navigationController pushViewController:a animated:YES];
        //push到列表页
        _notUpdateOrderStatus = YES;        //设置下次viewWillAppear时不请求order状态数据
        
        NearbyCarListViewController *nearByCarViewController = [[NearbyCarListViewController alloc] init];
        nearByCarViewController.nearbyCarDelegate = self;
        nearByCarViewController.userLocationCoor = _userLocationCoor;
        nearByCarViewController.showType = ShowTypeCars;
        [self.navigationController pushViewController:nearByCarViewController animated:YES];
        
        
    }else if (_locationButton == button) {
        
        //watch app先于iPhone启动时，app的mapView会为nil，原因未知
        if (!_mapView) {
            
            [self initMapView];
        }
        
        [self showCoordinate:_mapView.userLocation.coordinate delta:.01f animated:YES];
    }else if (_howToUseButton == button) {
        
        //租车操作向导
        if (!_promptView)
        {
            _promptView = [[PromptView alloc] initWithPromptViewStyle:RentSuccessPromptViewTag];
            _promptView.promptViewDelegate = self;
            [self.navigationController.view addSubview:_promptView];
        }
    }
    //    else if (_AKeyRentCarButton==button)
    //    {
    //        [self requestCheckNearByCar];
    //    }
    else {
        
        ;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    if ([UserData isLogin]) {
        
        [_lateralSpreadsView handlePan:pan];
    }
}

-(void)hideBottomViewTapClick:(UITapGestureRecognizer *)tap
{
    [_carDetailsView hide];
    //显示一键租车按钮
    [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
    
    [_mapView removeGestureRecognizer:_hideBottomViewTap];
    _hideBottomViewTap=nil;
}

- (void)bannerAction
{
    if ([self isLogin]) {
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MonthRent" actionName:@"monthRentViewController" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)coinShareAction
{
    [FMShare shareRentForMonthActivityURL:[NSString stringWithFormat:@"%@?id=%@&carId=%@",kUrlShareCarHtml,[MyCar shareIntance].retalID,[MyCar shareIntance].vimNum] title:@"免费领车体验劵" content:[NSString stringWithFormat:@"苏打智能共享车(%@)，我“享”你，包险包养，你只负责开，剩下我们来！",[MyCar shareIntance].licenseNum] image:@"http://static.sodacar.com/package/wxShareIcon.jpg#"];
}

#pragma mark - Notification

- (void)applicationEnterBackgroundOrForeground:(NSNotification *)notif {
    
    _isEnterBackground = [notif.userInfo[@"isEnterBackground"] boolValue];
    
    if (_isEnterBackground) {
        
        [_requestPinHeartbeatTimer invalidate];
    }else {
        
        [_requestPinHeartbeatTimer invalidate];
        _requestPinHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:poiHeartbeatDelay target:self selector:@selector(requestPin) userInfo:nil repeats:YES];
    }
}

- (void)orderStatusDidChange:(NSNotification *)noti {
    
    [self requestCheckOrderStatus]; //重新获取订单状态
}

#pragma mark - 引导授权

/* 根据定位授权的状态,做出相应处理:
 * 1.用户第一次打开app,尚未做出选择时:将天安门广场旗杆的位置置于地图中心
 * 2.用户关闭了定位授权时:将天安门广场旗杆的位置置于地图中心,并提示用户开启授权 */
- (void)authorizationStatus {
    
    BOOL showAlert = NO;
    BOOL setRegion = NO;
    if (TARGET_IPHONE_SIMULATOR) {
        
        setRegion = YES;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        setRegion = YES;
    }
    
    else if (kAboveIOS8)
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            showAlert = YES;
            setRegion = YES;
        }
    }
    else if (kAboveIOS7)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
        {
            showAlert = YES;
            setRegion = YES;
        }
    }
    //    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
    //
    //        ;
    //    }
    else {
        
        ;
    }
    
    if (setRegion) {
        
        [self showCoordinate:CLLocationCoordinate2DMake(39.906921f, 116.397551f) delta:150.f animated:NO];
    }
    if (showAlert) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Services is not enabled", nil) message:NSLocalizedString(@"If you turn off the location you cannot rent a vehicle", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"设置", nil), nil];
        [Tool setCache:@"firstLocalCityCode" value:@""];
        alert.tag = VCAlertTagLocationAuthorization;
        [self requestAccessConfiguration:@""];
        [self pushActivityView:@""];
        [alert show];
    }
}

#pragma mark - Request

//用户点击一键用车发送请求接口
-(void)UpdateGeographicalPosition
{
    float userLatitude  = _userLocationCoor.latitude;
    float userLongitude = _userLocationCoor.longitude;
    NSDictionary *dic;
    dic = @{@"latitude":@(userLatitude),
            @"longitude":@(userLongitude),
            @"type":@"0"};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlPushWebsite) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             if (result==10000)
             {
                 
             }
             else if (result==12000)
             {
                 [self createNoNetWorkViewWithReloadBlock:^{
                     
                 }];
             }
             else
             {
                 
             }
         }
     }];
}

//用户点击催我建站发送请求按钮
-(void)UrgeSiteRequest
{
    __weak typeof(self) weakSelf= self;
    float userLatitude  = _userLocationCoor.latitude;
    float userLongitude = _userLocationCoor.longitude;
    NSDictionary *dic;
    dic = @{@"latitude":[NSString stringWithFormat:@"%f",userLatitude],
            @"longitude":[NSString stringWithFormat:@"%f",userLongitude],
            @"type":@"1"};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlPushWebsite) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             if (result==10000)
             {
                 [weakSelf showSuccess:NSLocalizedString(@"Urged success!", nil)];
             }
             else if (result==12000)
             {
                 [self createNoNetWorkViewWithReloadBlock:^{
                     
                 }];
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
     }];
}

//请求配置接口
-(void)requestAccessConfiguration:(NSString *)cityCode
{
    NSArray *array=@[@"APP_VERSION",@"AGREEMENT",@"IMG_STARTUP", @"RENT_DISTANCE_LIMIT", @"PARK_DISTANCE_LIMIT"];
    //天元测试cityCode
    [LXRequest requestWithJsonDic:@{@"cityCode":cityCode,@"appType":@"IOS",@"keys":array} andUrl:kURL(KUrlAccessConfiguration) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success)
        {
            if (result==10000)
            {
                NSDictionary *configs=response[@"configs"];
                // 拿到并存储动态距离
                NSString *rentLimit = configs[@"RENT_DISTANCE_LIMIT"];
                NSString *parkLimit = configs[@"PARK_DISTANCE_LIMIT"];
                
                [Tool setCache:@"RENT_DISTANCE_LIMIT" value:rentLimit];
                [Tool setCache:@"PARK_DISTANCE_LIMIT" value:parkLimit];
                
                //动态获取用户协议
                NSDictionary *AGREEMENT=configs[@"AGREEMENT"];
                NSString *url=AGREEMENT[@"url"];
                if (url.length>0)
                {
                    //                    [Tool setCache:@"UserAgreement" value:url];
                }
                else
                {
                    
                }
                
                //判断版本更新
                NSDictionary *APP_VERSION=configs[@"APP_VERSION"];
                NSString *latest=APP_VERSION[@"minimum"];
                double latestInt=[latest doubleValue];
                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *currentString=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                double currentInt=[currentString doubleValue];
                if (currentInt<latestInt)
                {
                    _versionNumber = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please upgrade immediately. Your version is too low", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Upgrade", nil), nil];
                    _versionNumber.tag = 20000;
                    [_versionNumber show];
                }
                else
                {
                    
                }
                
                //动态获取启动页
                NSDictionary *IMG_STARTUP=configs[@"IMG_STARTUP"];
                if (kIphone4)
                {
                    NSString *iphone4=IMG_STARTUP[@"iphone4"];
                    NSString *startPageURL=[Tool getCache:@"StartPageURL"];
                    if ([startPageURL isEqualToString:iphone4])
                    {
                        
                    }
                    else
                    {
                        [self getImageURL:iphone4];
                    }
                    [Tool setCache:@"StartPageURL" value:iphone4];
                }
                else if (kIphone5)
                {
                    NSString *iphone5=IMG_STARTUP[@"iphone5"];
                    NSString *startPageURL=[Tool getCache:@"StartPageURL"];
                    if ([startPageURL isEqualToString:iphone5])
                    {
                        
                    }
                    else
                    {
                        [self getImageURL:iphone5];
                    }
                    [Tool setCache:@"StartPageURL" value:iphone5];
                    
                }
                else if (kIphone6)
                {
                    NSString *iphone6=IMG_STARTUP[@"iphone6"];
                    NSString *startPageURL=[Tool getCache:@"StartPageURL"];
                    if ([startPageURL isEqualToString:iphone6])
                    {
                        
                    }
                    else
                    {
                        [self getImageURL:iphone6];
                    }
                    [Tool setCache:@"StartPageURL" value:iphone6];
                }
                else if (kIphone6plus)
                {
                    
                    NSString *iphone6p=IMG_STARTUP[@"iphone6p"];
                    NSString *startPageURL=[Tool getCache:@"StartPageURL"];
                    if ([startPageURL isEqualToString:iphone6p])
                    {
                        
                    }
                    else
                    {
                        [self getImageURL:iphone6p];
                    }
                    [Tool setCache:@"StartPageURL" value:iphone6p];
                }
                else
                {
                    
                }
            }
            else
            {
                
            }
        }
        else if (result==12000)
        {
            [self createNoNetWorkViewWithReloadBlock:^{
                
            }];
        }
        else
        {
            
        }
    }];
}


//一键租车时查询附近的车
-(void)requestCheckNearByCar
{
    [self UpdateGeographicalPosition];
    
    float userLatitude  = _userLocationCoor.latitude;
    float userLongitude = _userLocationCoor.longitude;
    NSDictionary *dic;
    dic = @{@"userLatitude":@(userLatitude),
            @"userLongitude":@(userLongitude),
            @"scope":@(1000),
            @"skip":@(0)};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlGetNearByAvailableCars) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         if (success)
         {
             NSMutableArray *dataArray = [@[] mutableCopy];;
             if (JMCodeSuccess == result)
             {
                 //临时数组存储附近车、充电桩或是停车场
                 NSArray *array;
                 array = response[@"cars"];
                 if (0 == array.count)
                 {
                     [self pushAKeyRentCarFailureView];
                 }
                 else if (array[0]==nil)
                 {
                     [self pushAKeyRentCarFailureView];
                 }
                 else
                 {
                     NSMutableArray *mutableArray=[[NSMutableArray alloc]init];
                     for (NSDictionary *dic in array)
                     {
                         POIModel *poiModel = [[POIModel alloc] initWithDictionary:dic];
                         NSString *powerPercent=[NSString stringWithFormat:@"%f",poiModel.powerPercent];
                         [mutableArray addObject:powerPercent];
                     }
                     
                     NSArray *bubbleSortArray=[mutableArray copy];
                     NSArray *userArray=[self BubbleSort:bubbleSortArray];
                     
                     NSInteger count=[array count];
                     
                     NSDictionary *userDic=[[NSDictionary alloc]init];
                     
                     for (NSDictionary *dic in array)
                     {
                         POIModel *poiModel = [[POIModel alloc] initWithDictionary:dic];
                         NSString *powerPercent=[NSString stringWithFormat:@"%f",poiModel.powerPercent];
                         if ([powerPercent isEqualToString:userArray[count-1]])
                         {
                             userDic=dic;
                         }
                         
                     }
                     
                     POIModel *poiModel = [[POIModel alloc] initWithDictionary:userDic];
                     [dataArray addObject:poiModel];
                     CLLocationCoordinate2D nearbyCarcoor = CLLocationCoordinate2DMake(poiModel.latitude, poiModel.longitude);
                     double distance = [ViewControllerServant distance:_userLocationCoor fromCoor:nearbyCarcoor];
                     if (distance<1000)
                     {
                         if (poiModel.latitude&&poiModel.longitude)
                         {
                             [self showCoordinate:CLLocationCoordinate2DMake(poiModel.latitude, poiModel.longitude) delta:.001f animated:NO];
                             [self mapView:_mapView regionDidChangeAnimated:NO];
                             
                             //若该车在当前地图上存在，自动选中
                             for (MAAnnotationView *view in _mapView.annotations)
                             {
                                 if ([view isKindOfClass:[NavPointAnnotation class]])
                                 {
                                     NavPointAnnotation *annotation = (NavPointAnnotation *)view;
                                     if ([poiModel isEqual:annotation.poiModel])
                                     {
                                         _notDeselectAnnotation = YES;
                                         [_mapView selectAnnotation:annotation animated:YES];
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
             else if (result==12000)
             {
                 [self createNoNetWorkViewWithReloadBlock:^{
                     
                 }];
             }
             else if (JMCodeNoData == result)
             {
                 [self pushAKeyRentCarFailureView];
             }
             else
             {
                 [self showError:JMMessageNetworkError];
             }
         }
         else
         {
             [self showError:JMMessageNetworkError];
         }
     }];
}

//订单状态查询
- (void)requestCheckOrderStatus {
    
    _isRentCar=NO;
    
    //jd
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Connecting...", nil) styleName:JDStatusBarStyleDark];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    NSDictionary *dic = @{};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlCheckOrderStatus) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                //jd
                [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
                [JDStatusBarNotification dismissAnimated:YES];
                
                [OrderData orderData].carId = response[@"carId"];
                [OrderData orderData].authCode = response[@"authCode"];
                [OrderData orderData].blueName = response[@"bluetoothName"];
                [OrderData orderData].state = IntegerFormObject(response[@"state"]);
                [OrderData orderData].orderId = IntegerFormObject(response[@"orderId"]);
                [OrderData orderData].startTime = kDoubleFormObject(response[@"startTime"]);
                [OrderData orderData].batonModel = IntegerFormObject(response[@"batonMode"]);
                [OrderData orderData].ifBlueTeeth = IntegerFormObject(response[@"ifBlueTeeth"]);
                
                [self orderStatusChanged];
                
                OrderStatus state = IntegerFormObject(response[@"state"]);
                if (OrderStatusRent==state) {
                    
                    //移除活动页
                    [_activityView removeFromSuperview];
                    
                    _isRentCar=YES;
                    
                    //请求车门状态
                    [self requestGetCarLockState];
                    
                    //请求停车场和充电桩
                    //                    [self requestPowerBarsAndParks];
                    
                    //绘制stop图钉
                    NSString *string = response[@"destination"];
                    NSArray *array = (NSArray *)[LXRequest jsonToDictionary:string];
                    if (array) {
                        
                        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                        for (NSDictionary *dic in array) {
                            
                            SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                            [mutableArray addObject:model];
                        }
                        [self updateStop:mutableArray];
                    }
                }else if (OrderStatusWaitingForPayment==state) {
                    
                    //移除活动页
                    [_activityView removeFromSuperview];
                    [_navigationTipView stop];
                }else if (OrderStatusRequestRent==state) {
                    
                    [self showIndeterminate:NSLocalizedString(@"Please wait", nil)];
                    
                    //开始心跳查询
                    [_ackHeartbeatTimer invalidate];
                    _ackHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:ackHeartbeatDelay target:self selector:@selector(requestRentCarAck) userInfo:nil repeats:YES];
                }
                else if (OrderStatusRequestTerminate==state) {
                    
                    [self showIndeterminate:NSLocalizedString(@"Please wait", nil)];
                    
                    //开始心跳查询
                    [_ackHeartbeatTimer invalidate];
                    _ackHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:ackHeartbeatDelay target:self selector:@selector(requestRentCarTerminateAck) userInfo:nil repeats:YES];
                }else {
                    
                    ;
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData == result) {  //不存在未完成的订单
                
                //jd
                [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
                [JDStatusBarNotification dismissAnimated:YES];
                
                [OrderData reset];
                [OrderData orderData].state = OrderStatusNoOrder;
                [self orderStatusChanged];
            }
            else if (result == 15000){
                
                NSString *tip = [NSString stringWithFormat:@"%@", response[@"tip"]];
                _updateUrl = response[@"url"];
                if (tip.length > 0 && response[@"tip"] != [NSNull null]) {
                    _isVersionUpdate = [[UIAlertView alloc] initWithTitle:nil message:response[@"tip"] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Update", nil), nil];
                }else{
                    _isVersionUpdate = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please upgrade immediately. Your version is too low", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Update", nil), nil];
                }
                
                [_isVersionUpdate show];
                
            }else {
                
                //自动重新获取订单状态(没有状态时无法获取到周边的车)
                [self performSelector:@selector(requestCheckOrderStatus) withObject:nil afterDelay:5];
            }
        }else {
            
            //自动重新获取订单状态(没有状态时无法获取到周边的车)
            [self performSelector:@selector(requestCheckOrderStatus) withObject:nil afterDelay:5];
        }
    }];
}

//4认证
- (void)requestCheckUserState {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlCheckUserState) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        [self hide];
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                //更新侧滑页的4认证状态
                [_lateralSpreadsView updateUserStatus:response];
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

//请求图钉的数据
- (void)requestPin {
    
    //租用中:不请求图钉需要的数据
    if ([OrderData isDirty]) {
        
        //地图缩放级别大于10：显示电桩与停车场，否则不显示
        if (_mapView.zoomLevel>10) {
            
            [self requestPowerBarsAndParks];
        }else {
            
            [_mapView removeAnnotations:_parksAnnotations];
            [_mapView removeAnnotations:_powerBarAnnotations];
            _parks = @[];
            _powerBars = @[];
        }
        
        return;
    }
    
    //1纬度=110.94公里
    double scope = _mapView.region.span.latitudeDelta*60*1000;
    scope = scope<60?60:scope;
    
    //获取目标点的坐标
    CGPoint focusCenter = self.view.center;
    CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
    
    //地图缩放级别大于10：获取车的数据；否则，获取分组的数据
    if (_mapView.zoomLevel>10) {
        
        _isShowCar = YES;
        [self requestGetNearByAvailableCars:coor scope:scope];
        
        // 刷新停车场图钉
        NSString *scopeString = [Tool getCache:@"PARK_DISTANCE_LIMIT"];
        double scope = [scopeString doubleValue];
        [self requestGetNearByParks:_userLocationCoor scope:scope];
        
        //清除分组的数据和分组的图钉
        [_mapView removeAnnotations:_groupAnnotations];
        _group = @[];
        _groupAnnotations = @[];
    }else {
        
        _isShowCar = NO;
        [self requestGetGroup:coor scope:scope];
        
        //清除车的数据和车的图钉
        [_mapView removeAnnotations:_carsAnnotations];
        [_mapView removeAnnotations:_parksAnnotations];
        
        _parks = @[];
        _cars = @[];
        _carsAnnotations = @[];
    }
}

- (void)requestPowerBarsAndParks {
    
    //显示停车场和充电桩图钉
    double scope = 100000000; //意在显示所有的停车场和充电桩
    CGPoint focusCenter = self.view.center;
    CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
    
    [self requestGetNearByPowerBars:coor scope:scope];
    [self requestGetNearByParks:coor scope:scope];
}

- (void)requestGetGroup:(CLLocationCoordinate2D)coor scope:(double)scope {
    
    if (_workingForGroup) {
        
        return;
    }
    _workingForGroup = YES;
    
    NSDictionary *dic = @{@"userLongitude":@(coor.longitude),
                          @"userLatitude":@(coor.latitude),
                          @"scope":@(scope)};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlGetNearByCluster) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        _workingForGroup = NO;
        if (_isShowCar) {   //当前需显示车的图钉，此次请求的返回失去意义，直接置空数据即可
            
            _group = @[];
            _groupAnnotations = @[];
            return;
        }
        
        if (success) {
            
            if (JMCodeSuccess == result)
            {
                //提取数据
                NSArray *array = response[@"clusters"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                for (NSDictionary *dic in array) {
                    
                    POIModel *model = [[POIModel alloc] initWithDictionary:dic];
                    model.type = POITypeGroup;
                    [mutableArray addObject:model];
                }
                
                _group = mutableArray;
                
                //绘制图钉
                [self showAnnotations:POITypeGroup];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData == result) {
                
                _group = @[];
                
                //绘制图钉
                [self showAnnotations:POITypeGroup];
            }else {
                
                ;   //不提示error message
            }
        }else {
            
            ;   //不提示error message
        }
    }];
}

//搜索coor周边scope半径内的车
- (void)requestGetNearByAvailableCars:(CLLocationCoordinate2D)coor scope:(double)scope {
    
    if (_workingForCar) {
        
        return;
    }
    _workingForCar = YES;
    
    NSDictionary *dic = @{@"userLongitude":@(coor.longitude),
                          @"userLatitude":@(coor.latitude),
                          @"scope":@(scope),
                          @"timeScope":@0};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlGetNearByAvailableCars) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        _workingForCar = NO;
        if (!_isShowCar) {   //当前需显示分组的图钉，此次请求的返回失去意义，直接置空数据即可
            
            _cars = @[];
            _carsAnnotations = @[];
            return;
        }
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                //提取数据
                NSArray *array = response[@"cars"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                for (NSDictionary *dic in array) {
                    
                    POIModel *model = [[POIModel alloc] initWithDictionary:dic];
                    model.type = POITypeCar;
                    [mutableArray addObject:model];
                }
                
                _cars = mutableArray;
                
                //绘制图钉
                [self showAnnotations:POITypeCar];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoData == result) {
                
                _cars = @[];
                
                //绘制图钉
                [self showAnnotations:POITypeCar];
            }else {
                
                ;   //不提示error message
            }
        }else {
            
            ;   //不提示error message
        }
    }];
}

//搜索coor周边scope半径内的电桩
- (void)requestGetNearByPowerBars:(CLLocationCoordinate2D)coor scope:(double)scope {
    
    if (_isTramCar!=1)
    {
        _isTramCar=0;
    }
    
    NSDictionary *dic = @{@"userLongitude":@(coor.longitude),
                          @"userLatitude":@(coor.latitude),
                          @"scope":@(scope),@"type":@(_isTramCar)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetNearByPowerBars) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                //提取数据
                NSArray *array = response[@"powerbars"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                for (NSDictionary *dic in array) {
                    
                    POIModel *model = [[POIModel alloc] initWithDictionary:dic];
                    model.type = POITypePowerBars;
                    [mutableArray addObject:model];
                }
                _powerBars = mutableArray;
                
                [self showAnnotations:POITypePowerBars];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                ;   //不提示error message
            }
        }else {
            
            ;
        }
    }];
}

//搜索coor周边scope半径内的停车场
- (void)requestGetNearByParks:(CLLocationCoordinate2D)coor scope:(double)scope {
    
    NSDictionary *dic = @{@"userLongitude":@(coor.longitude),
                          @"userLatitude":@(coor.latitude),
                          @"scope":@(scope)};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetNearByParks) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                //提取数据
                NSArray *array = response[@"parks"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
                for (NSDictionary *dic in array) {
                    
                    POIModel *model = [[POIModel alloc] initWithDictionary:dic];
                    model.type = POITypeParks;
                    [mutableArray addObject:model];
                    
                }
                _parks = mutableArray;
                
                [self showAnnotations:POITypeParks];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                ;   //不提示error message
            }
        }else {
            
            ;
        }
    }];
}

//查看车辆信息
- (void)requestGetCarDetailInfo:(BOOL)lockState {
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlGetCarDetailInfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result)
            {
                POIModel *model = [[POIModel alloc] initWithDictionary:response];
                model.type = POITypeDriving;
                
                _isTramCar=model.powerType;
                
                [self requestPowerBarsAndParks];
                
                //显示当前租用车的信息
                _carDetailsView.poiModel = model;
                [_carDetailsView updateUI];
                [_carDetailsView show];
                //隐藏一键租车按钮
                [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:YES];
                
                //根据车门状态，判断是否显示图钉
                //关锁
                if (lockState) {
                    
                    _drivingCars = @[model];
                    [self showAnnotations:POITypeDriving];
                }
                //开锁
                else
                {
                    _drivingCars = @[];
                    [self showAnnotations:POITypeDriving];
                    _drivingCars = @[model];
                }
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

//检查车门状态
- (void)requestGetCarLockState {
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlGetCarLockState) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result)
            {
                
                NSInteger lockState = IntegerFormObject(response[@"lockState"]);
                //DrivingToolStatus status = lockState?DrivingToolStatusUnlock:DrivingToolStatusLock;
                //[_drivingToolView setStatus:status];
                
                [self requestGetCarDetailInfo:lockState];   //重新获取车辆状态，并传递车门状态：是否显示车辆图钉
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

//关锁
- (void)requestLock:(BOOL)ifBluetooth
{
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    [self showIndeterminate:NSLocalizedString(@"Lock…", nil)];
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlLock) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success)
        {
            if (JMCodeSuccess == result)
            {
                //天元重要测试
                [self hide];
                //                [self showIndeterminate:@"车门已锁"];
                //                [self performSelector:@selector(hide) withObject:nil afterDelay:5];
                
                [self showSuccess:NSLocalizedString(@"Door locked", nil)];
                
                //[_drivingToolView setStatus:DrivingToolStatusUnlock];
                
                [self requestGetCarDetailInfo:YES];   //重新获取车辆状态，并传递车门状态：是否显示车辆图钉
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
        }
        else
        {
            if (ifBluetooth)
            {
                [self hide];
                _isBluetoothClose = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No internet connection available. Please use bluetooth", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Use Bluetooth", nil), nil];
                [_isBluetoothClose show];
                
                //判断该车的T-BOX是否支持蓝牙
                //                if ([_central isConnected]) {
                //
                //                    [self showIndeterminate:@"正在锁门"];
                //                    [self post:1];
                //                }else {
                //
                //                    [self showIndeterminate:@"准备中，请稍候"];
                //                    [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:1];
                //                }
            }
            else
            {
                [self showError:JMMessageNetworkError];
            }
        }
    }];
}

//开锁
- (void)requestUnlock:(BOOL)ifBluetooth {
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    [self showIndeterminate:NSLocalizedString(@"Unlock...", nil)];
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlUnlock) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
     {
         
         if (success) {
             
             if (JMCodeSuccess == result) {
                 //
                 //                [self showIndeterminate:@"车门已开"];
                 //                [self performSelector:@selector(hide) withObject:nil afterDelay:5];
                 
                 [self hide];
                 [self showSuccess:NSLocalizedString(@"Door Opened", nil)];
                 
                 //                [_drivingToolView setStatus:DrivingToolStatusLock];
                 
                 //立即隐藏图钉
                 _drivingCars = @[];
                 [self showAnnotations:POITypeDriving];
                 
                 [self requestGetCarDetailInfo:NO];   //重新获取车辆状态，并传递车门状态：是否显示车辆图钉
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
             
             //网络开锁失败
             //            NSLog(@"9999999 %@",ifBluetooth?@"YES":@"NO");
             
             if (ifBluetooth) {    //判断该车的T-BOX是否支持蓝牙
                 
                 [self hide];
                 
                 _isBluetoothOpen = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No internet connection available. Please use bluetooth", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Use Bluetooth", nil), nil];
                 [_isBluetoothOpen show];
                 
                 //                if ([_central isConnected]) {
                 //
                 //                    [self showIndeterminate:@"正在开锁"];
                 //                    [self post:0];
                 //                }else {
                 //
                 //                    [self showIndeterminate:@"准备中，请稍候"];
                 //                    [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:0];
                 //                    NSLog(@"blueName=%@", [OrderData orderData].blueName);
                 //                    NSLog(@"authCode=%@", [OrderData orderData].authCode);
                 //                }
             }
             else
             {
                 [self showError:JMMessageNetworkError];
             }
         }
     }];
}

//鸣笛提示
- (void)requestBlow {
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    [self showIndeterminate:NSLocalizedString(@"Requesting whistle", nil)];
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlBlow) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result)
            {
                [self hide];
                [self showSuccess:NSLocalizedString(@"Whistling", nil)];
                //                [self showIndeterminate:@"正在鸣笛"];
                //                [self performSelector:@selector(hide) withObject:nil afterDelay:3];
                
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

//闪灯提示
- (void)requestVague:(BOOL)ifBluetooth
{
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    [self showIndeterminate:NSLocalizedString(@"Requesting flash", nil)];
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlVague) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result)
            {
                [self hide];
                [self showSuccess:NSLocalizedString(@"Flashing", nil)];
                //                [self showIndeterminate:@"正在闪灯"];
                //                [self performSelector:@selector(hide) withObject:nil afterDelay:3];
                
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
        }
        else
        {
            if (ifBluetooth)
            {    //判断该车的T-BOX是否支持蓝牙
                [self hide];
                _isBluetoothFlash = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No internet connection available. Please use bluetooth", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Use Bluetooth", nil), nil];
                [_isBluetoothFlash show];
                
                //                if ([_central isConnected])
                //                {
                //                    [self showIndeterminate:@"正在请求闪灯"];
                //                    [self post:3];
                //                }
                //                else
                //                {
                //                    [self showIndeterminate:@"准备中，请稍候"];
                //                    [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:3];
                //                }
            }
            else
            {
                [self showError:JMMessageNetworkError];
            }
        }
    }];
}

//开始租车
- (void)requestRentCarReq {
    
    [self showIndeterminate:NSLocalizedString(@"Applying to rent the vehicle" , nil)];
    
    NSString *carId = _carDetailsView.poiModel.carId;
    NSDictionary *dic = @{@"carId":carId};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlRentCarReq) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self showIndeterminate:NSLocalizedString(@"Please wait", nil)];
                
                //开始心跳查询
                [_ackHeartbeatTimer invalidate];
                _ackHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:ackHeartbeatDelay target:self selector:@selector(requestRentCarAck) userInfo:nil repeats:YES];
            }else if (JMCodeInsufficientDeposit == result)
            {
                [self checkDeposit];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if(JMCodeNoCertification == result) {    //用户没有经过4认证，不允许租车
                
                [self hide];
                
                //用户未认证，弹出用户向导模板
                UserGuideView *view = [[UserGuideView alloc] initWithFrame:self.view.bounds];
                view.delegate = self;
                [view initUIWithType:UGTypeNotRent];
                [self.navigationController.view addSubview:view];
                [view show];
            }else {
                
                [self hide];
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//租车状态查询(心跳)
- (void)requestRentCarAck {
    
    _isRentCar=NO;
    
    NSString *carId = [OrderData orderData].carId?:_carDetailsView.poiModel.carId;
    NSDictionary *dic = @{@"carId":carId};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlRentCarAck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                _isRentCar=YES;
                
                [self hide];
                [_ackHeartbeatTimer invalidate];    //终止心跳
                
                [AudioUtils phoneVibrate];
                [OrderData orderData].carId = response[@"carId"];
                __weak typeof(self) weakSelf= self;
                //租车操作向导
                PromptView *promptView = [[PromptView alloc] initWithPromptViewStyle:RentSuccessPromptViewTag];
                promptView.pushLoginViewController=^
                {
                    [weakSelf createNoNetWorkViewWithReloadBlock:^{
                        
                    }];
                };
                //                PromptView *promptView = [[PromptView alloc] init];
                //                promptView.carID=response[@"carId"];
                //                [promptView initWithPromptViewStyle:RentSuccessPromptViewTag];
                
                promptView.promptViewDelegate = self;
                
                [self.navigationController.view addSubview:promptView];
                _promptView = promptView;
                
                [OrderData orderData].state = OrderStatusRent;
                [OrderData orderData].orderId = IntegerFormObject(response[@"orderId"]);
                [OrderData orderData].startTime = kDoubleFormObject(response[@"startTime"]);
                [OrderData orderData].carId = response[@"carId"];
                [OrderData orderData].authCode = response[@"authCode"];
                [OrderData orderData].ifBlueTeeth = IntegerFormObject(response[@"ifBlueTeeth"]);
                [OrderData orderData].blueName = response[@"bluetoothName"];
                
                //请求车门状态
                [self requestGetCarLockState];
                
                //请求停车场和充电桩
                //                [self requestPowerBarsAndParks];
                
                [self orderStatusChanged];
                
                self.topBannerView.hidden = YES;
                self.bannerBtn.hidden = YES;
                self.coinShareBtn.hidden = YES;
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoReady == result) {    //not ready车辆正在进入租用状态，不要终止心跳
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showIndeterminate:errMsg];
            }else {
                
                [self hide];
                [_ackHeartbeatTimer invalidate];    //终止心跳
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }else {
            
            ;
        }
    }];
}

//判断还车时是否停在停车场附近
//-(void)requestJudgeCarNearByPark
//{
//    [self showIndeterminate:@"正在检查周围是否有停车场"];
//
//    double scope = 0.0000001;
//    CGPoint focusCenter = self.view.center;
//    CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
//
//    NSDictionary *dic = @{@"userLongitude":@(coor.longitude),
//                          @"userLatitude":@(coor.latitude),
//                          @"scope":@(scope)};
//
//    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlGetNearByParks) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
//     {
//         if (success)
//         {
//             if (JMCodeSuccess == result)
//             {
//                 [self requestRentCarTerminateReq];
//             }
//             else if (JMCodeNoData==result)
//             {
//                [self showIndeterminate:@"请将车停靠到有停车场的位置"];
//             }
//             else
//             {
//                 [self showIndeterminate:@""];
//             }
//         }
//         else
//         {
//             ;
//         }
//     }];
//}

- (void)requestRentCarTerminateCheck
{
    [self showIndeterminate:@"请稍候"];
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    JMWeakSelf(self);
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlRentCarTerminateCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if ([_central isConnected]) {   //若bluetooth使用中，断开
            
            [_central disconnect];
        }
        
        if (success) {
            //                result=10006;
            if (JMCodeSuccess == result) {
                [weakself hide];
                
                [weakself pushUploadParkInfo];
            }else if (result==12000)
            {
                [weakself createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeReturnCarFailure==result)
            {
                [weakself hide];
                if (!_promptFailureView)
                {
                    _promptFailureView=[[PromptView alloc]initWithPromptViewStyle:ReturnCarFailureTag];
                }
                _promptFailureView.promptViewDelegate = self;
                [weakself.navigationController.view addSubview:_promptFailureView];
                [weakself promptViewButtonClick];
            }
            else
            {
                
                [self hide];
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }else {
            
            [weakself showError:JMMessageNetworkError];
        }
    }];
}
//开始还车
- (void)requestRentCarTerminateReq
{
    [self showIndeterminate:NSLocalizedString(@"Applying to end the trip", nil)];
    
    NSString *carId = [OrderData orderData].carId;
    NSDictionary *dic = @{@"carId":carId};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlRentCarTerminateReq) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if ([_central isConnected]) {   //若bluetooth使用中，断开
            
            [_central disconnect];
        }
        
        if (success) {
            //                result=10006;
            if (JMCodeSuccess == result) {
                
                _isRentCar=NO;
                
                [self showIndeterminate:NSLocalizedString(@"Please wait", nil)];
                
                //开始心跳查询
                [_ackHeartbeatTimer invalidate];
                _ackHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:ackHeartbeatDelay target:self selector:@selector(requestRentCarTerminateAck) userInfo:nil repeats:YES];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeReturnCarFailure==result)
            {
                [self hide];
                if (!_promptFailureView)
                {
                    _promptFailureView=[[PromptView alloc]initWithPromptViewStyle:ReturnCarFailureTag];
                }
                _promptFailureView.promptViewDelegate = self;
                [self.navigationController.view addSubview:_promptFailureView];
                [self promptViewButtonClick];
            }
            else
            {
                
                [self hide];
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//还车状态查询(心跳)
- (void)requestRentCarTerminateAck {
    
    NSString *carId = [OrderData orderData].carId?:_carDetailsView.poiModel.carId;
    NSDictionary *dic = @{@"carId":carId};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlRentCarTerminateAck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            //            result=10005;
            if (JMCodeSuccess == result) {
                
                if ([response[@"orderid"] integerValue]!=0) {
                    
                    [OrderData orderData].orderId = [response[@"orderid"] integerValue];
                }
                [self pushBill];    //还车成功，进入订单页
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (JMCodeNoReady == result) {    //not ready车辆正在进入租用状态，不要终止心跳
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showIndeterminate:errMsg];
            }else {
                
                [self hide];
                [_ackHeartbeatTimer invalidate];    //终止心跳
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errMsg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }else {
            
            ;
        }
    }];
}

#pragma mark - 包月请求
- (void)requestUserPackageCheck
{
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlUserPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            if (result == JMCodeSuccess) {
                NSArray *array = response[@"list"];
                if (array.count > 0) {
                    [UserData share].isRentForMonth = YES;
                }
            }
        }
    }];
}

#pragma mark - 押金逻辑

- (void)checkDeposit
{
    [self showIndeterminate:@""];
    JMWeakSelf(self);
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(KUrlDepositStatus) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                [weakself hide];
                [weakself depositLogic:response];
            }
            else {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [weakself showError:message];
            }
        }else {
            
            [weakself showError:JMMessageNetworkError];
        }
    }];
}

- (void)depositLogic:(NSDictionary *)response
{
    NSString *refundingID = response[@"refundingId"];
    //有退款记录
    if (![refundingID isEqual:[NSNull null]]) {
        RefundStatusViewController *vc = [[RefundStatusViewController alloc] init];
        vc.tradeID = refundingID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else
    {
        double balance = [response[@"balance"] doubleValue];
        double defaultAmount = [response[@"defaultAmount"] doubleValue];
        
        DepositViewController *vc = [[DepositViewController alloc] init];
        vc.isNeedCharge = defaultAmount > balance?YES:NO;
        vc.balance = balance;
        vc.defaultAmout = defaultAmount;
        vc.isPaySuccessPopToRoot = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//还车状态查询(心跳)
//- (void)requestCancel {
//
//    NSString *carId = [OrderData orderData].carId;
//    NSDictionary *dic = @{@"carId":carId};
//    [LXRequest requestWithJsonDic:dic andUrl:kURL(kE2EUrlCancle) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
//
//        [self performSelector:@selector(requestCheckOrderStatus) withObject:nil afterDelay:5];
//        if (success) {
//
//            ;
//        }else {
//
//            ;
//        }
//    }];
//}

#pragma mark - UITextFieldDelegate
//租完车后，导航栏中间变成搜索框，点击触发的事件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    DestinationListViewController *destinationListViewController = [[DestinationListViewController alloc] init];
    destinationListViewController.delegate = self;
    [self.navigationController pushViewController:destinationListViewController animated:YES];
    
    return NO;
}

#pragma mark - 各种点击事件的回调

//活动页的回调block


//重载mapView上的图钉(刷新用户头像)
- (void)updateAnnotations {
    
    NSArray *array = [_mapView.annotations mutableCopy];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:array];
}

/* LateralSpreadsDelegate (侧滑) */
- (void)clickedIndex:(LateralSpreadsViewTag)tag {
    
    //设置下次viewWillAppear时不请求order状态数据
    _notUpdateOrderStatus = YES;
    
    [_lateralSpreadsView hide];
    switch (tag) {
            
            //        case LSVTagAddress: {
            //
            //            DestinationViewController *destinationViewController = [[DestinationViewController alloc] init];
            //            [self.navigationController pushViewController:destinationViewController animated:YES];
            //            break;
            //        }
        case LSVTagHistory: {
            
            OrderHistoryViewController *orderHistoryViewController = [[OrderHistoryViewController alloc] init];
            [self.navigationController pushViewController:orderHistoryViewController animated:YES];
            break;
        }
        case LSVTagMoney: {
            
            WalletViewController *walletViewController = [[WalletViewController alloc]init];
            [self.navigationController pushViewController:walletViewController animated:YES];
            break;
        }
        case LSVTagMyCar:
        {
            UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MyCar" actionName:@"myCarViewController" params:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case LSVTagNotif: {
            
            ActivityViewController *activityViewController = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:activityViewController animated:YES];
            
            
            break;
        }
            //        case LSVTagRanking: {
            //
            //            RankingViewController *rankingViewController = [[RankingViewController alloc] init];
            //            [self.navigationController pushViewController:rankingViewController animated:YES];
            //            break;
            //        }
        case LSVTagShare: {
            //            NSString *nickname = [UserData userData].nickname?[UserData userData].nickname:@"";
            //            NSString *contentStr = [[NSString alloc]initWithFormat:ShareContentStr,nickname];
            //            [FMShare share:ShareTitle andContentStr:contentStr andViewController:self andUrlString:ShareRedirectUri];
            ShareInviteCodeViewController *shareInviteCodeViewController=[[ShareInviteCodeViewController alloc]init];
            [self.navigationController pushViewController:shareInviteCodeViewController animated:YES];
            break;
        }
        case LSVTagUserInfo: {
            
            PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc] init];
            [self.navigationController pushViewController:personalInfoViewController animated:YES];
            break;
        }
        case LSVTagHelp: {
            
            HelpViewController *helpViewController = [[HelpViewController alloc] init];
            [self.navigationController pushViewController:helpViewController animated:YES];
            break;
        }
        case LSVTagSetup: {
            
            SettingsPageViewController *settingsPageViewController = [[SettingsPageViewController alloc] init];
            [self.navigationController pushViewController:settingsPageViewController animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)didShow {
    
    [self requestCheckUserState];   //重新获取4认证状态
}

- (void)didHide {
    
    ;
}

/*PromptView block回调事件*/
//还车失败
-(void)promptViewButtonClick
{
    __block ViewController *blockSelf = self;
    __weak typeof(self) weakSelf= self;
    
    _promptFailureView.pushController=^
    {
        _notUpdateOrderStatus = YES;
        NearbyCarListViewController *nearbyCarListViewController=[[NearbyCarListViewController alloc]init];
        nearbyCarListViewController.isReturnCarFailure=YES;
        nearbyCarListViewController.nearbyCarDelegate = weakSelf;
        nearbyCarListViewController.userLocationCoor = blockSelf->_userLocationCoor;
        nearbyCarListViewController.showType = ShowTypeParks;
        [blockSelf->_promptFailureView removeFromSuperview];
        blockSelf->_promptFailureView=nil;
        [weakSelf.navigationController pushViewController:nearbyCarListViewController animated:YES];
    };
}

//一键租车失败
-(void)promptViewAKeyFailureButtonClick
{
    __block ViewController *blockSelf = self;
    __weak typeof(self) weakSelf= self;
    
    _promptAKeyFailureView.pushAllCarController=^
    {
        _notUpdateOrderStatus = YES;
        NearbyCarListViewController *nearbyCarListViewController=[[NearbyCarListViewController alloc]init];
        nearbyCarListViewController.isAKeyRentCarFailure=YES;
        nearbyCarListViewController.nearbyCarDelegate = weakSelf;
        nearbyCarListViewController.userLocationCoor = blockSelf->_userLocationCoor;
        nearbyCarListViewController.showType = ShowTypeParks;
        [blockSelf->_promptAKeyFailureView removeFromSuperview];
        blockSelf->_promptAKeyFailureView=nil;
        [weakSelf.navigationController pushViewController:nearbyCarListViewController animated:YES];
    };
}
//催我建站
-(void)UrgeSiteButtonClick
{
    __weak typeof(self) weakSelf= self;
    if (_promptAKeyFailureView)
    {
        _promptAKeyFailureView.UrgeSiteButtonClick=^
        {
            [weakSelf UrgeSiteRequest];
        };
    }
}


/* CarDetailsDelegate (POI详情) */
- (void)clickedCarDetailsButtonAtIndex:(CarDetailsViewTag)tag {
    
    if (CDVTagWalking == tag) {
        //记得替换
        [self beginNavigation:Walk];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_targetPOI.latitude longitude:_targetPOI.longitude];
        [_footLocationEngine setStop:location];
        [_footLocationEngine stop];
        [_footLocationEngine start];
        
    }else if (CDVTagUnlock == tag) {
        
        [Tool setCache:@"UserAgreement" value: _targetPOI.agreement];
        
        if ([self isLogin]) {
            
            if ([OrderData isDirty]) {
                
                [self showInfo:NSLocalizedString(@"Checking order status, please wait", nil)];
                [self requestCheckOrderStatus]; //重新检查订单状态
                
                return;
            }
        }else {
            
            return;
        }
        
        /*  每次租用都弹出用户协议
         if ([OrderData orderData].isWriting) {  //同意用户协议
         
         [self requestRentCarReq];
         }else {  //尚未同意用户协议
         */
        {
            //设置下次viewWillAppear时不请求order状态数据
            _notUpdateOrderStatus = YES;
            
            WebViewController *webViewController = [[WebViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
            webViewController.view.frame = [UIScreen mainScreen].bounds;
            [webViewController setHideAgreeButton:NO];
            webViewController.title = NSLocalizedString(@"User Agreement", nil);
            webViewController.delegate = self;
            
            NSString *userAgreement=[Tool getCache:@"UserAgreement"];
            if (userAgreement.length>0)
            {
                [webViewController loadUrl:userAgreement];
            }
            else
            {
                [webViewController loadUrl:kURL(kE2EUrlYongHuXieYi)];
            }
            
            [self presentViewController:navi animated:YES completion:nil];
        }
    }else if (CDVTagGo == tag) {
        //记得替换
        [self beginNavigation:Walk];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_targetPOI.latitude longitude:_targetPOI.longitude];
        [_footLocationEngine setStop:location];
        [_footLocationEngine stop];
        [_footLocationEngine start];
    }else if (tag == CDVTagRule) {
        
        NSString *priceUrl = [Tool getCache:@"priceRuleUrl"];
        NSString *activityBtn = [Tool getCache:@"activityBtn"];
        if (priceUrl.length > 0) {
            WebViewController *webView = [[WebViewController alloc] init];
            webView.view.frame = [UIScreen mainScreen].bounds;
            [webView setHideAgreeButton:YES];
            if (activityBtn.length > 0) {
                webView.title = activityBtn;
            }else{
                webView.title = NSLocalizedString(@"Charging rules", nil);
            }
            [webView loadUrl:priceUrl];
            [self.navigationController pushViewController:webView animated:YES];
        }else{
            ;
        }
    }else {
        
        ;
    }
}

/* DrivingToolViewDelegate */
- (void)clickedDrivingToolButtonAtIndex:(DrivingToolViewTag)tag {
    
    switch (tag) {
            
        case CTVTagUnlock: {
            //开锁
            [self requestUnlock:[OrderData orderData].ifBlueTeeth];
            //            [self action:0 ifBluetooth:[OrderData orderData].ifBlueTeeth];
        }
            break;
        case CTVTagLock: {
            //锁门
            [self requestLock:[OrderData orderData].ifBlueTeeth];
            //            [self action:1 ifBluetooth:[OrderData orderData].ifBlueTeeth];
        }
            break;
        case CTVTagNavigation: {
            
            if (_stop&&_stop.count) {
                //记得替换
                //[self beginNavigation:Drive];   //开启驾车路线规划:进入导航页面
            }else {
                
                DestinationListViewController *destinationListViewController = [[DestinationListViewController alloc] init];
                destinationListViewController.delegate = self;
                [self.navigationController pushViewController:destinationListViewController animated:YES];
            }
        }
            break;
        case CTVTagTerminate: {
            
            //还车操作向导
            PromptView *promptView = [[PromptView alloc] initWithPromptViewStyle:TerminateRentPromptViewTag];
            promptView.promptViewDelegate = self;
            [self.navigationController.view addSubview:promptView];
            _promptView = promptView;
        }
            break;
        case CTVTagMore: {
            
            POIModel *drivingModel = [[POIModel alloc] init];
            drivingModel = _drivingCars[0];
            if (drivingModel.powerType == 0) {
                
                //NSString *string = (_mapView.userTrackingMode==MAUserTrackingModeFollow)?@"关闭自动跟随":@"开启自动跟随";
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Rescue number", nil) otherButtonTitles:NSLocalizedString(@"Flashing prompt", nil), NSLocalizedString(@"Show nearby charging stations" , nil), NSLocalizedString(@"Show nearby parking lots", nil), nil];
                actionSheet.tag = VCSheetTagDrivingToolMore;
                [actionSheet showInView:self.navigationController.view];
            }else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Rescue number", nil) otherButtonTitles:NSLocalizedString(@"Flashing prompt", nil), NSLocalizedString(@"Show nearby charging stations" , nil), nil];
                actionSheet.tag = VCSheetTagDrivingToolMorePetrol ;
                [actionSheet showInView:self.navigationController.view];
            }
            
        }
            break;
            
        default:
            break;
    }
}

/* DestinationListDelegate */
/*天元测试 接力棒模式暂不支持，防止警告暂时注释*/
- (void)didSelectedPOIArray:(NSArray *)array {
    
    //    [self removeRoute];
}

/* WebViewDelegate */
- (void)didAgreed {
    [_mapView removeGestureRecognizer:_hideBottomViewTap];
    _hideBottomViewTap=nil;
    [self requestRentCarReq];
}

/* NavigationTipDelegate */
- (void)navigationTipDidClicked {
    
    _notUpdateOrderStatus = YES;
}

//点击附近的车页面里的cell，实现的代理方法
/* NearbyCarDelegate */
- (void)didSelectNearbyCar:(POIModel *)poiModel {
    
    if (poiModel.latitude&&poiModel.longitude) {
        
        [self showCoordinate:CLLocationCoordinate2DMake(poiModel.latitude, poiModel.longitude) delta:.001f animated:NO];
        [self mapView:_mapView regionDidChangeAnimated:NO];
        
        //若该车在当前地图上存在，自动选中
        for (MAAnnotationView *view in _mapView.annotations) {
            
            if ([view isKindOfClass:[NavPointAnnotation class]]) {
                
                NavPointAnnotation *annotation = (NavPointAnnotation *)view;
                if ([poiModel isEqual:annotation.poiModel]) {
                    
                    _notDeselectAnnotation = YES;
                    [_mapView selectAnnotation:annotation animated:YES];
                    
                    //                    PinAnnotationView *pin = (PinAnnotationView *)[_mapView viewForAnnotation:annotation];
                    //                    [self mapView:_mapView didSelectAnnotationView:pin];
                    return;
                }
            }
        }
    }
}

/* UserGuideDelegate */
- (void)userGuideButtonClicked {
    
    PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc] init];
    personalInfoViewController.showUserGuide = YES;     //标记显示用户向导模板
    [self.navigationController pushViewController:personalInfoViewController animated:YES];
}

//提示页的代理方法
- (void)promptView:(PromptViewStyle)promptViewStyle clicked:(NSInteger)tag {
    
    if (TerminateRentPromptViewTag==promptViewStyle && 1==tag) {
        
        if (![self.navigationController.viewControllers containsObject:_billViewController]) {
            
            [self requestRentCarTerminateCheck];
        }
    }
    
    else if (ReturnCarFailureTag==promptViewStyle && 2==tag)
    {
        [_promptFailureView removeFromSuperview];
        _promptFailureView=nil;
    }
    else if (AKeyRentCarFailureTag==promptViewStyle && 3==tag)
    {
        [_promptAKeyFailureView removeFromSuperview];
        _promptAKeyFailureView=nil;
    }
    [_promptView removeFromSuperview];
    _promptView=nil;
}

#pragma mark - AppleWatch

- (NSArray *)getCarLocation {
    
    NSMutableArray *mutableArray = [@[] mutableCopy];
    for (POIModel *model in _cars) {
        
        NSDictionary *carCoordinateDic = @{@"latitude":@(model.latitude),@"longitude":@(model.longitude)};
        [mutableArray addObject:carCoordinateDic];
    }
    
    NSArray *car = mutableArray;
    return car;
}

- (NSDictionary *)getUserLocation {
    
    NSDictionary *userLocationDic = @{@"userLatitue":@(_userLocationCoor.latitude),@"userLongitude":@(_userLocationCoor.longitude)};
    return userLocationDic;
}

//watch app先于iPhone启动时，app的mapView会为nil，原因未知
- (void)checkMapAppearBecomeWatchStartFirst {
    
    if (!_mapView) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map loading failed", nil) message:NSLocalizedString(@"Touch OK to reload", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
        alert.tag = VCAlertTagMapAllocError;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate & UIActionSheetDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0)
//    {
//
//
//
//    }
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //用蓝牙开门或再试一次网络连接
    //开门
    if (alertView==_isBluetoothOpen)
    {
        if (1==buttonIndex)
        {
            if ([_central isConnected]) {
                
                [self showIndeterminate:NSLocalizedString(@"Unlock...", nil)];
                [self post:0];
            }else {
                
                [self showIndeterminate:NSLocalizedString(@"Reparing, please wait", nil)];
                [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:0];
                
            }
            //             [self requestUnlock:[OrderData orderData].ifBlueTeeth];
        }
        else
        {
            
            
        }
    }
    //闪灯
    else if (alertView==_isBluetoothFlash)
    {
        if (1==buttonIndex)
        {
            if ([_central isConnected])
            {
                [self showIndeterminate:NSLocalizedString(@"Requesting flash", nil)];
                [self post:3];
            }
            else
            {
                [self showIndeterminate:NSLocalizedString(@"Reparing, please wait", nil)];
                [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:3];
            }
            
            //            [self requestVague:[OrderData orderData].ifBlueTeeth];
        }
        else
        {
            
        }
        
    }
    //锁门
    else if (alertView==_isBluetoothClose)
    {
        if (1==buttonIndex)
        {
            //判断该车的T-BOX是否支持蓝牙
            if ([_central isConnected]) {
                
                [self showIndeterminate:NSLocalizedString(@"Lock…", nil)];
                [self post:1];
            }else {
                
                [self showIndeterminate:NSLocalizedString(@"Reparing, please wait", nil)];
                [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:1];
            }
            //            [self requestLock:[OrderData orderData].ifBlueTeeth];
        }
        else
        {
            
        }
    }
    
    else if (VCAlertTagMapAllocError==alertView.tag) {
        
        [self initMapView];
    }
    
    else if (alertView==_versionNumber)
    {
        if (1==buttonIndex)
        {
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id992172307"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else
        {
            
        }
    }
    
    else if (alertView.tag>=VCAlertTagBlueToothDisconnect) {
        
        NSInteger index = alertView.tag - VCAlertTagBlueToothDisconnect;
        
        if (1==buttonIndex) {
            
            [self action:index ifBluetooth:0];
        }else if (2==buttonIndex) {
            
            [self action:index ifBluetooth:1];
        }else {
            
            ;
        }
    }else if (alertView == _isVersionUpdate){
        if (buttonIndex == 1) {
            
            //            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/su-da-chu-xing/id992172307?mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateUrl]];
        }
        
    }else{
        
        if (1==buttonIndex && alertView!=_pushAlert)
        {
            if (UIApplicationOpenSettingsURLString != NULL) {
                NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:appSettings];
            }
        }
        //用户没有开启通知，点击跳转到开启通知页
        else if (alertView==_pushAlert)
        {
            if (1==buttonIndex)
            {
                //                NSURL*url=[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
                //                [[UIApplication sharedApplication] openURL:url];
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
            }
            else
            {
                
            }
        }
        
        else
        {
            
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (VCSheetTagDrivingToolMore==actionSheet.tag) {
        
        if (!buttonIndex) {
            
            //拨打400电话
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else if (1==buttonIndex) {
            
            //闪灯
            [self requestVague:[OrderData orderData].ifBlueTeeth];
            
            //            [self action:3 ifBluetooth:[OrderData orderData].ifBlueTeeth];
        }else if (2==buttonIndex) {
            
            //1.map上显示图钉
            double scope = 100000000; //意在显示所有的充电站
            
            //获取目标点的坐标
            CGPoint focusCenter = self.view.center;
            CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
            
            [self requestGetNearByPowerBars:coor scope:scope];
            
            //2.push到列表页
            _notUpdateOrderStatus = YES;        //设置下次viewWillAppear时不请求order状态数据
            
            NearbyCarListViewController *nearByCarViewController = [[NearbyCarListViewController alloc] init];
            nearByCarViewController.nearbyCarDelegate = self;
            nearByCarViewController.userLocationCoor = _userLocationCoor;
            nearByCarViewController.showType = ShowTypePowerbars;
            [self.navigationController pushViewController:nearByCarViewController animated:YES];
        }else if (3==buttonIndex) {
            
            //1.map上显示图钉
            double scope = 100000000; //意在显示所有的停车场
            
            //获取目标点的坐标
            CGPoint focusCenter = self.view.center;
            CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
            
            [self requestGetNearByParks:coor scope:scope];
            
            //2.push到列表页
            _notUpdateOrderStatus = YES;        //设置下次viewWillAppear时不请求order状态数据
            
            NearbyCarListViewController *nearByCarViewController = [[NearbyCarListViewController alloc] init];
            nearByCarViewController.nearbyCarDelegate = self;
            nearByCarViewController.userLocationCoor = _userLocationCoor;
            nearByCarViewController.showType = ShowTypeParks;
            [self.navigationController pushViewController:nearByCarViewController animated:YES];
        }else {
            
            /* 开启\关闭自动跟随
             BOOL isFollow = (_mapView.userTrackingMode==MAUserTrackingModeFollow);
             _mapView.userTrackingMode = isFollow?MAUserTrackingModeNone:MAUserTrackingModeFollow;
             */
        }
    }else if (actionSheet.tag == VCSheetTagDrivingToolMorePetrol){
        
        if (!buttonIndex) {
            
            //拨打400电话
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else if (1==buttonIndex) {
            
            //闪灯
            [self requestVague:[OrderData orderData].ifBlueTeeth];
            
            //            [self action:3 ifBluetooth:[OrderData orderData].ifBlueTeeth];
        }else if (2==buttonIndex) {
            
            //1.map上显示图钉
            double scope = 100000000; //意在显示所有的停车场
            
            //获取目标点的坐标
            CGPoint focusCenter = self.view.center;
            CLLocationCoordinate2D coor = [_mapView convertPoint:focusCenter toCoordinateFromView:self.view];
            
            [self requestGetNearByParks:coor scope:scope];
            
            //2.push到列表页
            _notUpdateOrderStatus = YES;        //设置下次viewWillAppear时不请求order状态数据
            
            NearbyCarListViewController *nearByCarViewController = [[NearbyCarListViewController alloc] init];
            nearByCarViewController.nearbyCarDelegate = self;
            nearByCarViewController.userLocationCoor = _userLocationCoor;
            nearByCarViewController.showType = ShowTypeParks;
            [self.navigationController pushViewController:nearByCarViewController animated:YES];
        }else {
            
            /* 开启\关闭自动跟随
             BOOL isFollow = (_mapView.userTrackingMode==MAUserTrackingModeFollow);
             _mapView.userTrackingMode = isFollow?MAUserTrackingModeNone:MAUserTrackingModeFollow;
             */
        }
    }else if (VCSheetTagNavigationMore==actionSheet.tag) {
        
        if (!buttonIndex) {
            
            _isOpenSpeechSynthesizer = !_isOpenSpeechSynthesizer;
            
            NSString *string = _isOpenSpeechSynthesizer?NSLocalizedString(@"Voice guidance is On", nil):NSLocalizedString(@"Voice Navigation closed", nil);
            [self showSuccess:string];
        }else {
            
            ;
        }
    }else {
        
        ;
    }
}

#pragma mark - Bluetooth

- (void)unlockWithWatch {
    
    [self action:0 ifBluetooth:[OrderData orderData].ifBlueTeeth];
}

- (void)lockWithWatch {
    
    [self action:1 ifBluetooth:[OrderData orderData].ifBlueTeeth];
}

- (void)pingWithWatch {     //待优化：目前watch的闪灯按钮，发起的请求是鸣笛！
    
    [self action:3 ifBluetooth:[OrderData orderData].ifBlueTeeth];
}

//判断点击的是哪个按钮：开门，锁门等
- (void)action:(NSInteger)index ifBluetooth:(BOOL)ifBluetooth {
    
    if (!index) {
        //开锁
        [self requestUnlock:[OrderData orderData].ifBlueTeeth];
        //        [self unlock:ifBluetooth];
    }else if (1==index) {
        //锁门
        [self requestLock:[OrderData orderData].ifBlueTeeth];
        //        [self lock:ifBluetooth];
    }else if (2==index) {
        
        [self honking:ifBluetooth];
    }else if (3==index) {
        //闪灯
        [self requestVague:[OrderData orderData].ifBlueTeeth];
        //        [self flash:ifBluetooth];
    }else {
        
        ;
    }
}

//开锁
//- (void)unlock:(BOOL)ifBluetooth {
//先联网
//    if (ifBluetooth) {    //判断该车的T-BOX是否支持蓝牙
//
//        if ([_central isConnected]) {
//
//            [self showIndeterminate:@"正在开锁"];
//            [self post:0];
//        }else {
//
//            [self showIndeterminate:@"准备中，请稍候"];
//            [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:0];
//            NSLog(@"blueName=%@", [OrderData orderData].blueName);
//            NSLog(@"authCode=%@", [OrderData orderData].authCode);
//        }
//    }else {

//    [self requestUnlock:ifBluetooth];
//    }
//}

//- (void)lock:(BOOL)ifBluetooth {
//
//    if (ifBluetooth) {    //判断该车的T-BOX是否支持蓝牙
//
//        if ([_central isConnected]) {
//
//            [self showIndeterminate:@"正在锁门"];
//            [self post:1];
//        }else {
//
//            [self showIndeterminate:@"准备中，请稍候"];
//            [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:1];
//        }
//    }else {
//
//        [self requestLock:ifBluetooth];
//    }
//}

- (void)honking:(BOOL)ifBluetooth {
    
    if (ifBluetooth) {    //判断该车的T-BOX是否支持蓝牙
        
        if ([_central isConnected]) {
            
            [self showIndeterminate:NSLocalizedString(@"Requesting whistle", nil)];
            [self post:2];
        }else {
            
            [self showIndeterminate:NSLocalizedString(@"Reparing, please wait", nil)];
            [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:2];
        }
    }else {
        
        [self requestBlow];
    }
}

//- (void)flash:(BOOL)ifBluetooth {
//
//    if (ifBluetooth) {    //判断该车的T-BOX是否支持蓝牙
//
//        if ([_central isConnected]) {
//
//            [self showIndeterminate:@"正在请求闪灯"];
//            [self post:3];
//        }else {
//
//            [self showIndeterminate:@"准备中，请稍候"];
//            [_central connect:[OrderData orderData].authCode name:[OrderData orderData].blueName order:3];
//        }
//    }else {
//
//        [self requestVague:ifBluetooth];
//    }
//}

- (void)post:(NSInteger)index {
    
    NSArray *array;
    if ([OrderData orderData].authCode.length<16) {
        
        [self showInfo:NSLocalizedString(@"Please try again later", nil)];
        return;
    }
    
    const char *ch = [[OrderData orderData].authCode UTF8String];
    if (!index) {
        
        array = [BluetoothPacket order:0x01 authCode:ch];
    }else if (1==index) {
        
        array = [BluetoothPacket order:0x02 authCode:ch];
    }else if (2==index) {
        
        array = [BluetoothPacket order:0x03 authCode:ch];
    }else {
        
        array = [BluetoothPacket order:0x04 authCode:ch];
    }
    
    for (NSData *data in array) {
        [_central writeValue:data];
        
        if (array.count>2) {
            
            sleep(1);
        }
    }
}

#pragma mark - BluetoothDelegate

- (void)connectDidSuccess:(NSInteger)index {
    
    [self hide];
    if (index>-1) { //不等于-1：有预设命令，自动执行预设命令一次
        
        [self action:index ifBluetooth:[OrderData orderData].ifBlueTeeth];
    }
}

- (void)connectDidFail:(NSInteger)index {
    
    [self hide];
    
    if (index>-1) { //不等于-1：有预设命令，弹出提示（无预设命令：可能是断开后重连，并非用户发起）
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"尚未建立蓝牙连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"尝试远程连接", @"再试一次", nil];
        //        alert.tag = VCAlertTagBlueToothDisconnect+index;
        //        [alert show];
        [self showError:NSLocalizedString(@"没有响应,请稍候重试", nil)];
    }
}

- (void)connectDidLost {
    
    [self hide];
}

- (void)connectDidTimeover:(NSInteger)index {
    
    [self hide];
    
    if (index>-1) { //不等于-1：有预设命令，弹出提示（无预设命令：可能是断开后重连，并非用户发起）
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"尚未建立蓝牙连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"尝试远程连接", @"再试一次", nil];
        //        alert.tag = VCAlertTagBlueToothDisconnect+index;
        //        [alert show];
        [self showError:NSLocalizedString(@"没有响应,请稍候重试", nil)];
    }
}

- (void)writeDidTimeover {
    
    [self hide];
    [self showInfo:NSLocalizedString(@"没有响应,请稍候重试", nil)];
}

- (void)didReadValue:(NSData *)data {
    
    [self hide];
    
    const char *ch = [data bytes];
    NSLog(@"ch=%@", data);
    
    //待优化：缺少数据校验
    
    DrivingToolStatus status = 0;
    NSString *string;
    BOOL sucess;
    
    int ord = ch[2];
    int suc = ch[3];
    if (0x01==ord) {
        
        status = DrivingToolStatusLock;
        string = @"Unlock";
    }else if (0x02==ord) {
        
        status = DrivingToolStatusUnlock;
        string = @"Lock";
    }else if (0x03==ord) {
        
        string = @"Whistle";
    }else if (0x04==ord) {
        
        string = @"Flash";
    }else {
        
        return;
    }
    
    if (0x01==suc) {
        
        sucess = YES;
    }else if (0x02==ord) {
        
        sucess = NO;
    }else {
        
        return;
    }
    
    if (sucess) {
        
        if (status) {
            
            //            [_drivingToolView setStatus:status];
        }
        
        NSString *message = [NSString stringWithFormat:@"%@完成", NSLocalizedString(string, nil)];
        [self showSuccess:message];
    }else {
        
        NSString *message = [NSString stringWithFormat:@"%@失败，请稍候重试", NSLocalizedString(string, nil)];
        [self showError:message];
    }
}

- (void)connectDidAbnormal:(NSString *)string {
    
    NSLog(@"%@", string);
}

#pragma mark - 定位

- (void)didUpdateUserLocation:(CLLocationCoordinate2D)coor {
    
    [_navigationTipView setUserLocation:coor];
    [_footLocationEngine setUserLocation:coor];
    
    //保存coor
    _userLocationCoor = coor;
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{

    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode]; 成都code码为028
        if (_isCityCodeFirst==YES)
        {
            NSString *cityCode=response.regeocode.addressComponent.citycode;
            
            [self requestAccessConfiguration:cityCode];
            [Tool setCache:@"firstLocalCityCode" value:cityCode];
            
            //推出活动页
            [self pushActivityView:cityCode];
            _isCityCodeFirst=NO;
        }
        else
        {
            NSString *cityCode=response.regeocode.addressComponent.citycode;
            [Tool setCache:@"localCityCode" value:cityCode];
            NSString *cityFirstCode=[Tool getCache:@"firstLocalCityCode"];
            NSString *localCityCode=[Tool getCache:@"localCityCode"];
            if ([cityFirstCode isEqualToString:localCityCode])
            {
                
            }
            else
            {
                _activityView=nil;
                [Tool setCache:@"firstLocalCityCode" value:localCityCode];
                [self requestAccessConfiguration:cityCode];
                [self pushActivityView:cityCode];
            }
        }
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@,%@",mapView,[error description]);
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {

    [UserData share].userLocation = userLocation;
    if (!updatingLocation) {    //heading数据更新时，更新用户当前位置图标的旋转角度，然后return不做后续处理
        
        if (userLocation.heading.headingAccuracy>=0) {
            
            //用户当前方向-地图旋转角度*(M_PI/180)
            CLLocationDirection direction = userLocation.heading.magneticHeading;
            CLLocationDirection rotationDegree = _mapView.rotationDegree;
            CLLocationDirection rotation = (direction-rotationDegree)*(M_PI/180);
            
            _userPinAnnotationView.transform = CGAffineTransformMakeRotation(rotation);
        }
        
        return;
    }else {     //location数据更新时，保存coor，并做后续处理
        
        CLLocationCoordinate2D coor = userLocation.location.coordinate;
        _userLocationCoor = coor;
        
        //初始化检索对象
        _searchMapCity = [[AMapSearchAPI alloc] init];
        _searchMapCity.delegate = self;

        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
        regeoRequest.radius = 1000;
        regeoRequest.requireExtension = YES;

        //发起逆地理编码
        [_searchMapCity AMapReGoecodeSearch: regeoRequest];
        
    }
    
    //首次更新用户位置时
    if (_needFly &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        _needFly = NO;
        
        //将当前用户位置置于地图中心,并缩放地图比例
        [self showCoordinate:_mapView.userLocation.coordinate delta:.01f animated:YES];
        
        //初始化检索对象
        _searchCity = [[AMapSearchAPI alloc] init];
        _searchCity.delegate = self;
        
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
        regeoRequest.radius = 1000;
        regeoRequest.requireExtension = YES;
        
        //发起逆地理编
        [_searchCity AMapReGoecodeSearch: regeoRequest];
        _isCityCodeFirst=YES;
    }
    
    //更新车辆详情辆(距离发生变化)
    if ([_carDetailsView isShow]) {
        
        if (_carDetailsView.poiModel.type==POITypeMe) {
            
            _carDetailsView.poiModel.longitude = userLocation.coordinate.longitude;
            _carDetailsView.poiModel.latitude = userLocation.coordinate.latitude;
        }else {
            
            CLLocationCoordinate2D coorA = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
            CLLocationCoordinate2D coorB = CLLocationCoordinate2DMake(_targetPOI.latitude, _targetPOI.longitude);
            _carDetailsView.distance = [ViewControllerServant distance:coorA fromCoor:coorB];
        }
        [_carDetailsView updateUI];
    }
    
    //更新导航提示栏的数据
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [_navigationTipView setUserLocation:coor];
    
    //设置步行导航数据
    [_footLocationEngine setUserLocation:coor];
}

#pragma mark - 地图

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {    //用户当前位置的图标
        
        static NSString *annotationIdentifier = @"userAnnotationIdentifier";
        
        if (!_userPinAnnotationView) {
            
            _userPinAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                     reuseIdentifier:annotationIdentifier];
            _userPinAnnotationView.animatesDrop   = NO;
            _userPinAnnotationView.canShowCallout = NO;
            _userPinAnnotationView.draggable      = NO;
            _userPinAnnotationView.enabled        = NO;
        }
        _userPinAnnotationView.image = UIImageName(@"userLocation");
        
        //用户头像
        /*
         UIImageView *userImageView = [self userImageView];
         [_userPinAnnotationView addSubview:userImageView];
         */
        
        return _userPinAnnotationView;
    }else if ([annotation isKindOfClass:[NavPointAnnotation class]]) {   //Point Of Information
        
        static NSString *annotationIdentifier = @"POIAnnotationIdentifier";
        
        //车的大头针
        PinAnnotationView *pointAnnotationView = (PinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (!pointAnnotationView) {
            
            pointAnnotationView = [[PinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:annotationIdentifier];
            pointAnnotationView.canShowCallout = NO;
            pointAnnotationView.draggable      = NO;
            
            //            pointAnnotationView.centerOffset = CGPointMake(8, -22);
            
        }
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        pointAnnotationView.poiModel = navAnnotation.poiModel;  //传递汽车的数据
        
        //开始租车以后显示的图标
        if (navAnnotation.poiModel.type == POITypeCar)
        {
            [self updateAnnotation:navAnnotation PinAnnotationView:pointAnnotationView];
            
        }else if (navAnnotation.poiModel.type == POITypePowerBars) {
            
            if (navAnnotation.poiModel.isChargingPile==1)
            {
                pointAnnotationView.hidden=YES;
            }
            else
            {
                pointAnnotationView.hidden=NO;
                pointAnnotationView.image = UIImageName(@"POIBattery_nor");
            }
            
        }else if (navAnnotation.poiModel.type == POITypeParks) {
            
            if ([navAnnotation.poiModel.owner isEqualToString:@"AVIS"])
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    pointAnnotationView.image = UIImageName(@"aboardPosition");
                }else{
                    //天元测试
                    pointAnnotationView.image = UIImageName(@"POIParking_nor");
                }
            }
            else
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    pointAnnotationView.image = UIImageName(@"aboardPosition");
                }else{
                    //天元测试
                    pointAnnotationView.image = UIImageName(@"POIParking_nor");
                }
            }
            
        }else if (navAnnotation.poiModel.type == POITypeStop) {
            
            pointAnnotationView.centerOffset = CGPointMake(0, 0);
            if ([annotation isEqual:[_stopAnnotations lastObject]]) {   //终点
                
                pointAnnotationView.image = UIImageName(@"destinationLocation");
                
                /*
                 UIImageView *imageView = [self destinationImageView];
                 [pointAnnotationView addSubview:imageView];
                 */
            }else {  //途经点
                
                pointAnnotationView.image = UIImageName(@"stopLocation");
                
                /*
                 UIImageView *imageView = [self stopImageView];
                 [pointAnnotationView addSubview:imageView];
                 */
            }
        }else if (navAnnotation.poiModel.type == POITypeMe) {
            
            ;
        }else if (navAnnotation.poiModel.type == POITypeGroup) {
            
            pointAnnotationView.image = UIImageName(@"POIGroup_nor");
        }
        else if (navAnnotation.poiModel.type == POITypeDriving)
        {
            
            [self updateAnnotation:navAnnotation PinAnnotationView:pointAnnotationView];
        }
        else
        {
            
            ;
        }
        pointAnnotationView.bounds = CGRectMake(0, 0, 100, 100);
        return pointAnnotationView;
    }else {
        
        ;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    if (_notDeselectAnnotation==NO)
    {
        [_mapView removeGestureRecognizer:_hideBottomViewTap];
        _hideBottomViewTap=nil;
    }
    
    [_requestPinHeartbeatTimer invalidate];
    _requestPinHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:poiFocusHeartbeatDelay target:self selector:@selector(requestPin) userInfo:nil repeats:YES];
    
    _howToUseButton.hidden = YES;
    if ([view isKindOfClass:[PinAnnotationView class]]) {     //Point Of Information
        
        PinAnnotationView *annotationView = (PinAnnotationView *)view;
        //记录选定的图钉
        if (annotationView&&annotationView.poiModel) {
            
            _targetPOI = annotationView.poiModel;
        }
        
        BOOL isShowCarDetailsView           = NO;
        BOOL isChangeZoomLevel              = NO;
        //BOOL canUp                          = NO;
        // 存储计费规则
        if (_targetPOI.priceUrl.length > 0) {
            [Tool setCache:@"priceRuleUrl" value:_targetPOI.priceUrl];
        }
        if (_targetPOI.activityBtn.length > 0) {
            [Tool setCache:@"activityBtn" value:_targetPOI.activityBtn];
        }
        //替换图钉的image
        if (POITypeCar == annotationView.poiModel.type) {
            
            if (_targetPOI.selectCarIcon)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    _targetPOI.selectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_targetPOI.selectCarIcon]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        view.image = [UIImage imageWithData:_targetPOI.selectCarIconData];
                        view.bounds = CGRectMake(0, 0, 100, 100);
                    });
                });
                
                view.bounds = CGRectMake(0, 0, 100, 100);
            }
            else
            {
                view.image = UIImageName(@"POICar_sel");
                
            }
            isShowCarDetailsView    = YES;
            //            canUnp                   = YES;
        }else if (POITypePowerBars == annotationView.poiModel.type) {
            
            
            if (annotationView.poiModel.isChargingPile==1)
            {
                view.hidden=YES;
            }
            else
            {
                view.hidden=NO;
                view.image = UIImageName(@"POIBattery_sel");
            }
            
            isShowCarDetailsView    = YES;
        }else if (POITypeParks == annotationView.poiModel.type) {
            
            if ([annotationView.poiModel.owner isEqualToString:@"AVIS"])
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    view.image = UIImageName(@"aboardPosition_sel");
                }else{
                    //天元测试
                    view.image = UIImageName(@"POIParking_sel");
                }
            }
            else
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    view.image = UIImageName(@"aboardPosition_sel");
                }else{
                    //天元测试
                    view.image = UIImageName(@"POIParking_sel");
                }
            }
            
            isShowCarDetailsView    = YES;
        }else if (POITypeStop == annotationView.poiModel.type) {
            
            isShowCarDetailsView    = YES;
        }else if (POITypeMe == annotationView.poiModel.type) {
            
            ;
        }else if (POITypeGroup == annotationView.poiModel.type) {
            
            isChangeZoomLevel       = YES;
        }else if (POITypeDriving == annotationView.poiModel.type)
        {
            if (_targetPOI.selectCarIcon)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    _targetPOI.selectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_targetPOI.selectCarIcon]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        view.image = [UIImage imageWithData:_targetPOI.selectCarIconData];
                        view.bounds = CGRectMake(0, 0, 100, 100);
                    });
                });
                
                view.bounds = CGRectMake(0, 0, 100, 100);
            }
            else
            {
                view.image = UIImageName(@"POICar_sel");
            }
            isShowCarDetailsView    = YES;
            _howToUseButton.hidden = NO;
        }else {
            
            ;
        }
        
        //显示poi详情栏
        if (isShowCarDetailsView) {
            
            CLLocationCoordinate2D coorA = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
            CLLocationCoordinate2D coorB = CLLocationCoordinate2DMake(_targetPOI.latitude, _targetPOI.longitude);
            _carDetailsView.poiModel = annotationView.poiModel;
            _carDetailsView.distance = [ViewControllerServant distance:coorA fromCoor:coorB];
            [_carDetailsView updateUI];
            
            if (OrderStatusRent != [OrderData orderData].state && POITypeParks == annotationView.poiModel.type)  {
                // 调整未租用状态停车场View的Y值
                [_carDetailsView show];
                _carDetailsView.y = _carDetailsView.y + 50;
            }else{
                [_carDetailsView show];
            }
            
            
            //隐藏一键用车按钮
            [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:YES];
        }
        
        //自动放大地图
        if (isChangeZoomLevel&&_mapView.zoomLevel<12.0) {
            
            [self showCoordinate:CLLocationCoordinate2DMake(annotationView.poiModel.latitude, annotationView.poiModel.longitude) delta:.01f animated:YES];
        }
    }else {
        
        /* 去掉这个蛋疼的功能，因为它会让你点不到车上...
         POIModel *model = [[POIModel alloc] init];
         model.type = POITypeMe;
         model.desp = @"我就是我，是颜色不一样的烟火。";
         _carDetailsView.poiModel = model;
         [_carDetailsView updateUI];
         [_carDetailsView show];
         */
    }
    
    //租用时，隐藏toolview，避免半透明效果重叠
    //    if (OrderStatusRent==[OrderData orderData].state) {
    //
    //        [_drivingToolView hide];
    //    }
    
    
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
    if (_notDeselectAnnotation) {   //通过didSelectNearbyCar:方法，自动选中，直接return
        
        view.image = UIImageName(@"");
        _notDeselectAnnotation = NO;
        
        //添加让底部view消失的手势
        if (!_hideBottomViewTap)
        {
            _hideBottomViewTap=[[UITapGestureRecognizer alloc]init];
            [_hideBottomViewTap addTarget:self action:@selector(hideBottomViewTapClick:)];
            [_mapView addGestureRecognizer:_hideBottomViewTap];
        }
        
        return;
    }
    
    
    if (OrderStatusRent!=[OrderData orderData].state) {     //不在租用中：隐藏poi详情栏
        
        [_carDetailsView hide];
        //显示一键租车按钮
        [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
    }else {     //租用中：update为当前租用车辆的数据
        
        if (_drivingCars.count) {
            
            _carDetailsView.poiModel = _drivingCars[0];
            [_carDetailsView updateUI];
            [_carDetailsView show];
            _howToUseButton.hidden = NO;
            //隐藏一键租车按钮
            [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:YES];
        }
    }
    //记录取消选定图钉
    _targetPOI = nil;
    
    if ([view isKindOfClass:[PinAnnotationView class]]) {
        
        //替换图钉的image
        PinAnnotationView *annotationView = (PinAnnotationView *)view;
        
        if (POITypeCar == annotationView.poiModel.type)
        {
            if (annotationView.poiModel.disSelectCarIcon)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    annotationView.poiModel.disSelectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:annotationView.poiModel.disSelectCarIcon]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        view.image = [UIImage imageWithData:annotationView.poiModel.disSelectCarIconData];
                        view.bounds = CGRectMake(0, 0, 100, 100);
                    });
                });
                
                view.bounds = CGRectMake(0, 0, 100, 100);
                
            }
            else
            {
                view.image = UIImageName(@"POICar_nor");
            }
        }else if (POITypePowerBars == annotationView.poiModel.type) {
            
            if (annotationView.poiModel.isChargingPile==1)
            {
                view.hidden=YES;
            }
            else
            {
                view.hidden=NO;
                view.image = UIImageName(@"POIBattery_nor");
            }
            
        }else if (POITypeParks == annotationView.poiModel.type) {
            if ([annotationView.poiModel.owner isEqualToString:@"AVIS"])
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    view.image = UIImageName(@"aboardPosition");
                }else{
                    //天元测试
                    view.image = UIImageName(@"POIParking_nor");
                }
            }
            else
            {
                if ([OrderData orderData].state !=  OrderStatusRent) {
                    view.image = UIImageName(@"aboardPosition");
                }else{
                    //天元测试
                    view.image = UIImageName(@"POIParking_nor");
                }
            }
            
        }else if (POITypeStop == annotationView.poiModel.type) {
            
            ;
        }else if (POITypeMe == annotationView.poiModel.type) {
            
            ;
        }else if (POITypeGroup == annotationView.poiModel.type) {
            
            ;
        }else if (POITypeDriving == annotationView.poiModel.type) {
            
            if (annotationView.poiModel.disSelectCarIcon)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    annotationView.poiModel.disSelectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:annotationView.poiModel.disSelectCarIcon]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        view.image = [UIImage imageWithData:annotationView.poiModel.disSelectCarIconData];
                        view.bounds = CGRectMake(0, 0, 100, 100);
                    });
                });
                
                view.bounds = CGRectMake(0, 0, 100, 100);
                
            }
            else
            {
                view.image = UIImageName(@"POICar_nor");
            }
        }else {
            
            ;
        }
    }else {
        
        ;
    }
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    //    [_requestPinHeartbeatTimer invalidate];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (_isRentCar==YES)
    {
        [_carDetailsView show];
        //隐藏一键租车按钮
        [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:YES];
    }
    else
    {
        /*天元重要测试*/
        [_carDetailsView hide];
        [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
    }
    
    [_requestPinHeartbeatTimer invalidate];
    _requestPinHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:poiHeartbeatDelay target:self selector:@selector(requestPin) userInfo:nil repeats:YES];
    
    //重新请求图钉所需的数据
    [self requestPin];
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {   //步行导航的线路
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 5.f;
        polylineRenderer.strokeColor = UIColorFromRGB(0, 172, 238);
        polylineRenderer.lineCapType = kMALineCapSquare;
        
        return polylineRenderer;
    }else if([overlay isKindOfClass:[MACircle class   ]])
    {
        MACircleRenderer * circle = [[MACircleRenderer alloc]initWithCircle:overlay];
        circle.fillColor = [UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:.19f];
        circle.lineDash = YES;
        return circle;
    }else if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer * polyGon = [[MAPolygonRenderer alloc]initWithPolygon:overlay];
        polyGon.lineWidth = 6.f;
        polyGon.strokeColor = UIColorFromSixteenRGB(0x4fc3ff);
        polyGon.lineJoinType = kMALineCapRound;
        polyGon.fillColor = UIColorFromSixteenRGBA(0x4fc3ff, .1f);
        return polyGon;
    }
    
    return nil;
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSLog(@"%@", error);
    
    //导航路线绘制失败后,立即释放实例
    _naviManager.delegate = nil;
    _naviManager = nil;
    _naviViewController.delegate = nil;
    _naviViewController = nil;
    _workingForNaviManager = NO;
    
    [self showInfo:NSLocalizedString(@"并没有可用的步行路线", nil)];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [_naviManager startGPSNavi];
//    //导航视图展示
//    if (!_naviManager) {
//
//        _naviManager = [[AMapNaviWalkManager alloc] init];
//        _naviManager.delegate = self;
//    }
//    if (!_naviViewController) {
//
//        _naviViewController = [[AMapNaviWalkView alloc] initwith]//[[AMapNaviWalkView alloc] initWithMapView:_mapView delegate:self];
//        _isOpenSpeechSynthesizer = YES;
//        _naviViewController.showMoreButton = NO;
//
//        //自定义导航界面的图标
//        //[_naviViewController setWayPointImage:UIImageName(@"stopBubbles")];
//        //[_naviViewController setEndPointImage:UIImageName(@"destinationBubbles")];
//    }
//
//    //模出导航页面
//    [_naviManager presentNaviViewController:_naviViewController animated:YES];
}
/*
//导航视图被展示出来的回调函数
- (void)AMapNaviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController {
    
    if (!_naviManager) {
        
        _naviManager = [[AMapNaviManager alloc] init];
        _naviManager.delegate = self;
    }
    
    //调用startGPSNavi方法进行实时导航，调用startEmulatorNavi方法进行模拟导航
    [_naviManager startGPSNavi];
    //[_naviManager startEmulatorNavi];
    
    //隐藏poi详情栏
    if (OrderStatusRent!=[OrderData orderData].state) {
        
        [_carDetailsView hide];
        //显示一键租车按钮
        [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:NO];
    }
    
    //由于进入导航后，mapView被释放，所以在进入导航前开启自定义获取定位的模块
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模拟器不支持定位");
#elif TARGET_OS_IPHONE
    if (!_location) {

        _location = [[Location alloc] init];
        _location.delegate = self;
    }

    [_location update];
#endif
    
    //设置tipView的viewController
    _navigationTipView.viewController = _naviViewController;
}

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController {
    
    //结束后台location获取
    [_location stop];
    _location.delegate = nil;
    _location = nil;
    
    [_naviManager stopNavi];
    [_naviManager dismissNaviViewControllerAnimated:YES];
    
    //重新绘制地图和图钉
    [self initMapView];
    [self showAnnotations:POITypeStop];
    [self showAnnotations:POITypeParks];
    [self showAnnotations:POITypePowerBars];
    [self showAnnotations:POITypeDriving];
    if (_drivingCars.count) {
        
        _carDetailsView.poiModel = _drivingCars[0];
        [_carDetailsView updateUI];
        [_carDetailsView show];
        //隐藏一键租车按钮
        [_aKeyRentCarButtonView changeAKeyRentCarButtonHidden:YES];
    }
    
    //由于退出导航会重置mapView,所以自动执行_locationButton的动作
    //[self buttonClicked:_locationButton];
    
    //设置tipView的viewController
    _navigationTipView.viewController = self.navigationController;
    
    //    [UIApplication sharedApplication].idleTimerDisabled = YES;  //禁用系统的自动锁屏功能
}

- (void)AMapNaviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController __attribute__ ((deprecated("use naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController instead"))) {
    
    _naviManager.delegate = nil;
    _naviManager = nil;
    _naviViewController.delegate = nil;
    _naviViewController = nil;
    _workingForNaviManager = NO;
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController {
    
    NSString *string = _isOpenSpeechSynthesizer?NSLocalizedString(@"关闭语音导航", nil):NSLocalizedString(@"启动语音导航", nil);
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:string otherButtonTitles:nil];
    sheet.tag = VCSheetTagNavigationMore;
    [sheet showInView:self.navigationController.view];
}

- (void)AMapNaviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    
    if (_isOpenSpeechSynthesizer) {
        
    }
}
*/
-(void)updateAnnotation:(NavPointAnnotation *)navAnnotation PinAnnotationView:(PinAnnotationView*)pointAnnotationView
{
    
    if (navAnnotation.poiModel.disSelectCarIcon)
    {
        NSInteger countDic=[_carIconDic count];
        if (countDic>0)
        {
            for (NSString *carIcon in [_carIconDic allKeys])
            {
                if ([carIcon isEqualToString:navAnnotation.poiModel.disSelectCarIcon])
                {
                    NSData *data=[_carIconDic objectForKey:navAnnotation.poiModel.disSelectCarIcon];
                    pointAnnotationView.image = [UIImage imageWithData:data];
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        navAnnotation.poiModel.disSelectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:navAnnotation.poiModel.disSelectCarIcon]];
                        [_carIconDic setValue:navAnnotation.poiModel.disSelectCarIconData forKey:navAnnotation.poiModel.disSelectCarIcon];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            pointAnnotationView.image = [UIImage imageWithData:navAnnotation.poiModel.disSelectCarIconData];
                            pointAnnotationView.bounds=CGRectMake(0, 0, 100, 100);
                        });
                    });
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                navAnnotation.poiModel.disSelectCarIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:navAnnotation.poiModel.disSelectCarIcon]];
                [_carIconDic setValue:navAnnotation.poiModel.disSelectCarIconData forKey:navAnnotation.poiModel.disSelectCarIcon];
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    pointAnnotationView.image = [UIImage imageWithData:navAnnotation.poiModel.disSelectCarIconData];
                    pointAnnotationView.bounds=CGRectMake(0, 0, 100, 100);
                });
            });
        }
    }
    else
    {
        pointAnnotationView.image = UIImageName(@"POICar_nor");
    }
    
}

#pragma mark - 画线\画图钉

//绘制规划的路线
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute /*__attribute((deprecated("未使用")))*/ {
    
    if (!naviRoute) {
        
        return;
    }
    
    [self removeRoute]; //移除上一次步行导航的路线
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++) {
        
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [_mapView addOverlay:_polyline];
}

//移除步行导航的路线
- (void)removeRoute /*__attribute((deprecated("未使用")))*/ {
    
    if (_polyline) {
        
        [_mapView removeOverlay:_polyline];
        _polyline = nil;
    }
}

//将poiModel数据转成_annotations的NavPointAnnotation数据,在地图上显示图钉
- (void)showAnnotations:(POIType)type {
    
    NSArray *poiModelArray;
    if (POITypeCar == type) {
        
        poiModelArray = _cars;
    }else if (POITypeStop == type) {
        
        poiModelArray = _stop;
    }else if (POITypePowerBars == type) {
        
        poiModelArray = _powerBars;
    }else if (POITypeParks == type) {
        
        poiModelArray = _parks;
    }else if (POITypeMe == type) {
        
        ;
    }else if (POITypeGroup == type) {
        
        poiModelArray = _group;
    }else if (POITypeDriving == type) {
        
        poiModelArray = _drivingCars;
    }else {
        
        ;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:poiModelArray.count];
    for (POIModel *model in poiModelArray) {
        
        NavPointAnnotation *annotation = [[NavPointAnnotation alloc] initWithPOIModel:model];
        
        //        NSLog(@"6666666  %@",annotation.poiModel.disSelectCarIcon);
        //        NSLog(@"5555555 %@",annotation.poiModel.disSelectCarIconData);
        
        [mutableArray addObject:annotation];
    }
    
    if (POITypeCar == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_carsAnnotations];
        _carsAnnotations = mutableArray;
        [_mapView addAnnotations:_carsAnnotations];
    }else if (POITypeStop == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_stopAnnotations];
        _stopAnnotations = mutableArray;
        [_mapView addAnnotations:_stopAnnotations];
    }else if (POITypePowerBars == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_powerBarAnnotations];
        _powerBarAnnotations = mutableArray;
        [_mapView addAnnotations:_powerBarAnnotations];
    }else if (POITypeParks == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_parksAnnotations];
        _parksAnnotations = mutableArray;
        [_mapView addAnnotations:_parksAnnotations];
    }else if (POITypeMe == type) {
        
        ;
    }else if (POITypeGroup == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_groupAnnotations];
        _groupAnnotations = mutableArray;
        [_mapView addAnnotations:_groupAnnotations];
    }else if (POITypeDriving == type) {
        
        //清除历史后绘制图钉
        [_mapView removeAnnotations:_drivingCarsAnnotations];
        _drivingCarsAnnotations = mutableArray;
        [_mapView addAnnotations:_drivingCarsAnnotations];
    }else {
        
        ;
    }
}

//更新终点和途经点
- (void)updateStop:(NSArray *)array {
    
    if (!array||!array.count) {
        
        return;
    }
    
    //更新导航提示栏的数据,并启动心跳
    [_navigationTipView setStop:array];
    [_navigationTipView stop];
    [_navigationTipView start];
    
    //将searchModel转成poiModel，并赋给_stop
    NSMutableArray *mutableArray = [@[] mutableCopy];
    for (NSInteger i=0; i<array.count; i++) {
        
        SearchModel *model = array[i];
        NSDictionary *dic = @{@"latitude":@(model.latitude),
                              @"longitude":@(model.longitude),
                              @"desp":model.name};
        POIModel *poi = [[POIModel alloc] initWithDictionary:dic];
        poi.type = POITypeStop;
        [mutableArray addObject:poi];
    }
    _stop = mutableArray;
    
    //绘制图钉
    [self showAnnotations:POITypeStop];
    
    //开启驾车路线规划:进入导航页面,记得替换
    //[self beginNavigation:Drive];
    
    //取目的地列表中的第一站的model:将导航目的地位置置于地图中心
    //    SearchModel *firstModel = [array firstObject];
    //    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(firstModel.latitude, firstModel.longitude) animated:YES];
    
    //取目的地列表中的最后一站的model:更新textField的占位符
    SearchModel *lastModel = [array lastObject];
    //NSString *text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Destinations：", nil), lastModel.name];
    /* 暂不加以下文本，显示不下
     if (array.count>1) {
     
     text = [NSString stringWithFormat:@"%@，途经%ld个地点。", text, (long)array.count-1];
     }
     */
    //_textField.text = text;
}

//开启导航
- (void)beginNavigation:(WayToTravel)tip {
    
    if (!_workingForNaviManager) {
        
        _workingForNaviManager = YES;
        
        //一旦创建CPU占用急速升高!,记得替换
        if (!_naviManager) {
            _naviManager = [[AMapNaviWalkManager alloc] init];
            _naviManager.delegate = self;
            
            _naviViewController = [[AMapNaviWalkView alloc] initWithFrame:self.view.bounds];
           _naviViewController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_naviViewController setDelegate:self];
            
            [self.navigationController.view addSubview:_naviViewController];
            
            [_naviManager addDataRepresentative:_naviViewController];
        }
    
        //A点为用户当前位置,B点为目标点位置
        AMapNaviPoint *navPointA = [AMapNaviPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
        AMapNaviPoint *navPointB;
        
        //区分导航类型
        if (Walk==tip) {    //“步行”
            
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_targetPOI.latitude, _targetPOI.longitude);
            navPointB = [AMapNaviPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
            [_naviManager calculateWalkRouteWithStartPoints:@[navPointA] endPoints:@[navPointB]];
        }else if (GO==tip) {    //"前往"充电站和停车场
            
//            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_targetPOI.latitude, _targetPOI.longitude);
//            navPointB = [AMapNaviPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
//            [_naviManager calculateDriveRouteWithStartPoints:@[navPointA] endPoints:@[navPointB] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefault];
        }else {  //驾车导航:导航策略为速度优先
            
            if (!_stop.count) {
                
                return;
            }
            
            //终点
            POIModel *model = [_stop lastObject];
            navPointB = [AMapNaviPoint locationWithLatitude:model.latitude longitude:model.longitude];
            
            //途径点:同时支持最多3个途经点
            NSMutableArray *mutableArray = [@[] mutableCopy];
            for (NSInteger i=0; i<_stop.count-1; i++) {
                
                POIModel *model = _stop[i];
                AMapNaviPoint *navPoint = [AMapNaviPoint locationWithLatitude:model.latitude longitude:model.longitude];
                [mutableArray addObject:navPoint];
            }
            
            
//            [_naviManager calculateDriveRouteWithStartPoints:@[navPointA] endPoints:@[navPointB] wayPoints:mutableArray drivingStrategy:AMapNaviDrivingStrategyDefault]; //wayPoints:途径的点(stop)
        }
    }
    
}
#pragma mark - AMapNaviWalkView Delegate
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView
{
    _workingForNaviManager = NO;
    _naviManager.delegate = nil;
    _naviManager = nil;
    [walkView removeFromSuperview];
}
//将地图中心移动到一个坐标点上
- (void)showCoordinate:(CLLocationCoordinate2D)coor delta:(double)delta animated:(BOOL)animated {
    
    MACoordinateSpan span;
    span.latitudeDelta  = delta;      //1纬度=110.94公里
    span.longitudeDelta = delta;      //1经度=85.276公里
    
    MACoordinateRegion region;
    region.center   = coor;
    region.span     = span;
    
    [_mapView setRegion:region animated:animated];
}

#pragma mark - SDCSegmented Delegate
- (void)SDCSegmentControlClickedIndex:(NSInteger)index
{
    if (index == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mainRentView.center = CGPointMake(kScreenWidth*0.5, self.mainRentView.center.y);
            self.mainShareView.center = CGPointMake(kScreenWidth*1.5, self.mainShareView.center.y);
        } completion:^(BOOL finished) {
            [self.mainShareView removeAllChildren];
        }];
    }else
    {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mainRentView.center = CGPointMake(-kScreenWidth*0.5, self.mainRentView.center.y);
            self.mainShareView.center = CGPointMake(kScreenWidth*0.5, self.mainShareView.center.y);
        } completion:^(BOOL finished) {
            [self.mainShareView reloadData];
        }];
    }
}

#pragma mark - layzLoad
- (UIButton *)bannerBtn
{
    if (!_bannerBtn) {
        _bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bannerBtn.frame = CGRectMake(10.0, 15.0+64.0, kScreenWidth-20.0,(kScreenWidth-20.0)*(75.0/338.0));
        
        [_bannerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:kUrlBannerImage] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSString*key=[[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
            
            [[SDImageCache sharedImageCache]removeImageForKey:key withCompletion:^{
            }];
        }];
        [_bannerBtn addTarget:self action:@selector(bannerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bannerBtn;
}

- (TopBannerView *)topBannerView
{
    if (!_topBannerView) {
        _topBannerView = [[TopBannerView alloc] initWithViewModel:self.topBannerViewModel];
        _topBannerView.status = TopBannerViewStatusMonth;
    }
    return _topBannerView;
}

- (UIButton *)coinShareBtn
{
    if (!_coinShareBtn) {
        _coinShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coinShareBtn.hidden = YES;
        [_coinShareBtn setImage:UIImageName(@"ic_coin_share") forState:UIControlStateNormal];
        [_coinShareBtn addTarget:self action:@selector(coinShareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coinShareBtn;
}

- (TopBannerViewModel *)topBannerViewModel
{
    if (!_topBannerViewModel) {
        _topBannerViewModel = [[TopBannerViewModel alloc] init];
    }
    return _topBannerViewModel;
}

- (HintRentView *)hintRentView
{
    if (!_hintRentView) {
        _hintRentView = [[HintRentView alloc] initWithViewModel:self.hintRentViewModel];
        _hintRentView.hidden = YES;
    }
    return _hintRentView;
}

- (HintRentViewModel *)hintRentViewModel
{
    if (!_hintRentViewModel) {
        _hintRentViewModel = [[HintRentViewModel alloc] init];
    }
    return _hintRentViewModel;
}

- (SDCSegmentedcontrol *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[SDCSegmentedcontrol alloc] initWithIems:@[@"即用",@"即享"]];
        _segmentedControl.frame = CGRectMake(0.0, 0.0, 170.0, 32.0);
        _segmentedControl.delegate = self;
        _segmentedControl.layer.cornerRadius = 16.0;
        _segmentedControl.layer.masksToBounds = YES;
        
        _segmentedControl.selectedColor = UIColorFromRGB(241, 81, 61);
        _segmentedControl.normalColor = [UIColor whiteColor];
        
        _segmentedControl.titleSelectedColor = [UIColor whiteColor];
        _segmentedControl.titleNoramlColor = [UIColor blackColor];
        
        _segmentedControl.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kSelectedIndex];
        
        [self SDCSegmentControlClickedIndex:_segmentedControl.selectedIndex];
    }
    return _segmentedControl;
}

- (UIView *)mainRentView
{
    if (!_mainRentView) {
        _mainRentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight)];
    }
    return _mainRentView;
}

- (MainShareView *)mainShareView
{
    if (!_mainShareView) {
        _mainShareView = [[MainShareView alloc] initWithFrame:CGRectMake(kScreenWidth,64.0, kScreenWidth, kScreenHeight-64.0)];
    }
    return _mainShareView;
}
@end
