//
//  OrderHistoryCell.m
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "OrderHistoryCell.h"
#import "Macro.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CLGeocoder.h>
#import "SearchModel.h"
#import "NSString+dataFormat.h"

@interface OrderHistoryCell () {
    
    
//    UILabel *_dateLabel;
//    UILabel *_startTimeLabel;
//    UILabel *_stopTimeLabel;
//    UILabel *_costTimeLabel;
//    UILabel *_startPointLabel;
//    UILabel *_stopPointLabel;
//    UILabel *_mileageLabel;
    //UILabel *_moneyLabel;
}
@end

@implementation OrderHistoryCell

enum {
  
    NotUpdated = 100,
    Updated,
};

- (void)prepareForReuse {
    
//    _startTimeLabel.text = @"";
//    _stopTimeLabel.text = @"";
    
//    _startPointLabel.text = @"";
//    _stopPointLabel.text = @"";
//    _startPointLabel.tag = NotUpdated;
//    _stopPointLabel.tag = NotUpdated;
//    _mileageLabel.text = @"";
    //_moneyLabel.text = @"";
}

- (void)initUI {
    
    self.contentView.backgroundColor = KBackgroudColor;
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 160)];
    _backView.backgroundColor=UIColorFromSixteenRGB(0xffffff);
    [self.contentView addSubview:_backView];
    
    _lineLabelHeader=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    _lineLabelHeader.backgroundColor=UIColorFromSixteenRGB(0xbdbdbd);
    [_backView addSubview:_lineLabelHeader];
    
    _lineLabelFooter=[[UILabel alloc]initWithFrame:CGRectMake(0, 159.5, kScreenWidth, 0.5)];
    _lineLabelFooter.backgroundColor=UIColorFromSixteenRGB(0xbdbdbd);
    [_backView addSubview:_lineLabelFooter];
    
    _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(17.5, 12, kScreenWidth/2.0-35, 13.5)];
    _dateLabel.textColor=UIColorFromSixteenRGB(0x656565);
    _dateLabel.font=[UIFont systemFontOfSize:14];
    _dateLabel.textAlignment=NSTextAlignmentLeft;
    [_backView addSubview:_dateLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-18-150, 12, 150, 13.5)];
    _moneyLabel.textColor=UIColorFromSixteenRGB(0xf55f60);
    _moneyLabel.font=[UIFont systemFontOfSize:14];
    _moneyLabel.textAlignment=NSTextAlignmentRight;
    _moneyLabel.adjustsFontSizeToFitWidth=YES;
    [_backView addSubview:_moneyLabel];
    
    _couponDesLbl = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 25.5+13.5, kScreenWidth/2.0-35, 13.5)];
    _couponDesLbl.textColor=UIColorFromSixteenRGB(0xf55f60);
    _couponDesLbl.font=[UIFont systemFontOfSize:14];
    _couponDesLbl.textAlignment=NSTextAlignmentLeft;
    _couponDesLbl.text = NSLocalizedString(@"优惠金额", nil);
    [_backView addSubview:_couponDesLbl];
    
    _couponFeeLbl =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-18-150, 25.5+13.5, 150, 13.5)];
    _couponFeeLbl.textColor=UIColorFromSixteenRGB(0xf55f60);
    _couponFeeLbl.font=[UIFont systemFontOfSize:14];
    _couponFeeLbl.textAlignment=NSTextAlignmentRight;
    _couponFeeLbl.adjustsFontSizeToFitWidth=YES;
    [_backView addSubview:_couponFeeLbl];
    
    _totalDesLbl = [[UILabel alloc]initWithFrame:CGRectMake(17.5, _couponFeeLbl.y+_couponDesLbl.height+13.5, kScreenWidth/2.0-35, 13.5)];
    _totalDesLbl.textColor=UIColorFromSixteenRGB(0x656565);
    _totalDesLbl.font=[UIFont systemFontOfSize:14];
    _totalDesLbl.textAlignment=NSTextAlignmentLeft;
    _totalDesLbl.text = NSLocalizedString(@"总金额", nil);
    [_backView addSubview:_totalDesLbl];
    
    _totalFeeLbl =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-18-150,_couponFeeLbl.y+ _couponFeeLbl.height+13.5, 150, 13.5)];
    _totalFeeLbl.textColor=UIColorFromSixteenRGB(0x656565);
    _totalFeeLbl.font=[UIFont systemFontOfSize:14];
    _totalFeeLbl.textAlignment=NSTextAlignmentRight;
    _totalFeeLbl.adjustsFontSizeToFitWidth=YES;
    [_backView addSubview:_totalFeeLbl];
    
    float offy = 60.0;
    _startImage=[[UIImageView alloc]initWithFrame:CGRectMake(17.5, _dateLabel.frame.origin.y+_dateLabel.frame.size.height+22.5+offy, 15, 15)];
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _dateLabel.frame.origin.y+_dateLabel.frame.size.height+22.5+offy, 15, 15)];
    starLabel.font = [UIFont systemFontOfSize:10];
    starLabel.textAlignment = NSTextAlignmentCenter;
    starLabel.textColor = [UIColor whiteColor];
    starLabel.text = NSLocalizedString(@"始", nil);
    _startImage.image=[UIImage imageNamed:@"startPoint"];
//    _startImage.backgroundColor=[UIColor redColor];
    [_backView addSubview:_startImage];
    [_backView addSubview:starLabel];
    
    
    _startTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_startImage.frame.origin.x+_startImage.frame.size.width+5, _dateLabel.frame.origin.y+_dateLabel.frame.size.height+22.5+offy, kScreenWidth/2.0-35-15-5, 15)];
    _startTimeLabel.textColor=UIColorFromSixteenRGB(0x656565);
    _startTimeLabel.font=[UIFont systemFontOfSize:14];
    _startTimeLabel.textAlignment=NSTextAlignmentLeft;
    [_backView addSubview:_startTimeLabel];
    
    _finishImage=[[UIImageView alloc]initWithFrame:CGRectMake(17.5, _startImage.frame.origin.y+_startImage.frame.size.height+12.5, 15, 15)];
    _finishImage.image=[UIImage imageNamed:@"endPoint"];
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _startImage.frame.origin.y+_startImage.frame.size.height+12.5, 15, 15)];
    finishLabel.font = [UIFont systemFontOfSize:10];
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.textColor = [UIColor whiteColor];
    finishLabel.text = NSLocalizedString(@"终", nil);
//    _finishImage.backgroundColor=[UIColor blueColor];
    [_backView addSubview: _finishImage];
    [_backView addSubview:finishLabel];
    
    _stopTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_finishImage.frame.origin.x+_finishImage.frame.size.width+5, _startImage.frame.origin.y+_startImage.frame.size.height+12.5, kScreenWidth/2.0-35-15-5, 15)];
    _stopTimeLabel.textColor=UIColorFromSixteenRGB(0x656565);
    _stopTimeLabel.font=[UIFont systemFontOfSize:14];
    _stopTimeLabel.textAlignment=NSTextAlignmentLeft;
    [_backView addSubview:_stopTimeLabel];
    
    _mileageLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-18-100, _dateLabel.frame.origin.y+_dateLabel.frame.size.height+22.5+offy, 100, 15)];
    _mileageLabel.adjustsFontSizeToFitWidth=YES;
    _mileageLabel.textColor=UIColorFromSixteenRGB(0x656565);
    _mileageLabel.font=[UIFont systemFontOfSize:14];
    _mileageLabel.textAlignment=NSTextAlignmentRight;
    [_backView addSubview:_mileageLabel];
    
    _costTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-18-120, _startTimeLabel.frame.origin.y+_startTimeLabel.frame.size.height+12.5, 120, 13.5)];
    _costTimeLabel.textColor=UIColorFromSixteenRGB(0x656565);
    _costTimeLabel.font=[UIFont systemFontOfSize:14];
    _costTimeLabel.textAlignment=NSTextAlignmentRight;
    _costTimeLabel.adjustsFontSizeToFitWidth=YES;
    [_backView addSubview:_costTimeLabel];
    
//    UIImage *img = [UIImage imageNamed:@"orderHistoryWhite"];
//    UIImageView *white = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:150 topCapHeight:0]];
//    white.frame = CGRectMake(0, 0, kScreenWidth, 119);
//    [self.contentView addSubview:white];
//    
//    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 31, 60, 25)];
//    _startTimeLabel.textColor = UIColorFromRGB(110, 110, 110);
//    _startTimeLabel.textAlignment = NSTextAlignmentCenter;
//    _startTimeLabel.backgroundColor = [UIColor whiteColor];
//    _startTimeLabel.font = UIFontFromSize(14);
//    [self.contentView addSubview:_startTimeLabel];
//    
//    _stopTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-75, 31, 60, 25)];
//    _stopTimeLabel.textColor = UIColorFromRGB(110, 110, 110);
//    _stopTimeLabel.font = UIFontFromSize(14);
//    [self.contentView addSubview:_stopTimeLabel];
//    
//    _costTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 21, kScreenWidth-200, 25)];
//    _costTimeLabel.textColor = UIColorFromRGB(160, 160, 160);
//    _costTimeLabel.textAlignment = NSTextAlignmentCenter;
//    _costTimeLabel.font = UIFontFromSize(15);
//    _costTimeLabel.minimumScaleFactor = 5;
//    [self.contentView addSubview:_costTimeLabel];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, kScreenWidth-200, 25)];
//    label.text = @"共用时";
//    label.textColor = UIColorFromRGB(160, 160, 160);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = UIFontFromSize(14);
//    [self.contentView addSubview:label];
    
//    _startPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 80, kScreenWidth-45-15, 40)];
//    _startPointLabel.textColor = UIColorFromRGB(110, 110, 110);
//    _startPointLabel.font = UIFontFromSize(15);
//    [self.contentView addSubview:_startPointLabel];
//    
//    _stopPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 120, kScreenWidth-45-15, 40)];
//    _stopPointLabel.textColor = UIColorFromRGB(110, 110, 110);
//    _stopPointLabel.font = UIFontFromSize(15);
//    [self.contentView addSubview:_stopPointLabel];
    
//    _mileageLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 80, 150, 40)];
//    _mileageLabel.textColor = UIColorFromRGB(110, 110, 110);
//    _mileageLabel.font = UIFontFromSize(15);
//    [self.contentView addSubview:_mileageLabel];
    
    /*
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 160, kScreenWidth-20-200, 40)];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.textColor = UIColorFromRGB(237, 127, 109);
    _moneyLabel.font = UIFontFromSize(15);
    [self.contentView addSubview:_moneyLabel];
     */
}

- (void)update:(OrderHistoryModel *)model show:(BOOL)isShow {
    
    self.hidden = !isShow;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
    _startTimeLabel.text = [dateFormatter stringFromDate:startDate];
    
    NSDate *stopDate = [NSDate dateWithTimeIntervalSince1970:model.stopTime/1000];
    _stopTimeLabel.text = [dateFormatter stringFromDate:stopDate];
    
    _mileageLabel.text = [NSString stringWithFormat:@"%.1f%@", model.miles, NSLocalizedString(@"Km", nil)];
    //_moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", model.fee];
    NSString *costString=[NSString compareTime:(model.stopTime/1000-model.startTime/1000) isCountdown:YES];
    
    if (costString.length>0)
    {
        _costTimeLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Drived", nil), costString];
    }
    else
    {
        _costTimeLabel.text = NSLocalizedString(@"Drived 1 min", nil);
    }
    
    //_startPointLabel.tag的tag值是100，没明白为什么要加这个判断
//    if (Updated!=_startPointLabel.tag) {
//       
//        _startPointLabel.text = @"获取中...";
//        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:model.startLatitude longitude:model.startLongitude];
//        
//#pragma mark - placemark这个数组有时候会为空(暂时不知道什么原因)
//        [geocoder reverseGeocodeLocation:startLocation completionHandler:^(NSArray *placemark,NSError *error) {
//            if (placemark&&placemark.count) {
//            
//                CLPlacemark *mark = [placemark objectAtIndex:0];
//                _startPointLabel.text = [mark.name stringByReplacingOccurrencesOfString:@"中国" withString:@""];
//                _startPointLabel.tag = Updated;
//            }else {
//                
//                _startPointLabel.text = @"无";
//                _startPointLabel.tag = Updated;
//            }
//        }];
//    }else {
//        
//        NSLog(@"123");
//    }
    
//    if (Updated!=_stopPointLabel.tag) {
//        
//        _stopPointLabel.text = @"获取中...";
//        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:model.stopLatitude longitude:model.stopLongitude];
//        [geocoder reverseGeocodeLocation:startLocation completionHandler:^(NSArray *placemark,NSError *error) {
//            
//            if (placemark&&placemark.count) {
//                
//                CLPlacemark *mark = [placemark objectAtIndex:0];
//                
//                _stopPointLabel.text = [mark.name stringByReplacingOccurrencesOfString:@"中国" withString:@""];
//                _stopPointLabel.tag = Updated;
//            }else {
//                
//                _stopPointLabel.text = @"无";
//                _stopPointLabel.tag = Updated;
//            }
//        }];
    
        /* 导航设置的目的地
        if (model.destinations.count) {
            
            SearchModel *searchModel = [model.destinations lastObject];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:searchModel.latitude longitude:searchModel.longitude];
            [geocoder reverseGeocodeLocation:stopLocation completionHandler:^(NSArray *placemark,NSError *error) {
                
                CLPlacemark *mark = [placemark objectAtIndex:0];
                
                _stopPointLabel.text = [mark.name stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                _stopPointLabel.tag = Updated;
            }];
        }else {
            
            _stopPointLabel.text = @"未设定目的地";
            _stopPointLabel.tag = Updated;
        }
         */
//    }else {
//        
//        NSLog(@"456");
//    }
}

+ (float)height {
   
    return 180;
}

@end
