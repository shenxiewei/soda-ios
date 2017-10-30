//
//  DestinationListViewController.h
//  JoyMove
//
//  Created by ethen on 15/4/13.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//  <目的地列表>

#import "BaseViewController.h"

@protocol DestinationListDelegate <NSObject>

- (void)didSelectedPOIArray:(NSArray *)array;

@end


@interface DestinationListViewController : BaseViewController

@property (assign, nonatomic) id<DestinationListDelegate> delegate;

@end
