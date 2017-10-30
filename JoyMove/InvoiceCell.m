//
//  InvoiceCell.m
//  JoyMove
//
//  Created by 赵霆 on 16/4/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "InvoiceCell.h"
#import "Macro.h"

@interface InvoiceCell()
// 车牌
@property (nonatomic, weak) UILabel *timeLabel;
// 任务类型
@property (nonatomic, weak) UILabel *moneyLabel;

@end

@implementation InvoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self initCellUI];
    }
    return  self;
}

- (void)initCellUI
{
    CGFloat selfHeight = self.frame.size.height;
    
    // 时间label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth * 0.5, self.frame.size.height)];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textColor = UIColorFromSixteenRGB(0x272727);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 选中图片
    UIImageView *selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 21 - 10, (selfHeight - 21) * 0.5, 21, 21)];
    selectedImg.image = [UIImage imageNamed:@"invoice_nor"];
    [self.contentView addSubview:selectedImg];
    self.selectedImg = selectedImg;
    
    // 金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame), 0, (kScreenWidth * 0.5) - 44 - 13, selfHeight)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = UIColorFromSixteenRGB(0x272727);
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;

}

- (void)setInvoiceModel:(InvoiceModel *)invoiceModel
{
    // 时间
    NSDate *starTimeDate = [NSDate dateWithTimeIntervalSince1970:invoiceModel.startTime / 1000];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [self stringFromDate:starTimeDate]];
    // 金额
    NSNumber *money = [NSNumber numberWithDouble:invoiceModel.fee];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f元",NSLocalizedString(@"Actual payment", nil), [money doubleValue]];
    
}

// 时间戳转化为字符串
- (NSString *)stringFromDate:(NSDate *)date
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = NSLocalizedString(@"yyyy/MM/dd HH:mm", nil);
    
//    if (date.isThisYear) { // 今年
//        if (date.isToday) { // 今天
//            
//            fmt.dateFormat = @"今天 HH:mm";
//            return [fmt stringFromDate:date];
//            
//        } else if (date.isYesterday) { // 昨天
//            
//            fmt.dateFormat = @"昨天 HH:mm";
//            return [fmt stringFromDate:date];
//            
//        } else { // 其他
//            
//            fmt.dateFormat = @"MM月dd日 HH:mm";
//            return [fmt stringFromDate:date];
//        }
//    } else { // 非今年
        return [fmt stringFromDate:date];
//    }
}



@end
