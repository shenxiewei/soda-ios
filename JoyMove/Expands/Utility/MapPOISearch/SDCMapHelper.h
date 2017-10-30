//
//  SDCMapHelper.h
//  SDBaseCompents
//
//  Created by Soda on 2017/4/10.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapNaviKit/AMapNaviKit.h>

typedef void (^SearchCompleteBlock)(AMapReGeocodeSearchResponse *response);

@interface SDCMapHelper : NSObject

/**
 显示路径辅助方法

 @param path <#path description#>
 @return <#return value description#>
 */
+ (NSArray *)polylinesForPath:(AMapPath *)path;

/**
 显示以该经纬度为中心的位置

 @param coor <#coor description#>
 @param delta <#delta description#>
 @param initWithLocation <#initWithLocation description#>
 @param locationCoord <#locationCoord description#>
 @return <#return value description#>
 */
+ (MACoordinateRegion)showCoordinate:(CLLocationCoordinate2D)coor delta:(double)delta animated:(BOOL)animated;

- (void)startSearch:(CLLocationCoordinate2D)coord CompleteBlock:(SearchCompleteBlock)block;
@end
