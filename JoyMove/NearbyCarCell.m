//
//  NearbyCarCell.m
//  JoyMove
//
//  Created by 刘欣 on 15/6/30.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "NearbyCarCell.h"
#import "UtilsMacro.h"

@implementation NearbyCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCellUI];
    }
    return  self;
}

- (void)initCellUI {
    
//    CGFloat height = self.bounds.size.height;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 56;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 55.5, kScreenWidth, 0.5)];
    self.lineLabel.backgroundColor=UIColorFromSixteenRGB(0xe2e2e2);
    [self.contentView addSubview:self.lineLabel];
    
    //车牌显示
    self.plateLabel = [[UILabel alloc] init];
    self.plateLabel.frame = CGRectMake(15, 15, 120, 15);
    self.plateLabel.textAlignment=NSTextAlignmentLeft;
    self.plateLabel.font = [UIFont systemFontOfSize:15];
    self.plateLabel.textColor = UIColorFromSixteenRGB(0x272727);
    [self.contentView addSubview:self.plateLabel];
    
    //距离
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.frame = CGRectMake(15+9+5, 35, 120, 12);
    self.distanceLabel.textAlignment=NSTextAlignmentLeft;
    self.distanceLabel.font = [UIFont systemFontOfSize:11];
    self.distanceLabel.textColor = UIColorFromSixteenRGB(0x80807f);
    [self.contentView addSubview:self.distanceLabel];
    
    self.dictanceImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 35, 9, 12)];
    self.dictanceImage.image=[UIImage imageNamed:@"dictanceImage"];
    [self.contentView addSubview:self.dictanceImage];
    
    //查看按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(width-65, (height-30)/2, 50, 30);
    [checkButton setTitle:@"" forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkButton addTarget:self action:@selector(checkButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    checkButton.layer.cornerRadius = 4;
    checkButton.layer.masksToBounds = YES;
    [checkButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:checkButton];
}

//距离计算
- (void)updateCellWithModel:(POIModel *)poiModel andUserLocationCoor:(CLLocationCoordinate2D)userLocationCoor{
    
    self.plateLabel.text = poiModel.desp;
    CLLocationCoordinate2D nearbyCarcoor = CLLocationCoordinate2DMake(poiModel.latitude, poiModel.longitude);
    double distance = [ViewControllerServant distance:userLocationCoor fromCoor:nearbyCarcoor];
    if (distance < 1000.f) {
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ %.0lf M",NSLocalizedString(@"距离", nil), distance];
    }else {
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ %.1lf Km",NSLocalizedString(@"距离", nil), distance/1000.f];
    }
}

//查看按钮点击事件
- (void)checkButtonSelected {
    
    [self.nearbyCarCellDelegate didClickCeckButton:self.index];
}

@end

