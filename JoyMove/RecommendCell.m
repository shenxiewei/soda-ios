//
//  RecommendCell.m
//  JoyMove
//
//  Created by 刘欣 on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "RecommendCell.h"
#import "UtilsMacro.h"
#import "ColorMacro.h"

typedef NS_ENUM(NSInteger, RouteTag) {

    CellBackViewTag = 301,
    CellTitleTag,
    CellRouteTag,                    
};

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = KBackgroudColor;
        [self initRecommendCell];
    }
    return self;
}

- (void)initRecommendCell {

    UIImageView *backView = [[UIImageView alloc] init];
    backView.tag = CellBackViewTag;
    [self.contentView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(20, 10, 100, 30);
    titleLabel.tag = CellTitleTag;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [backView addSubview:titleLabel];
    
    UILabel *routeLabel = [[UILabel alloc] init];
    routeLabel.tag = CellRouteTag;
    routeLabel.textColor = UIColorFromRGB(120, 120, 120);
    routeLabel.font = UIFontFromSize(16);
    [backView addSubview:routeLabel];
}

- (void)updateRecommendCell {

    UILabel *titleLabel = (UILabel *)[self viewWithTag:CellTitleTag];
    titleLabel.text = self.title;
    
//    NSString *str = @"hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello";
    UILabel *routeLabel = (UILabel *)[self viewWithTag:CellRouteTag];
    routeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [self.route sizeWithFont:UIFontFromSize(16) constrainedToSize:CGSizeMake(kScreenWidth-60, 400.0f) lineBreakMode:NSLineBreakByWordWrapping];
    routeLabel.numberOfLines = 0;
    routeLabel.frame = CGRectMake(20, 40, kScreenWidth-60, size.height);
    [routeLabel setText:self.route];
    
    CGFloat height = size.height + 30 + 20 + 10;
    UIImage *img = [UIImage imageNamed:@"recommendBg"];
    CGSize backSize = CGSizeMake(kScreenWidth-20, height);
    UIGraphicsBeginImageContext(backSize);
    [img drawInRect:CGRectMake(0, 0, kScreenWidth-20, height)];
    UIImage *backImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *backView = (UIImageView *)[self viewWithTag:CellBackViewTag];
    backView.frame = CGRectMake(10, 0, kScreenWidth-20, height);
    backView.image = backImg;
}

- (float)height {

//    NSString *str = @"hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello";
    CGSize size = [self.route sizeWithFont:UIFontFromSize(16) constrainedToSize:CGSizeMake(kScreenWidth-60, 400.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height + 30 + 20 + 20;
    return height;
}

@end
