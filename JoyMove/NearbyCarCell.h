//
//  NearbyCarCell.h
//  JoyMove
//
//  Created by 刘欣 on 15/6/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIModel.h"
#import "ViewControllerServant.h"
#import <CoreLocation/CLLocation.h>

@protocol NearbyCarCellDelegate <NSObject>

- (void)didClickCeckButton:(NSInteger)index;

@end

@interface NearbyCarCell : UITableViewCell

@property (nonatomic,retain) UILabel *plateLabel;            //车牌
@property (nonatomic,retain) UILabel *distanceLabel;         //距离
@property (nonatomic,strong) UIImageView *dictanceImage;         //距离图片
@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) id <NearbyCarCellDelegate> nearbyCarCellDelegate;

//距离计算
- (void)updateCellWithModel:(POIModel *)poiModel andUserLocationCoor:(CLLocationCoordinate2D)userLocationCoor;

@end
