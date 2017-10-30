//
//  ViewController+Polygon.m
//  JoyMove
//
//  Created by ethen on 16/7/21.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "ViewController+Polygon.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@implementation ViewController (Polygon)

- (void)addMAPolygonWithPoints:(NSArray *)points mapView:(MAMapView *)mapView {
    
    unsigned long count = [points count];
    CLLocationCoordinate2D coordinates[count];
    for (int i = 0; i<count; i++) {
        AMapGeoPoint *point = points[i];
        coordinates[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    }
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [mapView addOverlay:polygon];
}

//- (MAPolygonView *)customPolygonViewWithOverlay:(MAPolygon *)overlay{
//    MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
//    polygonView.lineWidth = 6.f;
//    polygonView.strokeColor = UIColorFromSixteenRGB(0x4fc3ff);
//    polygonView.lineJoinType = kMALineCapRound;
//    polygonView.fillColor = UIColorFromSixteenRGBA(0x4fc3ff, .1f);
//    return polygonView;
//}

//获取电子围栏数据
//cityCode为要获取电子围栏的城市编码，若为""则获取全部
- (void)requestFence:(NSString *)cityCode mapView:(MAMapView *)mapView{
    
    NSDictionary *dic = @{@"fence":cityCode};
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlFence) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {

                NSArray *fence = response[@"fences"];
                if (fence && [fence respondsToSelector:@selector(count)]) {
                    
                    for (NSDictionary *dic in fence) {
                        
                        //解析电子围栏数据
                        //fencePoints数据为字符串格式，经度纬度以:分隔，数据以,分隔
                        NSMutableArray *mutableArray = [@[] mutableCopy];
                        NSString *fencePoints = dic[@"fencePoints"];
                        NSArray *array = [fencePoints componentsSeparatedByString:@","];
                        for (NSString *string in array) {
                            
                            NSArray *array = [string componentsSeparatedByString:@":"];
                            if (array && [array respondsToSelector:@selector(count)] && array.count>=2) {
                                
                                NSString *longitude = array[0];
                                NSString *latitude = array[1];
                                AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
                                [mutableArray addObject:point];
                            }
                        }
                        if (mutableArray.count) {
                            
                            //确保电子围栏首尾相连，绘制
                            id obj = [mutableArray firstObject];
                            [mutableArray addObject:obj];
                            [self addMAPolygonWithPoints:mutableArray mapView:mapView];
                        }
                    }
                }
            }
        }
    }];
}
@end
