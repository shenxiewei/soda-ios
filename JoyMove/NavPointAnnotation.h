//
//  NavPointAnnotation.h
//  officialDemoNavi
//
//  Created by LiuX on 14-8-26.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "POIModel.h"

@interface NavPointAnnotation : MAPointAnnotation

@property (nonatomic, strong) POIModel *poiModel;

- (NavPointAnnotation *)initWithPOIModel:(POIModel *)model;
- (BOOL)isEqual:(id)object;

@end
