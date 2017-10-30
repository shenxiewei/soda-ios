//
//  DepositTableViewCell.m
//  JoyMove
//
//  Created by Soda on 2017/3/7.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "DepositTableViewCell.h"

@interface DepositTableViewCell()

@property(nonatomic,retain) UIImageView *rightImageView;

@end

@implementation DepositTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"DepositTableViewCell";
    DepositTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DepositTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_sel"]];
        self.rightImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-20.0-self.rightImageView.frame.size.width, (self.frame.size.height-self.rightImageView.frame.size.height)*0.5, self.rightImageView.frame.size.width, self.rightImageView.frame.size.height);
        [self addSubview:self.rightImageView];
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.rightImageView.image = [UIImage imageNamed:@"check_sel"];
    }else
    {
        self.rightImageView.image = [UIImage imageNamed:@"check_nor"];
    }

    // Configure the view for the selected state
}

@end
