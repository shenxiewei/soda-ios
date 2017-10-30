//
//  RankingCell.m
//  JoyMove
//
//  Created by 赵霆 on 16/6/13.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "RankingCell.h"
#import "Macro.h"

@interface RankingCell()

@property (nonatomic, weak) UIImageView *rankingImgView;
@property (nonatomic, weak) UILabel *rankingLabel;
@property (nonatomic, weak) UIImageView *headImgView;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *mileageLabel;

@end

@implementation RankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCellUI];
    }
    return  self;
}

- (void)initCellUI
{
    
    UIImageView *rankingImg = [[UIImageView alloc] init];
    rankingImg.frame = CGRectMake(17.5, 22, 19, 25);
    rankingImg.hidden = YES;
    [self.contentView addSubview:rankingImg];
    self.rankingImgView = rankingImg;
    
    UILabel *rankingLbel = [[UILabel alloc] init];
    rankingLbel.frame = CGRectMake(17.5, 22, 19, 35);
    rankingLbel.font = [UIFont systemFontOfSize:24];
    rankingLbel.adjustsFontSizeToFitWidth = YES;
    rankingLbel.textColor = UIColorFromRGB(107, 107, 105);
    rankingLbel.hidden = YES;
    [self.contentView addSubview:rankingLbel];
    self.rankingLabel = rankingLbel;
    
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.frame = CGRectMake(CGRectGetMaxX(rankingImg.frame) + 17.5, 12.5, 44, 44);
    headImgView.layer.cornerRadius = 22;
    headImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImgView];
    self.headImgView = headImgView;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(CGRectGetMaxX(headImgView.frame) + 12, 28, 0, 0);
    phoneLabel.font = [UIFont systemFontOfSize:12];
    phoneLabel.textColor = UIColorFromRGB(104, 104, 104);
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UILabel *mileageLabel = [[UILabel alloc] init];
    mileageLabel.font = [UIFont systemFontOfSize:17];
    mileageLabel.textAlignment = NSTextAlignmentRight;
    [mileageLabel sizeToFit];
    [self.contentView addSubview:mileageLabel];
    self.mileageLabel = mileageLabel;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 68.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [self.contentView addSubview:lineView];
    
}

- (void)setRankingModel:(RankingModel *)rankingModel
{
    
    // 用户头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:rankingModel.photo] placeholderImage:[UIImage imageNamed:@"headerPlaceholder"]];
    // 用户手机
    NSString *phoneStr = [rankingModel.mobileNo stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneLabel.text = phoneStr;
    [self.phoneLabel sizeToFit];
    
    // 里程数
    NSString *mileageStr = [NSString stringWithFormat:@"%@KM",rankingModel.mileage];
    self.mileageLabel.text = mileageStr;
    CGFloat mileageLabelX = CGRectGetMaxX(self.phoneLabel.frame);
    self.mileageLabel.frame = CGRectMake(mileageLabelX, 0, kScreenWidth - mileageLabelX - 17.5, 69);
    self.mileageLabel.textColor = UIColorFromRGB(246, 105, 77);
    
    // 排名
    self.rankingImgView.hidden = NO;
    self.rankingLabel.hidden = YES;
    
    if ([rankingModel.rank isEqualToString:@"1"]) {
        
        self.rankingImgView.image = [UIImage imageNamed:@"theFirst"];
    }else if ([rankingModel.rank isEqualToString:@"2"]){
        
        self.rankingImgView.image = [UIImage imageNamed:@"theSecond"];
    }else if ([rankingModel.rank isEqualToString:@"3"]){
        
        self.rankingImgView.image = [UIImage imageNamed:@"theThird"];
    }else{
        
        self.mileageLabel.textColor = UIColorFromRGB(39, 39, 39);
        self.rankingImgView.hidden = YES;
        self.rankingLabel.hidden = NO;
        self.rankingLabel.text = rankingModel.rank;
    }
    
}



@end
