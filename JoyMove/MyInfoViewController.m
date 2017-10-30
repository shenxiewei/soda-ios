//
//  MyInfoViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/8/19.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "MyInfoViewController.h"
#import "Macro.h"
#import "ModifyPasswordViewController.h"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITableView *_infoTableView;
    NSArray *_infoArray;
    
    UITextField *_nickName;                          //昵称
    NSInteger _genderIndex;                          //性别
    UILabel *_genderLabel;
    
    UIPickerView *_picker;                         //性别选择器
    NSArray *_pickerDataSource;                    //选择器内容
    BOOL _pickerIsShow;                            //pickerView是否弹起
}

typedef NS_ENUM(NSInteger, PersonalSheetTag) {
    
    PersonalSheetTagFace = 100,
    PersonalSheetTagVoiceprint,
};

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Personal Information", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self initDate];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requstForPersonalInfo];
    [_infoTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    _genderIndex = [UserData userData].genderIndex;       //删除临时选项，恢复为线上数据
    [self hideKeyborad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initDate {

    _genderIndex = 0;
    _pickerIsShow = NO;
    _infoArray = @[@"nickName",@"gender",@"modifyPwd"];
}

- (void)initUI {

    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.userInteractionEnabled = YES;
    _infoTableView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
    _infoTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_infoTableView];
    _infoTableView.tableFooterView = [[UIView alloc] init];
    
    //保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    NSString *localStr = NSLocalizedString(@"Save", nil);
    [saveButton setTitle:localStr forState:UIControlStateNormal];
    [saveButton setTitleColor:UIColorFromRGB(255, 107, 108) forState:UIControlStateNormal];
    saveButton.titleLabel.font = UIFontFromSize(14);
    [saveButton addTarget:self action:@selector(savePersonalInfo) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:saveButton];
    
    [self initPickerView];
}

- (void)initPickerView {
    
    _pickerDataSource = @[NSLocalizedString(@"Mr.", nil), NSLocalizedString(@"Mrs.", nil)];
    
    _picker = [[UIPickerView alloc] init];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
    _picker.showsSelectionIndicator = YES;
    _picker.delegate = self;
    _picker.dataSource = self;
    [self.view addSubview:_picker];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
//    if (0 == section) {
//        
//        return 3;
//    }else {
//        
//        return 2;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellName";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    CGFloat cellHight = cell.frame.size.height;
    if (0 == indexPath.section) {
        
        UIImage *image = [UIImage imageNamed:[_infoArray objectAtIndex:indexPath.row]];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(30, (cellHight-24)/2, 24, 24);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = image;
        [cell.contentView addSubview:imgView];

        //昵称、性别、修改密码
        if (0 == indexPath.row) {

            cell.accessoryType = UITableViewCellAccessoryNone;

            if (!_nickName) {

                _nickName = [[UITextField alloc] init];
                _nickName.frame = CGRectMake(80, (cellHight-30)/2, kScreenWidth-80-20, 30);
                _nickName.font = UIFontFromSize(15);
                _nickName.delegate = self;
                _nickName.returnKeyType = UIReturnKeyDone;
                _nickName.placeholder = NSLocalizedString(@"Nickname", nil);
                _nickName.textColor = UIColorFromRGB(120, 120, 120);
            }
            _nickName.text = [UserData userData].nickname?[UserData userData].nickname:@"";
            [cell.contentView addSubview:_nickName];
        }else if (1 == indexPath.row) {

            cell.accessoryType = UITableViewCellAccessoryNone;

            if (!_genderLabel) {

                _genderLabel = [[UILabel alloc] init];
                _genderLabel.frame = CGRectMake(80, (cellHight-30)/2, 50, 30);
                _genderLabel.text = NSLocalizedString(@"Mr.", nil);
                _genderLabel.textColor = UIColorFromRGB(120, 120, 120);
                _genderLabel.font = UIFontFromSize(15);
            }

            if (_genderIndex) {

                _genderLabel.text = NSLocalizedString(@"Mrs.", nil);
            }else {

                _genderLabel.text = NSLocalizedString(@"Mr.", nil);
            }
            [cell.contentView addSubview:_genderLabel];
        }else {

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            UILabel *modifyLabel = [[UILabel alloc] init];
            modifyLabel.frame = CGRectMake(80, (cellHight-30)/2, 60, 30);
            modifyLabel.text = NSLocalizedString(@"Reset password", nil);
            modifyLabel.textColor = UIColorFromRGB(120, 120, 120);
            modifyLabel.font = [UIFont systemFontOfSize:15];
            modifyLabel.adjustsFontSizeToFitWidth = YES;
            [cell.contentView addSubview:modifyLabel];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {

            [_nickName becomeFirstResponder];
        }else if (1 == indexPath.row) {

            [self pushPickerView];
        }else {
            
            [self modifyPassword];
        }
    }
    [self resignTextFieldEdit];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self resignTextFieldEdit];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.frame = CGRectMake(0, 0, kScreenWidth, 20);
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.textColor = UIColorFromRGB(180, 180, 180);
//
//    if (0 == section) {
//
//        titleLabel.text = @"  基本信息";
//    }else {
//
//        titleLabel.text = @"  生物特征";
//    }
//
//    return titleLabel;
//}

#pragma mark - UIPickerViewDelegate
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerDataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _genderLabel.text = [_pickerDataSource objectAtIndex:row];
    _genderIndex = row;
    //    [self dismissPickerView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self dismissPickerView];
    return YES;
}

#pragma mark - Action

- (void)hideKeyborad {

    [_nickName resignFirstResponder];
}

- (void)resignTextFieldEdit {
    
    [self hideKeyborad];
    [self dismissPickerView];
}

//修改密码事件
- (void)modifyPassword {
    
    ModifyPasswordViewController *modifyPasswordViewController = [[ModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyPasswordViewController animated:YES];
}

#pragma mark - UIPickerView
//弹出pickerView
- (void)pushPickerView {
    
    if (!_pickerIsShow) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            //            _infoTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
            _picker.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
        } completion:^(BOOL finished) {
            
            _pickerIsShow = YES;
        }];
    }
}

//收起pickerView
- (void)dismissPickerView {
    
    if (_pickerIsShow) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            //            _infoTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
            _picker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
        } completion:^(BOOL finished) {
            
            _pickerIsShow = NO;
        }];
    }
}

#pragma mark - Requst

- (void)requstForPersonalInfo {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlBaseInfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [UserData userData].genderIndex = IntegerFormObject(response[@"gender"]);
                _genderIndex = [UserData userData].genderIndex;
                [UserData userData].nickname = (response[@"username"]&&kIsNSString(response[@"username"]))?response[@"username"]:@"";
                [UserData savaData];
                [_infoTableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//保存用户信息
- (void)savePersonalInfo {
    
    NSDictionary *dic;
    if (_nickName.text.length) {
        dic = @{@"username":_nickName.text,@"gender":[NSString stringWithFormat:@"%ld", (long)_genderIndex]};
    }else {
        
        dic = @{@"gender":[NSString stringWithFormat:@"%ld", (long)_genderIndex]};
    }
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlModifyInfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self dismissPickerView];
                [self showSuccess:NSLocalizedString(@"New password available", nil)];
                [UserData userData].nickname = _nickName.text?_nickName.text:@"";
                [UserData savaData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

@end
