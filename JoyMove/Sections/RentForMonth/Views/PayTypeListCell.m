//
//  PayTypeListCell.m
//  SDBaseCompents
//
//  Created by Soda on 2017/6/8.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "PayTypeListCell.h"

@interface PayTypeListCell ()

@property(nonatomic,retain) UIImageView *rightImageView;

@end

@implementation PayTypeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.rightImageView.image = [UIImage imageNamed:@"check_sel"];
    }else
    {
        self.rightImageView.image = [UIImage imageNamed:@"check_nor"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_sel"]];
        self.rightImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.rightImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-20.0-self.rightImageView.frame.size.width, (self.frame.size.height-self.rightImageView.frame.size.height)*0.5, self.rightImageView.frame.size.width, self.rightImageView.frame.size.height);
        [self addSubview:self.rightImageView];
        
        self.textLabel.font = UIFontFromSize(12);
        self.textLabel.textColor = UIColorFromSixteenRGB(0x1e1e1e);
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.imageView.image = UIImageName(@"share_alipayLogo");
        self.textLabel.text = @"支付宝";
    }else
    {
        self.imageView.image = UIImageName(@"share_wxpayLogo");
        self.textLabel.text = @"微信";
    }
}

@end
