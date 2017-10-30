//
//  ReturnCarTBCell.m
//  JoyMove
//
//  Created by Soda on 2017/9/12.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "ReturnCarTBCell.h"
#import "UserData.h"

@interface ReturnCarTBCell ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *desLbl;
@property(strong, nonatomic) UIPickerView *myPickerView;
@property(strong, nonatomic) UIToolbar *toolbar;
@property(strong, nonatomic) NSArray *dataArray;

@end

@implementation ReturnCarTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLbl.inputAccessoryView = self.toolbar;
    self.dataArray = @[@"地上三层",@"地上二层",@"地上一层",@"地面停车场",@"地下一层",@"地下二层",@"地下三层"];
    self.contentLbl.inputView = self.myPickerView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.contentLbl.enabled) {
            [self.contentLbl becomeFirstResponder];
        }
    }];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}

- (void)configure:(UITableViewCell *)cell customObj:(id)obj indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        self.contentLbl.placeholder = @"正在获取定位中";
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationCoordinate2D coord = [UserData share].userLocation.location.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error) {
            
            CLPlacemark *mark = [placemark objectAtIndex:0];
            NSMutableString *string = [mark.subLocality mutableCopy];
            
            if (mark.thoroughfare) {
                
                [string appendString:mark.thoroughfare];
            }
            if (mark.subThoroughfare) {
                
                [string appendString:mark.subThoroughfare];
            }
            self.contentLbl.text = string;
        }];
    }
    else if (indexPath.row == 2) {
        self.contentLbl.text = @"地面停车场";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentLbl.enabled = YES;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.contentLbl.text = self.dataArray[row];
}

#pragma mark - event response

// 点击了确定
- (void)certain
{
    [self.contentLbl resignFirstResponder];
}

#pragma mark - lazyLoad
- (UIPickerView *)myPickerView
{
    if (!_myPickerView) {
        _myPickerView = [[UIPickerView alloc] init];
        _myPickerView.dataSource = self;
        _myPickerView.delegate = self;
        
        [_myPickerView selectRow:3 inComponent:0 animated:NO];
    }
    return _myPickerView;
}

// 作为TextField的弹出视图的工具条
- (UIToolbar *)toolbar
{
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *certain = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(certain)];
        
        _toolbar.items = @[flexibleSpace,certain];
    }
    return _toolbar;
}
@end
