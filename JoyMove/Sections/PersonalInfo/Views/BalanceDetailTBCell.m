//
//  BalanceDetailTBCell.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceDetailTBCell.h"
#import "BalanceRecordModel.h"
#import "RewardRecordModel.h"

@interface BalanceDetailTBCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation BalanceDetailTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    if([obj isKindOfClass:[BalanceRecordModel class]])
    {
        BalanceRecordModel *model = (BalanceRecordModel *)obj;
        self.typeLbl.text = model.tradeName;
        self.amountLbl.text = model.amountString;
        self.timeLbl.text = model.timeString;
    }else
    {
        RewardRecordModel *model = (RewardRecordModel *)obj;
        self.typeLbl.text = model.taskName;
        self.amountLbl.text = [NSString stringWithFormat:@"%.1f元",model.balance];
        self.timeLbl.text = model.timeString;
    }
}
@end
