//
//  PinAnnotationView.h
//  JoyMove
//
//  Created by ethen on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "POIModel.h"
#import "POIDefine.h"

@interface PinAnnotationView : MAAnnotationView

@property (nonatomic, strong) POIModel *poiModel;

@end
