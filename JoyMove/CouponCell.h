//
//  CouponCell.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/20.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

//@property(nonatomic,assign)double couponBalance;
/*天元测试*/
@property(nonatomic,assign)NSInteger couponBalance;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *overdueTime;

- (void)updateCellDate;

@end
