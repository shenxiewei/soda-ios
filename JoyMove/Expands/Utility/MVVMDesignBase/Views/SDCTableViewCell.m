//
//  SDCTableViewCell.m
//  JoyMove
//
//  Created by Soda on 2017/5/5.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import "SDCTableViewCell.h"
#import "SDCTBViewCellModel.h"

@implementation SDCTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self sdc_setupViews];
        [self sdc_bindViewModel];
        
        //default config
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        self.detailTextLabel.textColor = [UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)sdc_setupViews{}

- (void)sdc_bindViewModel{}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    SDCTBViewCellModel *model = (SDCTBViewCellModel *)obj;
    cell.textLabel.text = model.text;
    cell.detailTextLabel.text = model.detailText;
    cell.imageView.image = model.headImg;
    
}
@end
