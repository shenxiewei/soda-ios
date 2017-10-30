//
//  CarDetailsView.m
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CarDetailsView.h"
#import "POIDefine.h"
#import "Macro.h"
#import "TimeLabel.h"
#import "WebViewController.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CLGeocoder.h>

#import "ShowPictureViewController.h"
#import "UIWindow+Visible.h"

@interface CarDetailsView () {
    
    UIImageView *_backgroundImageView;
    UIImageView *_arrowImageView;
    UILabel *_despLabel;
    UILabel *_distanceLabel;
    UILabel *_locationLabel;
    UILabel *_floorLabel;
    //TimeLabel *_etaLabel;
    UILabel *_brandLabel;
    UIImageView *_batteryImageView;
    UILabel *_batteryLabel;
//    // 计费标准label
//    UILabel *_priceLabel;
    UIButton *_priceRuleBtn;
    
    UIImageView *_typeImageView;
    UIImageView *_bluetoothImageView;
    UIImageView *_photoImageView;
    UIImageView *_estimatedMileageImageView;
    
    UIButton *_walkingButton;
    UIButton *_goButton;
    UIButton *_rentButton;
    
    // logo ImageView
    UIImageView *_logo;
    
    NSMutableArray *parkPhotos;
    // 用车距离
    double _nearTheCarDistance;
    BOOL isUp;
    BOOL canUp;
}

@end

@implementation CarDetailsView

#define     carDetailsViewWidth     kScreenWidth
const float carDetailsB1Height      = 78;
const float carDetailsB2Height      = 280;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        parkPhotos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initUI {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:upSwipe];
    [self addGestureRecognizer:downSwipe];
    
    //背景图
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, carDetailsViewWidth, carDetailsB1Height+carDetailsB2Height)];
    _backgroundImageView.backgroundColor = [UIColor whiteColor];
    _backgroundImageView.alpha = 0.95;
    [self addSubview:_backgroundImageView];
    _backgroundImageView.userInteractionEnabled = YES;
    
    //箭头
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-17.5)/2, 3, 17.5, 10)];
    [_backgroundImageView addSubview:_arrowImageView];
    
    /* B1区域 */
    // 车队logo
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(23.0 / 375 * kScreenWidth, 5, 28, 28)];
    
    //描述（车牌号）
    _despLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logo.frame) + 7, 0, 238.5 / 375 * kScreenWidth, 38.5)];
    _despLabel.font = UIFontFromSize(18);
    _despLabel.adjustsFontSizeToFitWidth = YES;
    _despLabel.textColor = UIColorFromRGB(81, 81, 81);
    [_backgroundImageView addSubview:_despLabel];
    
    // 分割线1
    UIView *lineOne = [[UIView alloc] init];
    lineOne.frame = CGRectMake(_logo.frame.origin.x, 38.5, 238.5 / 375 * kScreenWidth, 0.5);
    lineOne.backgroundColor = UIColorFromSixteenRGB(0xe1e1e1);
    [_backgroundImageView addSubview:lineOne];
    
    UIImageView *locationLogo = [[UIImageView alloc] initWithImage:UIImageName(@"park")];
    locationLogo.frame = CGRectMake(_logo.frame.origin.x, 51.5, 13,13);
    [_backgroundImageView addSubview:locationLogo];
    //位置
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logo.frame.origin.x+17, 38.5, 238.5 / 375 * kScreenWidth, 39)];
    _locationLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    _locationLabel.font = UIFontFromSize(15);
    _locationLabel.textColor = UIColorFromRGB(81, 81, 81);
    _locationLabel.alpha = .6f;
    _locationLabel.text = @"暂无信息";
   // _locationLabel.adjustsFontSizeToFitWidth = YES;
    [_backgroundImageView addSubview:_locationLabel];
    
    UIImageView *floorLogo = [[UIImageView alloc] initWithImage:UIImageName(@"floor")];
    floorLogo.frame = CGRectMake(_logo.frame.origin.x, 80, 13,13);
    [_backgroundImageView addSubview:floorLogo];
    
    _floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logo.frame.origin.x+17, 67, 238.5 / 375 * kScreenWidth, 39)];
    _floorLabel.font = UIFontFromSize(15);
    _floorLabel.textColor = UIColorFromRGB(81, 81, 81);
    _floorLabel.alpha = .6f;
    _floorLabel.text = @"暂无信息";
    _floorLabel.adjustsFontSizeToFitWidth = YES;
    [_backgroundImageView addSubview:_floorLabel];
    
    // 分割线2
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.frame = CGRectMake(0, 102, carDetailsViewWidth, 0.5);
    lineTwo.backgroundColor = UIColorFromSixteenRGB(0xe1e1e1);
    [_backgroundImageView addSubview:lineTwo];
    
    /* 预计到达时间：当前版本不支持接力车
    _etaLabel = [[TimeLabel alloc] init];
    _etaLabel.style = TLStyleCarDetailsView;
    _etaLabel.font = UIFontFromSize(12);
    _etaLabel.textColor = UIColorFromRGB(81, 81, 81);
    _etaLabel.alpha = .6f;
    _etaLabel.frame = CGRectMake(16.5f, 53, carDetailsViewWidth-carDetailsViewHeight-10, 15);
    [_backgroundImageView addSubview:_etaLabel];
     */
    
    //租用按钮
    _rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rentButton.frame = CGRectMake(CGRectGetMaxX(lineOne.frame) + 18, 22.5, 71.5, 34);
    _rentButton.tag = CDVTagUnlock;
    _rentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _rentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _rentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [_rentButton setTitle:NSLocalizedString(@"Rent", nil) forState:UIControlStateNormal];
    [_rentButton setBackgroundImage:[UIImage imageNamed:@"carDetailsButton"] forState:UIControlStateNormal];
    [_rentButton setImage:[UIImage imageNamed:@"carDetailsButtonRent"] forState:UIControlStateNormal];
    [_rentButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_rentButton];
    _rentButton.hidden = YES;

    
    //步行导航按钮
    _walkingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _walkingButton.frame = CGRectMake(CGRectGetMaxX(lineOne.frame) + 18, 22.5, 71.5, 34);
    _walkingButton.tag = CDVTagWalking;
    _walkingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _walkingButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _walkingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [_walkingButton setTitle:NSLocalizedString(@"Walk", nil) forState:UIControlStateNormal];
    [_walkingButton setBackgroundImage:[UIImage imageNamed:@"carDetailsButton"] forState:UIControlStateNormal];
    [_walkingButton setImage:[UIImage imageNamed:@"carDetailsButtonWalking"] forState:UIControlStateNormal];
    [_walkingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_walkingButton];
    _walkingButton.hidden = YES;
    
    //前往按钮
    _goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goButton.frame = CGRectMake(CGRectGetMaxX(lineOne.frame) + 18, 22.5, 71.5, 34);
    _goButton.tag = CDVTagGo;
    _goButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _goButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _goButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [_goButton setTitle:NSLocalizedString(@"Go", nil) forState:UIControlStateNormal];
    [_goButton setBackgroundImage:[UIImage imageNamed:@"carDetailsButton"] forState:UIControlStateNormal];
    [_goButton setImage:[UIImage imageNamed:@"carDetailsButtonGo"] forState:UIControlStateNormal];
    [_goButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_goButton];
    _goButton.hidden = YES;
    
    /* B2区域 */
    //品牌
    UIImageView *brandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0 / 375 * kScreenWidth, 111+10.0, 13, 12.5)];
    brandImageView.image = UIImageName(@"carDetailsBrand");
    [_backgroundImageView addSubview:brandImageView];
    
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(brandImageView.frame) + 10, 111+10.0, 150.0 / 375 * kScreenWidth, 15)];
    _brandLabel.font = UIFontFromSize(15);
    _brandLabel.textColor = UIColorFromRGB(156, 156, 156);
    _brandLabel.adjustsFontSizeToFitWidth= YES;
    [_backgroundImageView addSubview:_brandLabel];
    
    //电量（或油量）
    _batteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26.0 / 375 * kScreenWidth, 149.5+10.0, 6.5, 14.5)];
    [_backgroundImageView addSubview:_batteryImageView];
    
    _batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_batteryImageView.frame) + 14, 149.5+10.0, _brandLabel.frame.size.width, 15)];
    _batteryLabel.font = UIFontFromSize(15);
    _batteryLabel.textColor = UIColorFromRGB(156, 156, 156);
    [_backgroundImageView addSubview:_batteryLabel];
    
    //距离
    _estimatedMileageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26.5 / 375 * kScreenWidth, 187.5+10.0, 8.5, 12)];
    _estimatedMileageImageView.image = UIImageName(@"carDetailsEstimatedMileage");
    [_backgroundImageView addSubview:_estimatedMileageImageView];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_estimatedMileageImageView.frame) + 12, 187+10.0, _brandLabel.frame.size.width, 15)];
    _distanceLabel.font = UIFontFromSize(15);
    _distanceLabel.textColor = UIColorFromRGB(156, 156, 156);
    [_backgroundImageView addSubview:_distanceLabel];
    
    //照片
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(213.0 / 375 * kScreenWidth, 110+10.0, 124.5, 88)];
    _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _photoImageView.clipsToBounds = YES;
    [_backgroundImageView addSubview:_photoImageView];
    
//    // 计费标准label
//    _priceLabel = [[UILabel alloc] init];
//    _priceLabel.adjustsFontSizeToFitWidth = YES;
//    _priceLabel.frame = CGRectMake(_photoImageView.frame.origin.x - 5, CGRectGetMaxY(_photoImageView.frame), 140, 15);
//    _priceLabel.font = UIFontFromSize(12);
//    _priceLabel.textColor = UIColorFromRGB(156, 156, 156);
//    [_backgroundImageView addSubview:_priceLabel];
    
    UIButton *clickBtn = [[UIButton alloc] init];
    clickBtn.frame = CGRectMake(213.0 / 375 * kScreenWidth, 110+10.0, 124.5, 108);
    clickBtn.tag = CDVTagRule;
    [_backgroundImageView addSubview:clickBtn];
    [clickBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    _priceRuleBtn = [[UIButton alloc] init];
    _priceRuleBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_priceRuleBtn setTitleColor:UIColorFromSixteenRGB(0xf87a63) forState:UIControlStateNormal];
    [_priceRuleBtn setTitleColor:UIColorFromRGB(147, 58, 60) forState:UIControlStateHighlighted];
    _priceRuleBtn.backgroundColor = [UIColor whiteColor];
    _priceRuleBtn.layer.cornerRadius = 10;
    _priceRuleBtn.layer.borderWidth = 0.8;
    _priceRuleBtn.layer.borderColor = UIColorFromSixteenRGB(0xf87a63).CGColor;
    _priceRuleBtn.layer.masksToBounds = YES;
    _priceRuleBtn.tag = CDVTagRule;
    [_priceRuleBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_priceRuleBtn];
    
    // 分割线3
    UIView *lineThree = [[UIView alloc] init];
    lineThree.frame = CGRectMake(0, 250, carDetailsViewWidth, 0.5);
    lineThree.backgroundColor = UIColorFromSixteenRGB(0xe1e1e1);
    [_backgroundImageView addSubview:lineThree];
    
    CGSize size = CGSizeMake(105.0*375.0/kScreenWidth, 79.0*375.0/kScreenWidth);
    float originX = (kScreenWidth-size.width*3-10.0)*0.5;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        btn.frame = CGRectMake(originX+(size.width+5.0)*i, 265, size.width, size.height);
        [btn addTarget:self action:@selector(checkDetailPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:btn];
        [parkPhotos addObject:btn];
    }

//    //类型提示图
//    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(carDetailsViewWidth/2-32, carDetailsB1Height+carDetailsB2Height-32+5, 32, 32)];
//    [_backgroundImageView addSubview:_typeImageView];
//    
//    //蓝牙提示图
//    _bluetoothImageView = [[UIImageView alloc] initWithFrame:CGRectMake(carDetailsViewWidth/2, carDetailsB1Height+carDetailsB2Height-32+5, 32, 32)];
//    _bluetoothImageView.image = UIImageName(@"carDetailsBluetooth");
//    [_backgroundImageView addSubview:_bluetoothImageView];
//    _bluetoothImageView.hidden = YES;
}

/* 设置UI
 * 远离汽车时:显示步行导航和预订按钮
 * 在汽车附近时:显示鸣笛和租用按钮*/
- (void)updateUI {
    for (UIButton *btn in parkPhotos) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    _floorLabel.text  = @"暂无信息";
    if (self.poiModel.carId) {
        [LXRequest requestWithJsonDic:@{@"carId":self.poiModel.carId} andUrl:kURL(kE2EUrlGetCarParkInfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
            if (success) {
                if (result == JMCodeSuccess) {
                    NSArray *phtots = response[@"photos"];
                    _floorLabel.text = response[@"floor"];
                    NSString *name = response[@"name"];
                    if (!kIsNSNull(name)) {
                        _locationLabel.text = response[@"name"];
                    }else
                    {
                        [self getCurrentAddress];
                    }
                    for (int i = 0 ;i < phtots.count;i++ ) {
                        UIButton *temp = parkPhotos[i];
                        NSString *url = phtots[i];
                        [temp sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (error) {
                                [temp setImage:UIImageName(@"load_failed") forState:UIControlStateNormal];
                            }
                        }];
                    }
                }else if (result == JMCodeNoData)
                {
                    [self getCurrentAddress];
                }
            }else
            {
                [self getCurrentAddress];
            }
        }];
    }
    
    // 动态设置用车距离
    NSString *distanceString = [Tool getCache:@"RENT_DISTANCE_LIMIT"];
    _nearTheCarDistance = [distanceString doubleValue];
    
    _despLabel.hidden = YES;
    _distanceLabel.hidden = YES;
    _locationLabel.hidden = YES;
    //_etaLabel.hidden = YES;
    _walkingButton.hidden = YES;
    _rentButton.hidden = YES;
    _goButton.hidden = YES;
    _estimatedMileageImageView.hidden = NO;
    
//    UIImage *whiteImage = [UIImage imageNamed:@"carDetailsWhite"];

    if (POITypeCar == self.poiModel.type) {
        
        canUp = YES;
        _arrowImageView.hidden = NO;
        _despLabel.hidden = NO;
        _distanceLabel.hidden = NO;
        _locationLabel.hidden = NO;

        if (self.distance<=0) {     //未获取到用户位置
            
            ;
        }else if (self.distance > _nearTheCarDistance) {
           
            _walkingButton.hidden = NO;
        }else {
            
            _rentButton.hidden = NO;
        }
    }else if (POITypeParks == self.poiModel.type) {
        
        canUp = NO;
        _despLabel.hidden = NO;
        _locationLabel.hidden = NO;
        _arrowImageView.hidden = YES;
        _goButton.hidden = NO;
//        whiteImage = [UIImage imageNamed:@"carDetailsWhite"];
        
    }else if (POITypePowerBars == self.poiModel.type) {
        
        canUp = NO;
        _arrowImageView.hidden = YES;
        _goButton.hidden = NO;
//        whiteImage = [UIImage imageNamed:@"carDetailsWhite"];
        _despLabel.hidden = NO;
        _distanceLabel.hidden = NO;
        _locationLabel.hidden = NO;
    }else if (POITypeStop == self.poiModel.type) {
        
        canUp = NO;
        _arrowImageView.hidden = YES;
        _goButton.hidden = NO;
//        whiteImage = [UIImage imageNamed:@"carDetailsWhite"];
        _despLabel.hidden = NO;
        _distanceLabel.hidden = NO;
        _locationLabel.hidden = NO;
    }else if (POITypeMe == self.poiModel.type) {
        
        canUp = NO;
        _arrowImageView.hidden = YES;
//        whiteImage = [UIImage imageNamed:@"carDetailsWhite"];
        _despLabel.hidden = NO;
        //_distanceLabel.hidden = NO;
        _locationLabel.hidden = NO;
    }else if (POITypeGroup == self.poiModel.type) {
        
        canUp = NO;
        _arrowImageView.hidden = YES;
        _despLabel.hidden = NO;
        //_distanceLabel.hidden = NO;
        _locationLabel.hidden = NO;
    }else if (POITypeDriving == self.poiModel.type) {
        
        canUp = YES;
        _arrowImageView.hidden = NO;
//        whiteImage = [UIImage imageNamed:@"carDetailsWhite"];
        _despLabel.hidden = NO;
        _distanceLabel.hidden = YES;
        _locationLabel.hidden = NO;
        _estimatedMileageImageView.hidden = YES;
    }else {
        
        ;
    }
//    whiteImage = [whiteImage stretchableImageWithLeftCapWidth:160 topCapHeight:10];
//    _backgroundImageView.image = whiteImage;
    
    _despLabel.text = self.poiModel.desp;
    if (POITypePowerBars == self.poiModel.type) {
        
        _despLabel.text = [NSString stringWithFormat:@"%@（快充%ld个，慢充%ld个）",self.poiModel.operator,self.poiModel.fastChargeNum,self.poiModel.slowChargeNum];
    }
    
    /*
    if (POITypeCar==self.poiModel.type) {   //未租用的车牌号，只显示后两位
     
        if (self.poiModel.desp.length) {
            
            NSMutableString *mutableString = [@"" mutableCopy];
            for (NSInteger i=0; i<self.poiModel.desp.length-2; i++) {
                
                [mutableString appendString:@"*"];
            }
            NSString *text = [self.poiModel.desp substringWithRange:NSMakeRange(self.poiModel.desp.length-2, 2)];
            [mutableString appendString:text];
            
            _despLabel.text = mutableString;
        }
    }else {
        
        _despLabel.text = self.poiModel.desp;
    }
     */
    
    if (self.distance<=0) {     //未获取到用户位置
        
        _distanceLabel.text = NSLocalizedString(@"Can not get to your location", nil);
    }else if (self.distance < 1000) {
        
        _distanceLabel.text = [NSString stringWithFormat:@"%@ %.0lf M", NSLocalizedString(@"距离", nil), self.distance];
    }else {
        
        _distanceLabel.text = [NSString stringWithFormat:@"%@ %.1lf KM", NSLocalizedString(@"距离", nil), self.distance/1000.f];
    }
    
    /*
    if (self.poiModel.eta) {
        
        [_etaLabel setTime:self.poiModel.eta/1000];
    }else {
        
        [_etaLabel stop];
    }
     */
    
    CLLocationDegrees latitude = self.poiModel.latitude;
    CLLocationDegrees longitude = self.poiModel.longitude;
    if (POITypeMe == self.poiModel.type) {
       
        latitude = self.poiModel.latitude;
        longitude = self.poiModel.longitude;
    }
    
    if (!_locationLabel.hidden) {
        
        if (POITypeDriving == self.poiModel.type) {
        
            _locationLabel.text = NSLocalizedString(@"Renting a car", nil);
        }else if (POITypeParks == self.poiModel.type) {
        
             _locationLabel.text = self.poiModel.addr;
        }else if ( POITypePowerBars == self.poiModel.type)
        {
           _locationLabel.text = self.poiModel.addr;
        }
        else {
        
        }
    }

    // 动态调整button title
    if ( self.poiModel.activityBtn) {
        [_priceRuleBtn setTitle:self.poiModel.activityBtn forState:UIControlStateNormal];
    }else{
        [_priceRuleBtn setTitle:NSLocalizedString(@"Charging rules", nil) forState:UIControlStateNormal];
    }
    [_priceRuleBtn.titleLabel sizeToFit];
    CGFloat btnW = _priceRuleBtn.titleLabel.width + 15;
    _priceRuleBtn.frame = CGRectMake(CGRectGetMinX(_photoImageView.frame) + (_photoImageView.width - btnW) * 0.5, CGRectGetMaxY(_photoImageView.frame) + 1+10.0, btnW, 20);
    
//    // 富文本修改计价文字颜色
//    NSString *priceString = [NSString stringWithFormat:@"￥%.2f/分钟+￥%.2f/公里", self.poiModel.timePrice, self.poiModel.mileagePrice];
//    
//    NSString *priceTime = [NSString stringWithFormat:@"%.2f", self.poiModel.timePrice];
//    NSString *priceMileage = [NSString stringWithFormat:@"%.2f", self.poiModel.mileagePrice];
//
//    NSMutableAttributedString *priceStringA = [[NSMutableAttributedString alloc] initWithString:priceString];
//    [priceStringA addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(19, 152, 235) range:NSMakeRange(0, priceTime.length + 1)];
//    [priceStringA addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(19, 152, 235) range:NSMakeRange(priceTime.length + 5 ,priceMileage.length + 1)];
//    _priceLabel.attributedText = priceStringA;
    
    _brandLabel.text = self.poiModel.carInfo;
    _batteryLabel.text = [NSString stringWithFormat:@"%.0f%\%", self.poiModel.powerPercent*100];
    
   [_photoImageView sd_setImageWithURL:[NSURL URLWithString:self.poiModel.imageUrl] placeholderImage:nil];
    if (!self.poiModel.powerType) {     //电动车
        
        UIImage *carType = UIImageName(@"carDetailsBattery");
        _batteryImageView.width = carType.size.width;
        _batteryImageView.height = carType.size.height;
        _batteryImageView.image = UIImageName(@"carDetailsBattery");
        _typeImageView.image = UIImageName(@"carDetailsElectricCar");
    }else if (1==self.poiModel.powerType) {     //油车
        
        UIImage *carType = UIImageName(@"carDetailsFuelCar");
        _batteryImageView.width = carType.size.width;
        _batteryImageView.height = carType.size.height;
        _batteryImageView.image = carType;
        _typeImageView.image = carType;
    }else {     //数据异常
        
        _batteryImageView.image = UIImageName(@"");
        _typeImageView.image = UIImageName(@"");
    }
    
    if (self.poiModel.ifBlueTeeth) {
        
        _bluetoothImageView.hidden = NO;
    }else {
        
        _bluetoothImageView.hidden = YES;
    }

    // 车队logo动态调整
    if (self.poiModel.logo.length) {
        
        _despLabel.frame = CGRectMake(CGRectGetMaxX(_logo.frame) + 7, 0, 238.5 / 375 * kScreenWidth, 38.5);
       [_logo sd_setImageWithURL:[NSURL URLWithString:self.poiModel.logo]];
        [_backgroundImageView addSubview:_logo];
        
    }else{
        
        _despLabel.frame = CGRectMake(23.0 / 375 * kScreenWidth, 0, 238.5 / 375 * kScreenWidth, 38.5);
        [_logo removeFromSuperview];
    }
}

+ (CGSize)size {
    
    return CGSizeMake(carDetailsViewWidth, carDetailsB1Height+carDetailsB2Height);
}

- (BOOL)isShow {
    
    return self.alpha;
}

- (void)show {
    
    if (![self isShow]) {
        [UIView animateWithDuration:.25f animations:^{
            
            float y;
            if (POITypeDriving==self.poiModel.type ||
                POITypeStop==self.poiModel.type ||
                POITypeParks==self.poiModel.type ||
                POITypePowerBars==self.poiModel.type) {
                
                if(self.isMoreUp){
                    
                    y = 50 + 20;
                }else{
                    y = 50;
                }
            }else {
                
                if(self.isMoreUp){
                    
                    y = 20;
                }else{
                    y = 0;
                }
            }
            self.alpha = 1;
            self.frame = CGRectMake(0, kScreenHeight-carDetailsB1Height-y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            
            isUp = NO;
            _arrowImageView.image = UIImageName(@"carDetailsArrow_up");
        }];
    }else {
        
        [self down];
    }
}

- (void)hide {
    
    //[_etaLabel stop];
    
    if ([self isShow]) {
        [UIView animateWithDuration:.25f animations:^{
            
            self.alpha = 0;
            self.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

- (void)up {
    
    if ([self isShow]&&canUp) {
        [UIView animateWithDuration:.25f animations:^{
            
            float y;
            if (POITypeDriving==self.poiModel.type ||
                POITypeStop==self.poiModel.type ||
                POITypeParks==self.poiModel.type ||
                POITypePowerBars==self.poiModel.type) {
                
                if(self.isMoreUp){
                    
                    y = 50 + 20;
                }else{
                    y = 50;
                }
            }else {
                
                if(self.isMoreUp){
                    
                    y = 20;
                }else{
                    y = 0;
                }
            }
            self.frame = CGRectMake(0, kScreenHeight-carDetailsB1Height-carDetailsB2Height-y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            
            isUp = YES;
            _arrowImageView.image = UIImageName(@"carDetailsArrow_down");
        }];
    }
}

- (void)down {
    
    if ([self isShow]) {
        [UIView animateWithDuration:.25f animations:^{
            
            float y;
            if (POITypeDriving==self.poiModel.type ||
                POITypeStop==self.poiModel.type ||
                POITypeParks==self.poiModel.type ||
                POITypePowerBars==self.poiModel.type) {
                
                if(self.isMoreUp){
                    
                    y = 50 + 20;
                }else{
                    y = 50;
                }
            }else {
                
                if(self.isMoreUp){
                    
                    y = 20;
                }else{
                    y = 0;
                }
            }
            self.frame = CGRectMake(0, kScreenHeight-carDetailsB1Height-y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            
            isUp = NO;
            _arrowImageView.image = UIImageName(@"carDetailsArrow_up");
        }];
    }
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedCarDetailsButtonAtIndex:)]) {
        
        [self.delegate clickedCarDetailsButtonAtIndex:button.tag];
    }
}

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)swipe {
 
    [self up];
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer *)swipe {
    
    [self down];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if (isUp) {
        
        [self down];
    }else {
        
        [self up];
    }
}

- (void)checkDetailPhoto:(UIButton *)button
{
    if (![button imageForState:UIControlStateNormal]) {
        return;
    }
    ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
    showPic.isFromFront = YES;
    showPic.isShowFullScreen = YES;
    [[[UIApplication sharedApplication].keyWindow visibleViewController].navigationController pushViewController:showPic animated:YES];
    showPic.image = [button imageForState:UIControlStateNormal];
}

#pragma mark - private
- (void)getCurrentAddress
{
                _locationLabel.text = @"";
    CLLocationDegrees latitude = self.poiModel.latitude;
    CLLocationDegrees longitude = self.poiModel.longitude;
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
    
                    CLPlacemark *mark = [placemark objectAtIndex:0];
                    NSMutableString *string = [mark.subLocality mutableCopy];
    
                    if (mark.thoroughfare) {
    
                        [string appendString:mark.thoroughfare];
                    }
                    if (mark.subThoroughfare) {
    
                        [string appendString:mark.subThoroughfare];
                    }
                    _locationLabel.text = string;
                }];
}
@end
