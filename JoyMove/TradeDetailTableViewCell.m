//
//  TradeDetailTableViewCell.m
//  JoyMove
//
//  Created by Soda on 2017/3/9.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TradeDetailTableViewCell.h"
@implementation TradeModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.timeString = [self timeStamp:[dict[@"createTime"] doubleValue]*0.001];
        if ([dict[@"amount"] isEqual:[NSNull null]]) {
            self.amount = 0;
        }else
        {
            self.amount = [dict[@"amount"] doubleValue];
        }
        self.typeString = [self convertTradeType:[dict[@"type"] integerValue]];
        
        NSString *detailString = dict[@"detail"];
        self.refundID = nil;
        if (![detailString isEqual:[NSNull null]]) {
            NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.refundID = tempDict[@"refundId"];
        }
        self.descriptionString = dict[@"description"];
    }
    return self;
}

- (NSString *)convertPayType:(NSInteger)payType
{
    NSString *temp = @"支付宝支付";
    switch (payType) {
        case 1:
            temp = @"支付宝支付";
            break;
        case 2:
            temp = @"微信支付";
            break;
        default:
            
            break;
    }
    return temp;
}

- (NSString *)timeStamp:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString *)convertTradeType:(NSInteger)type
{
//    1:充值 2:冻结
//    3:解冻 4:退款
//    5:扣款
    NSString *string = @"充值";
    switch (type) {
        case 1:
            string = @"充值";
            break;
        case 2:
            string = @"冻结";
            break;
        case 3:
            string = @"解冻";
            break;
        case 4:
            string = @"退款";
            break;
        case 5:
            string = @"扣款";
            break;
        default:
            break;
    }
    return string;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

@interface TradeDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *blanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeLbl;
@end

@implementation TradeDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"TradeDetailTableViewCell";
    TradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeDetailTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TradeModel *)model
{
    self.statusLbl.text = model.typeString;
    self.blanceLbl.text = [NSString stringWithFormat:@"%.2f元",model.amount];
    self.timeLbl.text = model.timeString;
    self.tradeTypeLbl.text = model.descriptionString;
    
    [self.timeLbl layoutIfNeeded];
    [self.tradeTypeLbl layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
