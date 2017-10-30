//
//  RecommendRoadViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"

@protocol RouteDelegate <NSObject>

- (void)didSelectedRecommendedRoute:(NSArray *)array name:(NSString *)name;

@end

@interface RecommendRoadViewController : BaseViewController

@property (nonatomic,assign)id<RouteDelegate>routeDelegate;

@end
