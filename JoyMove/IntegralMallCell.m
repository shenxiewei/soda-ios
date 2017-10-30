//
//  IntegralMallCell.m
//  JoyMove
//
//  Created by cty on 15/12/15.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "IntegralMallCell.h"
#import "Macro.h"

@interface IntegralMallCell ()

@end


@implementation IntegralMallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

-(void)initCell
{
    _backImage=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, kScreenWidth-28, 93)];
    _backImage.image=[UIImage imageNamed:@""];
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    _backImage.backgroundColor = [UIColor redColor];
    [_backImage.layer setMasksToBounds:YES];
    [_backImage.layer setCornerRadius:8];
    [self.contentView addSubview:_backImage];
    
    UILabel *RMBLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 52.5, 14, 14)];
    RMBLabel.text=@"￥";
    RMBLabel.font=[UIFont systemFontOfSize:18];
    RMBLabel.textColor=[UIColor whiteColor];
    [_backImage addSubview:RMBLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(RMBLabel.frame.origin.x+RMBLabel.frame.size.width+10, 20,60, 58)];
    _moneyLabel.textColor=[UIColor whiteColor];
    _moneyLabel.font=[UIFont systemFontOfSize:50];
    _moneyLabel.adjustsFontSizeToFitWidth=YES;
    [_backImage addSubview:_moneyLabel];
    
    UILabel *YuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(_moneyLabel.frame.size.width+_moneyLabel.frame.origin.x+11.5, 33.5, 50, 12)];
    YuanLabel.textColor=[UIColor whiteColor];
    YuanLabel.text=NSLocalizedString(@"元优惠劵", nil);
    YuanLabel.textAlignment=NSTextAlignmentLeft;
    YuanLabel.font=[UIFont systemFontOfSize:12];
    [_backImage addSubview:YuanLabel];
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_moneyLabel.frame.origin.x+_moneyLabel.frame.size.width+10, 11.5+YuanLabel.frame.origin.y+YuanLabel.frame.size.height,150.0/375*kScreenWidth,12)];
    _timeLabel.textColor=[UIColor whiteColor];
    _timeLabel.textAlignment=NSTextAlignmentLeft;
    _timeLabel.font=[UIFont systemFontOfSize:11];
    [_backImage addSubview:_timeLabel];
    
    UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(_timeLabel.frame.size.width+_timeLabel.frame.origin.x, 0, 1.5, 93)];
    lineImage.image=[UIImage imageNamed:@"CommodityIntegralLineImage"];
    [_backImage addSubview:lineImage];
    
    _integralLabel=[[UILabel alloc]initWithFrame:CGRectMake(lineImage.frame.size.width+lineImage.frame.origin.x, 32.5,(_backImage.frame.size.width-lineImage.frame.size.width-lineImage.frame.origin.x)/2.0+5, 13)];
    _integralLabel.textColor=[UIColor whiteColor];
    _integralLabel.font=[UIFont systemFontOfSize:15];
    _integralLabel.textAlignment=NSTextAlignmentRight;
    _integralLabel.adjustsFontSizeToFitWidth = YES;
    [_backImage addSubview:_integralLabel];
    
    UIImageView *cellImage=[[UIImageView alloc]initWithFrame:CGRectMake(_integralLabel.frame.origin.x+_integralLabel.frame.size.width+5, 32.5, 10.5, 12.5)];
    cellImage.image=[UIImage imageNamed:@"CommodityIntegralCellImage"];
    [_backImage addSubview:cellImage];
    
    UILabel *exchangeLabel=[[UILabel alloc]initWithFrame:CGRectMake(lineImage.frame.size.width+lineImage.frame.origin.x, _integralLabel.frame.origin.y+_integralLabel.frame.size.height+11, _backImage.frame.size.width-lineImage.frame.size.width-lineImage.frame.origin.x, 11)];
    exchangeLabel.textAlignment=NSTextAlignmentCenter;
    exchangeLabel.text=NSLocalizedString(@"Exchange Now", nil);
    exchangeLabel.textColor=[UIColor whiteColor];
    exchangeLabel.font=[UIFont systemFontOfSize:11];
    [_backImage addSubview:exchangeLabel];
    
    UIButton *clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame=CGRectMake(0, 0, lineImage.frame.origin.x+14, 106);
    clearButton.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:clearButton];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
