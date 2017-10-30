//
//  TabShareView.m
//  JoyMove
//
//  Created by Soda on 2017/10/12.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TabShareView.h"
#import "TabShareViewModel.h"
#import "JoyMove-Swift.h"

#import "UILabel+Extension.h"
#import "UIWindow+Visible.h"

#import "MyCar.h"
#import "RewardRecordModel.h"

#import "PayViewModel.h"

#import "SDCSwitch.h"

#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)

@import SevenSwitch;
@interface TabShareView()<UIGestureRecognizerDelegate>
{
    NSDictionary *_allMissionDictionary;
    NSMutableArray *_allMessages;
}

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBottomSpace;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgVHeight;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *smallCarImgV;
@property (weak, nonatomic) IBOutlet UILabel *carStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *earnLbl;
@property (weak, nonatomic) IBOutlet UIButton *classBtn;
@property (weak, nonatomic) IBOutlet UIButton *missionBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *renewBtn;

@property (strong, nonatomic) SDCSwitch *switchBtn;

@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *redPacketBtn;

@property (strong, nonatomic) UILabel *statusLbl;

@property (strong, nonatomic) TabShareViewModel *viewModel;
@property (strong, nonatomic) PayViewModel *payViewModel;
@end

@implementation TabShareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"TabShareView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        _allMessages = [[NSMutableArray alloc] init];
        [self sdc_setupViews];
        [self sdc_bindViewModel];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (!self.bottomBarView.hidden) {
        self.scrollBottomSpace.constant = 45.0;
    }
    
    float height = kScreenWidth*self.topImgVHeight.constant/375.0;
    self.topImgVHeight.constant = height;
    self.scrollViewHeight.constant = self.topImgVHeight.constant+self.middleView.frame.size.height+self.missionBtn.frame.size.height+40.0+240.0;
}

- (void)sdc_setupViews
{
     [self.middleView addSubview:self.switchBtn];
    //顶端图片
    [self.topImgV sd_setImageWithURL:[NSURL URLWithString:[MyCar shareIntance].car_img_l] placeholderImage:self.topImgV.image options:SDWebImageCacheMemoryOnly];
    
    [self.smallCarImgV sd_setImageWithURL:[NSURL URLWithString:[MyCar shareIntance].car_img_s] placeholderImage:self.topImgV.image options:SDWebImageCacheMemoryOnly];
    
    //小红点
    self.circleView.hidden = YES;
    self.circleView.center = CGPointMake(self.missionBtn.frame.size.width*0.7, self.missionBtn.frame.size.height*0.3);
    [self.missionBtn addSubview:self.circleView];
    
    NSString *totalMoney = @"0.00元";
    NSString *earnMoney = [NSString stringWithFormat:@"其中本月赚取0.00元"];
    self.earnLbl.text = [NSString stringWithFormat:@"%@\n%@",totalMoney,earnMoney];
    [self.earnLbl changeColor:UIColorFromRGB(109.0, 109.0, 109.0) font:UIFontFromSize(12) lineSpace:8.0 noteString:earnMoney];
    
    self.classBtn.layer.cornerRadius = 8.0;
    self.missionBtn.layer.cornerRadius = 8.0;
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.redPacketBtn];
    
    //您的包月车辆已快到期，再次续租仅需1000.00元。（原价2100.00元-账户余额1100.00元）
    self.bottomBarView.hidden = YES;
    
    self.renewBtn.layer.cornerRadius = 5.0;
    
    if ([MyCar shareIntance].licenseNum) {   //已分配车辆
        
        
        NSString *licenseNum = [MyCar shareIntance].licenseNum;
        double days = [MyCar shareIntance].expireTime-[MyCar shareIntance].serverTime;
        days =  days/1000/60/60/24;
        if (days <= 0) {
            days = 0;
        }
        NSInteger temp = ceil(days);
        NSString *daysString = [NSString stringWithFormat:@"剩余:%ld天",(long)temp];
        self.carInfoLbl.text = [NSString stringWithFormat:@"%@\n%@",licenseNum,daysString];
        [self.carInfoLbl changeFont:UIFontFromSize(14) noteString:daysString];
        
        if ([MyCar shareIntance].isFree) {
            self.carStatusLbl.text = @"空闲中";
        }else
        {
            self.carStatusLbl.text = @"租用中";
        }
        
        if ([MyCar shareIntance].isShare == 0) {
            self.switchBtn.isOn = NO;
        }else
        {
            self.switchBtn.isOn = YES;
        }
        [self.switchBtn updateStatus];
        
    }else  //未分配车辆
    {
        self.smallCarImgV.hidden = YES;
        self.carStatusLbl.hidden = YES;
        self.carInfoLbl.hidden = YES;
        self.switchBtn.hidden = YES;
        
        [self.middleView addSubview:self.statusLbl];
        
        [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(@0);
            make.height.equalTo(@80.0);
            
        }];
    }
    
    double leftdays = [MyCar shareIntance].expireTime-[MyCar shareIntance].serverTime;
    leftdays =  leftdays/1000/60/60/24;
    if (leftdays > 0 && leftdays < 7) {
        self.bottomBarView.hidden = NO;
        self.myScrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height-45.0);
        
        [self.payViewModel.balanceCommand execute:nil];
        [self.payViewModel.checkPackageCommand execute:nil];

    }else
    {
        self.bottomBarView.hidden = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) {
        @strongify(self)
        CGPoint point = [tap locationInView:self.middleView];
        if (CGRectContainsPoint(CGRectMake(0.0,0.0 , kScreenWidth, 80.0), point)) {
            UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MyCar" actionName:@"myCarViewController" params:nil];
            [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }else if (CGRectContainsPoint(CGRectMake(0.0,81.0 , kScreenWidth, 80.0), point))
        {
            
            UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"BalanceDetail" actionName:@"balanceDetailViewController" params:nil];
            [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.middleView addGestureRecognizer:tap];
}

- (void)sdc_bindViewModel
{
   //2、查询任务  3、查询余额  4、查询消息
    [self.viewModel.messageCommand execute:nil];
    [self.viewModel.missionCommand execute:nil];
    [self.viewModel.checkBalanceCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.messageSubject subscribeNext:^(NSArray *array) {
        @strongify(self)
        if (array> 0) {//显示任务
            [self showMessage:array];
        }else //显示新手红包
        {
            self.redPacketBtn.hidden = NO;
        }
    }];
    
    [self.viewModel.missionSubject subscribeNext:^(NSDictionary *params) {
       @strongify(self)
        _allMissionDictionary = params;
        if ([params[@"pendingNum"] integerValue] > 0) { //有新任务，显示红点
            self.circleView.hidden = NO;
        }else
        {
            self.circleView.hidden = YES;
        }
    }];
    
    [self.viewModel.successSubject subscribeNext:^(NSDictionary *params) {
        @strongify(self)
        double balance = [params[@"shareRevenue"] doubleValue];
        double monthRevenue = [params[@"currentMonthRevenue"] doubleValue];
        NSString *totalMoney = [NSString stringWithFormat:@"%.2f元",balance];
        NSString *earnMoney = [NSString stringWithFormat:@"其中本月赚取%.2f元",monthRevenue];
        self.earnLbl.text = [NSString stringWithFormat:@"%@\n%@",totalMoney,earnMoney];
        [self.earnLbl changeColor:UIColorFromRGB(109.0, 109.0, 109.0) font:UIFontFromSize(12) lineSpace:8.0 noteString:earnMoney];
    }];
    
   
    
    RACSignal *zipSigal = [self.payViewModel.balanceSubject zipWith:self.payViewModel.allPackageSubject];
    [zipSigal subscribeNext:^(id x) {
        RACTuple *tuple = x;
        
        
        for (NSDictionary *response in tuple.allObjects) {
            if (![response isEqual:[NSNull null]]) {
                double price = [response[@"balance"] doubleValue];
                float needPay = [response[@"balance"] doubleValue]-[UserData share].balance;
                needPay = needPay<=0.0?0.0:needPay;
                NSString *priceString = [NSString stringWithFormat:@"%.2f元",price];
                NSString *insString = [NSString stringWithFormat:@"（原价%.2f元,账户余额%.2f元）",price,[UserData share].balance];
                NSString *allString = [NSString stringWithFormat:@"您的包月车辆已快到期，再次续租仅需%@。%@",priceString,insString];
                NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:allString];
                NSRange redRange2 = NSMakeRange([[noteStr2 string] rangeOfString:priceString].location, [[noteStr2 string] rangeOfString:priceString].length);
                NSRange redRange3 = NSMakeRange([[noteStr2 string] rangeOfString:insString].location, [[noteStr2 string] rangeOfString:insString].length);
                [noteStr2 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(241, 81, 61) range:redRange2];
                [noteStr2 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(51, 51, 51) range:redRange3];
                [self.priceLbl setAttributedText:noteStr2];
            }
        }
    }];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SDCSwitch"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - private
- (void)showMessage:(NSArray *)items
{
    if (items.count <= 0) {
        self.redPacketBtn.hidden = NO;
        return;
    }
    
    [_allMessages removeAllObjects];
    for (NSDictionary *dict in items) {
        RewardRecordModel *model = [[RewardRecordModel alloc] initWithParams:dict];
        [_allMessages addObject:model];
    }
    
    UIImageView *titleImgV = [[UIImageView alloc] initWithImage:UIImageName(@"rewards_record")];
    
    titleImgV.frame = CGRectMake((self.frame.size.width-titleImgV.frame.size.width)*0.5, 0.0, titleImgV.frame.size.width, titleImgV.frame.size.height);
    if(kIphone4 || kIphone5)
    {
        titleImgV.frame = CGRectMake((self.frame.size.width-titleImgV.frame.size.width*kScreenWidth/375.0)*0.5, 0.0, titleImgV.frame.size.width*kScreenWidth/375.0, titleImgV.frame.size.height*kScreenWidth/375.0);
    }
    [self.bottomView addSubview:titleImgV];
    
    NSInteger total = items.count>=3?3:items.count;
    NSString *name = [NSString stringWithFormat:@"message_%lu",total];
    
    UIImage *messageBgImg = UIImageName(name);
    UIImageView *bg = [[UIImageView alloc] initWithImage:messageBgImg];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake((self.frame.size.width-bg.frame.size.width)*0.5, titleImgV.frame.size.height-2, bg.frame.size.width, bg.frame.size.height);
    if(kIphone4 || kIphone5)
    {
        bg.frame = CGRectMake((self.frame.size.width-bg.frame.size.width*kScreenWidth/375.0)*0.5, titleImgV.frame.size.height-2, bg.frame.size.width*kScreenWidth/375.0, bg.frame.size.height*kScreenWidth/375.0);
    }
    
    [self.bottomView addSubview:bg];
    for (int i = 0; i < total; i++) {
        NSDictionary *dict = items[i];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 12.0+45.0*i, 150.0, 45.0)];
        if(kIphone4 || kIphone5)
        {
            titleLbl.frame = CGRectMake(25.0*kScreenWidth/375.0, (12.0+45.0*i)*kScreenWidth/375.0, 150.0*kScreenWidth/375.0, 45.0*kScreenWidth/375.0);
        }
        titleLbl.text = dict[@"taskName"];
        titleLbl.font = UIFontFromSize(14.0);
        titleLbl.textColor = [UIColor whiteColor];
        [bg addSubview:titleLbl];
        
        UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(bg.frame.size.width-100.0-25.0, 12.0+45.0*i, 100.0, 45.0)];
        if(kIphone4 || kIphone5)
        {
            contentLbl.frame = CGRectMake(bg.frame.size.width-(100.0+25.0)*kScreenWidth/375.0, (12.0+45.0*i)*kScreenWidth/375.0, 100.0*kScreenWidth/375.0, 45.0*kScreenWidth/375.0);
        }
        contentLbl.text = [NSString stringWithFormat:@"+%.1f元",[dict[@"balance"] floatValue]];
        contentLbl.textAlignment = NSTextAlignmentRight;
        contentLbl.font = UIFontFromSize(14.0);
        contentLbl.textColor = [UIColor whiteColor];
        [bg addSubview:contentLbl];
        
        if (i == total-1) {
            UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            detailBtn.alpha = 0.75;
            [detailBtn setTitle:@"点击查看全部" forState:UIControlStateNormal];
            detailBtn.titleLabel.textColor = [UIColor whiteColor];
            detailBtn.titleLabel.font = UIFontFromSize(12.0);
            detailBtn.frame = CGRectMake(0.0, contentLbl.frame.size.height+contentLbl.frame.origin.y, bg.frame.size.width, 36.0);
            [detailBtn addTarget:self action:@selector(messageDetailAction) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:detailBtn];
        }
    }
}

#pragma mark - event response

- (void)getRedPacketMoney
{
    if (_allMissionDictionary) {
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"Mission" actionName:@"missionViewController" params:@{@"mission":_allMissionDictionary}];
        [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)messageDetailAction
{
    if (_allMessages) {
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"BalanceDetail" actionName:@"balanceDetailViewController" params:@{@"isMessage":@YES,@"data":_allMessages}];
        [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)renewAction:(id)sender {
    UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"MyCar" actionName:@"myCarViewController" params:nil];
    [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
- (IBAction)missAction:(id)sender {
    
    if (_allMissionDictionary) {
        UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"Mission" actionName:@"missionViewController" params:@{@"mission":_allMissionDictionary}];
        [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)sodaClassAction:(id)sender {
    UIViewController *vc = [[CTMediator sharedInstance] CTMediator_viewControllerTarget:@"SodaClass" actionName:@"sodaClassViewController" params:nil];
    [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazyLoad
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.missionBtn.frame.size.height+self.missionBtn.frame.origin.y+20.0, self.frame.size.width, 240.0)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
    
}

- (UIButton *)redPacketBtn
{
    if (!_redPacketBtn) {
        _redPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redPacketBtn.frame = CGRectMake((self.frame.size.width-146.0)*0.5, 0.0, 146.0, 177.0);
        [_redPacketBtn setImage:UIImageName(@"red_packet") forState:UIControlStateNormal];
        [_redPacketBtn addTarget:self action:@selector(getRedPacketMoney) forControlEvents:UIControlEventTouchUpInside];
        _redPacketBtn.hidden = YES;
    }
    return _redPacketBtn;
}

- (UILabel *)statusLbl
{
    if (!_statusLbl) {
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.font = UIFontFromSize(14.0);
        _statusLbl.textColor = UIColorFromSixteenRGB(0x272727);
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl.text = @"支付成功，正在分配车辆...";
    }
    return _statusLbl;
}

- (TabShareViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[TabShareViewModel alloc] init];
    }
    return _viewModel;
}

- (PayViewModel *)payViewModel
{
    if (!_payViewModel) {
        _payViewModel = [[PayViewModel alloc] init];
    }
    return _payViewModel;
}

- (UIView *)circleView
{
    if (!_circleView) {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
        _circleView.backgroundColor = [UIColor redColor];
        _circleView.layer.cornerRadius = 5.0;
        _circleView.layer.masksToBounds = YES;
    }
    return _circleView;
}

- (SDCSwitch *)switchBtn
{
    if (!_switchBtn) {
        CGSize size =  CGSizeMake(130.0*kScreenWidth/375.0, 40.0*kScreenWidth/375.0);
        _switchBtn= [[SDCSwitch alloc] initWithFrame:CGRectMake(self.frame.size.width-20.0-size.width, (80.0-size.height)*0.5, size.width, size.height)];
    }
    return _switchBtn;
}
@end
