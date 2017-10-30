//
//  ModifyPasswordViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//
////////
#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *_oldPassword;
    UITextField *_password;
    UITextField *_pwdAgain;
}
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Reset password", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self initUI];
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

#pragma mark - UI

- (void)initUI {

    _oldPassword = [[UITextField alloc] init];
    _password = [[UITextField alloc] init];
    _pwdAgain = [[UITextField alloc] init];
    
    NSArray *textFieldArray = @[_oldPassword,_password,_pwdAgain];
    NSArray *labelArray = @[@"old password",@"new password",@"confirm the new password"];
    NSArray *placeholderArray = @[@"please enter your old password",@"Please enter your password (6 to 12)",@"Please enter your password again"];
    
    for (int i=0; i<3; i++) {
        
        //背景白条
        UIView *whiteView = [[UIView alloc] init];
        whiteView.frame = CGRectMake(0, 10+i*60, kScreenWidth, 50);
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:whiteView];
        
        //label
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 10, 60, 30);
        label.adjustsFontSizeToFitWidth = YES;
        NSString *localStr1 = [labelArray objectAtIndex:i];
        label.text = NSLocalizedString(localStr1, nil);
        label.font = [UIFont systemFontOfSize:13];
        [whiteView addSubview:label];
        
        // textField
        UITextField *textField = [textFieldArray objectAtIndex:i];
        textField.frame = CGRectMake(100, 10, kScreenWidth-100-20, 30);
        textField.adjustsFontSizeToFitWidth = YES;
        NSString *localStr2 = [placeholderArray objectAtIndex:i];
        textField.placeholder = NSLocalizedString(localStr2, nil);
        textField.font = [UIFont systemFontOfSize:13];
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        [whiteView addSubview:textField];
    }
    
    //完成button
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(0, 0, 44, 44);
    [finishButton addTarget:self action:@selector(modifyPwdFinish) forControlEvents:UIControlEventTouchUpInside];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [finishButton setTitleColor:UIColorFromRGB(255, 107, 108) forState:UIControlStateNormal];
    [self setNavRightButton:finishButton];
}

#pragma mark - Action 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_oldPassword resignFirstResponder];
    [_password resignFirstResponder];
    [_pwdAgain resignFirstResponder];
}

//修改按钮 发送请求
- (void)modifyPwdFinish {

    if ([self isSamePassword]) {
        
        [self showIndeterminate:@""];
        [LXRequest requestWithJsonDic:@{@"password":_oldPassword.text,@"changepassword":_password.text} andUrl:kURL(kUrlModifyPwd) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
            
            if (success) {
                
                if (JMCodeSuccess == result) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [self showSuccess:NSLocalizedString(@"reset password success", nil)];
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
    }else {
    
        [self showInfo:NSLocalizedString(@"password is not consistent for twice input", nil)];
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Others
//两次密码校对
- (BOOL)isSamePassword {

    if (_password.text.length && _pwdAgain.text.length) {
        
        if ([_password.text isEqualToString:_pwdAgain.text]) {
            
            return YES;
        }else {
        
            return NO;
        }
    }else {
    
        return NO;
    }
}

//- (void)updatemobileNo {
//
//    _mobileNo.text = [UserData userData].mobileNo;
//}

@end
