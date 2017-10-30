//
//  InvoiceCell.h
//  JoyMove
//
//  Created by 赵霆 on 16/4/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceModel.h"

@interface InvoiceCell : UITableViewCell

@property (nonatomic, strong) InvoiceModel *invoiceModel;
// 选中图片
@property (nonatomic, weak) UIImageView *selectedImg;

@end
