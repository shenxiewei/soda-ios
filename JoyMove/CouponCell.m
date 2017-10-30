//
//  CouponCell.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CouponCell.h"
#import "UtilsMacro.h"

@implementation CouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self initUI];
        [self initCouponUI];
    }
    return self;
}

//- (void)initUI {
//    
//    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(8, 0, kScreenWidth-16, 60)];
//    white.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:white];
//    
//    UIImageView *icon = [[UIImageView alloc]init];
//    icon.frame = CGRectMake(8-5, 5, 50, 50);
//    icon.tag = 1;
//    [self.contentView addSubview:icon];
//    
//    //钱数
//    UILabel *couponBalanceLabel = [[UILabel alloc]init];
//    couponBalanceLabel.frame = CGRectMake(64, 5, kScreenWidth/2-63, 50);
//    couponBalanceLabel.tag = 2;
//    couponBalanceLabel.textAlignment = NSTextAlignmentCenter;
//    couponBalanceLabel.textColor = UIColorFromRGB(90, 90, 90);
//    couponBalanceLabel.font = UIFontFromSize(15);
//    [self.contentView addSubview:couponBalanceLabel];
//    
//    //有效期
//    UILabel *couponDate = [[UILabel alloc]init];
//    couponDate.frame = CGRectMake(kScreenWidth/2, 5, kScreenWidth/2-16, 50);
//    couponDate.tag = 3;
//    couponDate.textAlignment = NSTextAlignmentRight;
//    couponDate.textColor = UIColorFromRGB(200, 200, 200);
//    couponDate.font = UIBoldFontFromSize(12);
//    [self.contentView addSubview:couponDate];
//}

- (void)initCouponUI {

    UIImage *cellImg = [UIImage imageNamed:@"couponCellImg"];
    cellImg = [cellImg stretchableImageWithLeftCapWidth:200 topCapHeight:50];
    CGFloat width = kScreenWidth-26;
    CGFloat height = cellImg.size.height;
    
    UIImageView *cellView = [[UIImageView alloc] init];
    cellView.frame = CGRectMake(13, 0, width, height);
    cellView.image = cellImg;
    [self.contentView addSubview:cellView];
    
    //钱数
    UILabel *couponBalanceLabel = [[UILabel alloc]init];
    couponBalanceLabel.frame = CGRectMake(21, 0, 80, height);
    couponBalanceLabel.minimumScaleFactor = 10;
    couponBalanceLabel.tag = 2;
    couponBalanceLabel.textAlignment = NSTextAlignmentCenter;
    couponBalanceLabel.textColor = [UIColor whiteColor];
    couponBalanceLabel.font = [UIFont systemFontOfSize:50];
    couponBalanceLabel.adjustsFontSizeToFitWidth = YES;
    [cellView addSubview:couponBalanceLabel];
    
    //有效期
    UILabel *couponDate = [[UILabel alloc]init];
    couponDate.frame = CGRectMake(230/2, 30, 200, 40);
    couponDate.tag = 3;
    couponDate.textColor = [UIColor whiteColor];
    couponDate.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:couponDate];
}

- (void)updateCellDate {
    
    UILabel *couponBalanceLabel = (UILabel *)[self.contentView viewWithTag:2];
    couponBalanceLabel.text = [NSString stringWithFormat:@"%ld",(long)_couponBalance];
    if (couponBalanceLabel.text.length==3)
    {
        couponBalanceLabel.font=[UIFont systemFontOfSize:35];
    }
    else if (couponBalanceLabel.text.length==4)
    {
        couponBalanceLabel.font=[UIFont systemFontOfSize:30];
    }
    else
    {
        couponBalanceLabel.font=[UIFont systemFontOfSize:50];
    }
//    else
//    {
//        couponBalanceLabel.font=[UIFont systemFontOfSize:10];
//    }
    couponBalanceLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *couponDate = (UILabel *)[self.contentView viewWithTag:3];
    couponDate.text = [NSString stringWithFormat:@"%@%@%@",_startTime, NSLocalizedString(@"To", nil),_overdueTime];
}

@end
