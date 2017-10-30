//
//  MyCarLocationCell.m
//  JoyMove
//
//  Created by Soda on 2017/9/18.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MyCarLocationCell.h"
#import "MyCar.h"
#import "UserData.h"
#import "SDCMapHelper.h"
#import "Config.h"

@interface MyCarLocationCell ()<AMapSearchDelegate,MAMapViewDelegate>

@property(nonatomic,strong)SDCMapHelper *mapHelper;
//@property(nonatomic,strong)UIImageView *arrowImgV;
@property(nonatomic,strong) UILabel *locationLbl;

//@property(nonatomic,strong) MAMapView *myMapView;
@end

@implementation MyCarLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.desLbl];
        [self.contentView addSubview:self.locationLbl];
       // [self.contentView addSubview:self.arrowImgV];
        //[self.contentView addSubview:self.myMapView];
        
        JMWeakSelf(self);
        [self.mapHelper startSearch:[MyCar shareIntance].lastCoord CompleteBlock:^(AMapReGeocodeSearchResponse *response) {
            weakself.locationLbl.text = [NSString stringWithFormat:@"%@%@%@%@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.streetNumber.street,response.regeocode.addressComponent.streetNumber.number];
        }];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    JMWeakSelf(self);
//    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
//        make.top.equalTo(weakself.contentView).with.offset(18.0);
//        make.right.equalTo(weakself.contentView).with.offset(-10.0);
//    }];
    
    [self.desLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200.0, 10.0));
        make.left.equalTo(weakself.contentView).with.offset(15.0);
        make.top.equalTo(weakself.contentView).with.offset(20.0);
    }];
    
    [self.locationLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300.0, 10.0));
        make.left.equalTo(weakself.contentView).with.offset(15.0);
        make.top.equalTo(weakself.desLbl.mas_bottom).with.offset(20.0);
    }];
    
//    [self.myMapView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@300.0);
//        make.left.equalTo(weakself.contentView).with.offset(0.0);
//        make.right.equalTo(weakself.contentView).with.offset(0.0);
//        make.top.equalTo(weakself.locationLbl.mas_bottom).with.offset(20.0);
//    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    
}
#pragma mark - getter & setter
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
//    if (_isOpen) {
//        self.arrowImgV.transform = CGAffineTransformMakeRotation(-M_PI/2);
//    }else
//    {
//        self.arrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
//    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])//车辆图钉
    {
        static NSString *pointReuseIndentifier = @"mycarpointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = UIImageName(@"zhgj_normal_ios");
        return annotationView;
    }
    return nil;
}

#pragma mark - lazyLoad
- (SDCMapHelper *)mapHelper
{
    if (!_mapHelper) {
        _mapHelper = [[SDCMapHelper alloc] init];
    }
    return _mapHelper;
}

//- (UIImageView *)arrowImgV
//{
//    if (!_arrowImgV) {
//        _arrowImgV = [[UIImageView alloc] initWithImage:UIImageName(@"navBackButton")];
//        _arrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
//    }
//    return _arrowImgV;
//}

- (UILabel *)desLbl
{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLbl.font = UIFontFromSize(14.0);
        _desLbl.textColor = UIColorFromRGB(118, 118, 119);
    }
    return _desLbl;
}

- (UILabel *)locationLbl
{
    if (!_locationLbl) {
        _locationLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLbl.font = UIFontFromSize(14.0);
        _locationLbl.textColor = [UIColor blackColor];
        _locationLbl.numberOfLines = 0;
        _locationLbl.text = @"正在获取位置中";
    }
    return _locationLbl;
}

//- (MAMapView *)myMapView
//{
//    if (!_myMapView) {
//        //配置高德导航sdk的key
//        //[MAMapServices sharedServices].apiKey = mapApiKey;
//
//        _myMapView = [[MAMapView alloc] init];
////        _myMapView.delegate = self;
////        _myMapView.distanceFilter = 10;
////        _myMapView.headingFilter = 5;
////        _myMapView.customizeUserLocationAccuracyCircleRepresentation = YES; //重写精度圈
////        _myMapView.showsCompass = NO;
////        _myMapView.buildingsDisabled = YES;
////        _myMapView.rotateEnabled = NO;
//
////        _myMapView.centerCoordinate = [MyCar shareIntance].lastCoord;
//
////        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
////        pointAnnotation.coordinate = [MyCar shareIntance].lastCoord;
////        [_myMapView addAnnotation:pointAnnotation];
//
//        //[_myMapView setZoomLevel:15.0 animated:YES];
//    }
//    return _myMapView;
//}
@end
