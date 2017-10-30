//
//  CreditCardCell.m
//  JoyMove
//
//  Created by 刘欣 on 15/8/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CreditCardCell.h"

@implementation CreditCardCell

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
        
        [self initCellUI];
    }
    return  self;
}

- (void)initCellUI {

    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(100, (self.bounds.size.height-30)/2, self.bounds.size.width-100-60, 30);
    self.textField.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.textField];
}

@end
