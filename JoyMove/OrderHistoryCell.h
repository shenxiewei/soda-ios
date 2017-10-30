//
//  OrderHistoryCell.h
//  JoyMove
//
//  Created by ethen on 15/4/27.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHistoryModel.h"

@interface OrderHistoryCell : UITableViewCell

- (void)initUI;
- (void)update:(OrderHistoryModel *)model show:(BOOL)isShow;
+ (float)height;

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *startTimeLabel;
@property (nonatomic,strong) UILabel *stopTimeLabel;
@property (nonatomic,strong) UILabel *costTimeLabel;
@property (nonatomic,strong) UILabel *mileageLabel;
@property (nonatomic,strong) UILabel *lineLabelHeader;
@property (nonatomic,strong) UILabel *lineLabelFooter;

@property (nonatomic,strong) UILabel *couponDesLbl;
@property (nonatomic,strong) UILabel *couponFeeLbl;
@property (nonatomic,strong) UILabel *totalDesLbl;
@property (nonatomic,strong) UILabel *totalFeeLbl;

//
@property (nonatomic,strong) UIImageView *startImage;
@property (nonatomic,strong) UIImageView *finishImage;

@property (nonatomic,strong) UIView *backView;

@end
