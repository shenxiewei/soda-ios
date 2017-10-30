//
//  TradeDetailTableViewCell.h
//  JoyMove
//
//  Created by Soda on 2017/3/9.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Sodacar.h"

@interface TradeModel : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, copy) NSString *refundID;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *descriptionString;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
@end

@interface TradeDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)TradeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
