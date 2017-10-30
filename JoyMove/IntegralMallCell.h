//
//  IntegralMallCell.h
//  JoyMove
//
//  Created by cty on 15/12/15.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralMallCell : UITableViewCell

//背景图
@property (nonatomic,strong) UIImageView *backImage;
//多少钱的优惠劵
@property (nonatomic,strong) UILabel *moneyLabel;
//多长时间过期
@property (nonatomic,strong) UILabel *timeLabel;
//积分label
@property (nonatomic,strong) UILabel *integralLabel;


@end
