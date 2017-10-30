//
//  MyCarCell.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MyCarCell.h"
#import "MyCar.h"

@interface MyCarCell()

@property(nonatomic, strong) UILabel *statusLbl;
@property(nonatomic, strong) UISwitch *switchButton;
@property(nonatomic, strong) UILabel *switchStatusLbl;

@end

@implementation MyCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = UIColorFromRGB(118, 118, 119);
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailTextLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.statusLbl];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.switchStatusLbl];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    JMWeakSelf(self);
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.contentView).with.offset(-15);
        make.centerY.equalTo(weakself.contentView.mas_centerY);
    }];
    
    [self.switchStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.switchButton.mas_left).offset(-5);
        make.centerY.equalTo(weakself.contentView.mas_centerY);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
   
    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"车辆状态";
            self.statusLbl.hidden = NO;
            self.switchButton.hidden = YES;
            self.switchStatusLbl.hidden = YES;
        }else
        {
            self.statusLbl.hidden = YES;
            self.switchButton.hidden = YES;
            self.switchStatusLbl.hidden = YES;
        }
    
    
    if (indexPath.row == 0) {
        if ([MyCar shareIntance].isFree) {
            self.statusLbl.text = @"空闲中";
            self.statusLbl.backgroundColor = UIColorFromSixteenRGB(0x49c2f3);
        }else
        {
            self.statusLbl.text = @"租用中";
            self.statusLbl.backgroundColor = UIColorFromSixteenRGB(0xf66a4e);
        }
    }
    
    if (indexPath.row == 1) {
        self.detailTextLabel.text = kIsNSNull([MyCar shareIntance].userName)?@" ":[MyCar shareIntance].userName;
    }
    
    if (indexPath.row == 2 ) {
        
        cell.detailTextLabel.text = (NSString *)obj;
        NSString *tel = [cell.detailTextLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@"*********"];
        cell.detailTextLabel.text = tel;
    }
}

#pragma mark - event response

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.switchStatusLbl.text = @"已开启分享";
    }else {
        self.switchStatusLbl.text = @"未开启分享";
    }
}

#pragma mark - lazyLoad
- (UILabel *)statusLbl
{
    if (!_statusLbl) {
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15.0-50.0, (self.frame.size.height-20.0)*0.5, 50.0, 20.0)];
        _statusLbl.backgroundColor = UIColorFromSixteenRGB(0x49c2f3);
        _statusLbl.text = @"空闲中";
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl.layer.cornerRadius = 5.0;
        _statusLbl.layer.masksToBounds = YES;
        _statusLbl.textColor = [UIColor whiteColor];
        _statusLbl.font = UIFontFromSize(12.0);
    }
    return _statusLbl;
}

- (UILabel *)switchStatusLbl
{
    if (!_switchStatusLbl) {
        _switchStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15.0-50.0, (self.frame.size.height-20.0)*0.5, 50.0, 20.0)];
        _switchStatusLbl.text = @"未开启分享";
        _switchStatusLbl.textAlignment = NSTextAlignmentRight;
        _switchStatusLbl.textColor = [UIColor blackColor];
        _switchStatusLbl.font = UIFontFromSize(12.0);
        _switchStatusLbl.hidden = YES;
    }
    return _switchStatusLbl;
}

- (UISwitch *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(0.0, 0.0, 51.0, 31.0)];
        _switchButton.on = NO;
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _switchButton.onTintColor = UIColorFromRGB(30, 176, 245);
        _switchButton.hidden = YES;
        _switchButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }
    return _switchButton;
}
@end
