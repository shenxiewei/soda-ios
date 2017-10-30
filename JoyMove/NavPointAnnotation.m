//
//  NavPointAnnotation.m
//  officialDemoNavi
//
//  Created by LiuX on 14-8-26.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "NavPointAnnotation.h"

@implementation NavPointAnnotation

- (NavPointAnnotation *)initWithPOIModel:(POIModel *)model {
    
    self = [super init];
    if (self) {
        
        [self setCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
        self.poiModel = model;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[POIModel class]]) {
     
        POIModel *model = (POIModel *)object;
        return (self.poiModel.latitude==model.latitude)&&(self.poiModel.longitude==model.longitude);
    }else {
        
        return [super isEqual:object];
    }
}

@end
