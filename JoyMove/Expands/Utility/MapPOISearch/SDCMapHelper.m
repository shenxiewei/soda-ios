//
//  SDCMapHelper.m
//  SDBaseCompents
//
//  Created by Soda on 2017/4/10.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "SDCMapHelper.h"

@interface SDCMapHelper()<AMapSearchDelegate>
{
    AMapSearchAPI *_search;
}

@property(nonatomic,copy)SearchCompleteBlock searchCompleteBlock;
@end

@implementation SDCMapHelper


// 显示路径辅助方法
+ (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [SDCMapHelper coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
    
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        
        free(coordinates), coordinates = NULL;
    }];
    
    return polylines;
}

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

//将地图中心移动到一个坐标点上
+ (MACoordinateRegion)showCoordinate:(CLLocationCoordinate2D)coor delta:(double)delta animated:(BOOL)animated {
    
    MACoordinateSpan span;
    span.latitudeDelta  = delta;      //1纬度=110.94公里
    span.longitudeDelta = delta;      //1经度=85.276公里
    
    MACoordinateRegion region;
    region.center   = coor;
    region.span     = span;
    return region;
}

#pragma mark - system
- (id)init
{
    self = [super init];
    if (self) {
        //记得替换
        _search =  [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return self;
}

- (void)startSearch:(CLLocationCoordinate2D)coord CompleteBlock:(SearchCompleteBlock)block
{
    //记得替换
    self.searchCompleteBlock = block;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
    regeo.requireExtension            = YES;

    [_search AMapReGoecodeSearch:regeo];
}

#pragma mark - 逆地理编码回调
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        if (self.searchCompleteBlock) {
            self.searchCompleteBlock(response);
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)dealloc
{
    NSLog(@"search dealloc");
}


@end
