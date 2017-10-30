//
//  RegisterViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "RegisterViewController.h"
#import "TimeButton.h"
#import "WebViewController.h"
#import "MiPushSDK.h"
#import "Tool.h"
#import "SDCUUID.h"
#import "UIAlertController+Blocks.h"

@interface RegisterViewController ()<UITextFieldDelegate,TimeButtonDelegate> {

    UILabel     *_checkMobileNo;      //手机号是否注册过
    UITextField *_mobileNo;           //手机号
    UITextField *_verificationText;   //验证码
    UITextField *_password;           //密码
    UITextField *_pwdAgain;           //确认密码
    UITextField *_invitationCode;     //邀请码
    TimeButton  *_verificationButton; //获取验证码button
    UIButton    *_registerButton;     //下一步按钮
    UIButton    *_agreementButton;    //协议按钮
}
@end

@implementation RegisterViewController

const NSInteger mobileNoLength = 11;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Register", nil);
//    [self setNavBackButtonTitle:@"返回"];
    [self setNavBackButtonStyle:BVTagBack];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    AddObserver(UITextFieldTextDidChangeNotification, textFieldDidChange);
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [_verificationButton stop:NSLocalizedString(@"Verify", nil)];
    
    [self hideKeyborad];
    
    RemoveObserver(self, UITextFieldTextDidChangeNotification);
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
    
    //提示label
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.frame = CGRectMake(0, 11, kScreenWidth, 20);
    noteLabel.text = NSLocalizedString(@"To ensure the authenticity of the information please verify the phone.", nil);
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.textColor = [UIColor lightGrayColor];
    noteLabel.font = [UIFont systemFontOfSize:12];
    [self.baseView addSubview:noteLabel];

    //手机号输入框
    _mobileNo = [[UITextField alloc] init];
    _mobileNo.frame = CGRectMake(20, 40, kScreenWidth-110, 40);
    _mobileNo.borderStyle = UITextBorderStyleRoundedRect;
    _mobileNo.placeholder = NSLocalizedString(@"Phone number", nil);
    _mobileNo.keyboardType = UIKeyboardTypeNumberPad;
    _mobileNo.returnKeyType = UIReturnKeyDone;
    _mobileNo.delegate = self;
    [self.baseView addSubview:_mobileNo];
    
    //手机号检查
    _checkMobileNo = [[UILabel alloc] init];
    CGFloat mobileNoWith = _mobileNo.frame.size.width;
    _checkMobileNo.frame = CGRectMake(mobileNoWith-65, 10, 60, 20);
    _checkMobileNo.textColor = UIColorFromRGB(255, 107, 108);
    _checkMobileNo.font = [UIFont systemFontOfSize:12];
    _checkMobileNo.textAlignment = NSTextAlignmentRight;
    [_mobileNo addSubview:_checkMobileNo];
    
    //获取验证码Button
    _verificationButton = [TimeButton buttonWithType:UIButtonTypeRoundedRect];
    _verificationButton.frame = CGRectMake(kScreenWidth-80, 40, 60, 40);
    _verificationButton.timeButtonDelegate = self;
    [_verificationButton setTitle:NSLocalizedString(@"Verify", nil) forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(requstForCheckMobileNo) forControlEvents:UIControlEventTouchUpInside];
    _verificationButton.layer.cornerRadius = 4;
    _verificationButton.layer.masksToBounds = YES;
    _verificationButton.buttonUsableStatus = YES;
    [self setButtonType:0 andButton:_verificationButton];
    [self.baseView addSubview:_verificationButton];
    
    //验证码输入框
    _verificationText = [[UITextField alloc] init];
    _verificationText.frame = CGRectMake(20, 90, kScreenWidth-40, 40);
    _verificationText.borderStyle = UITextBorderStyleRoundedRect;
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.returnKeyType = UIReturnKeyDone;
    _verificationText.delegate = self;
    _verificationText.placeholder = NSLocalizedString(@"Verification code", nil);
    [self.baseView addSubview:_verificationText];
    
    //密码
    _password = [[UITextField alloc]init];
    _password.frame = CGRectMake(20, 140, kScreenWidth-40, 40);
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.keyboardType = UIKeyboardTypeDefault;
    _password.delegate = self;
    _password.returnKeyType = UIReturnKeyDone;
    _password.secureTextEntry = YES;
    _password.placeholder = NSLocalizedString(@"Please enter your password (6 to 12)", nil);
    [self.baseView addSubview:_password];
    
    //请再次输入密码
    _pwdAgain = [[UITextField alloc]init];
    _pwdAgain.frame = CGRectMake(20, 190, kScreenWidth-40, 40);
    _pwdAgain.borderStyle = UITextBorderStyleRoundedRect;
    _pwdAgain.keyboardType = UIKeyboardTypeDefault;
    _pwdAgain.delegate = self;
    _pwdAgain.returnKeyType = UIReturnKeyDone;
    _pwdAgain.secureTextEntry = YES;
    _pwdAgain.placeholder = NSLocalizedString(@"Please enter your password again", nil);
    [self.baseView addSubview:_pwdAgain];
    
    //推荐码
    _invitationCode = [[UITextField alloc] init];
    _invitationCode.frame = CGRectMake(20, 240, kScreenWidth-40, 40);
    _invitationCode.borderStyle = UITextBorderStyleRoundedRect;
    _invitationCode.keyboardType = UIKeyboardTypeDefault;
    _invitationCode.delegate = self;
    _invitationCode.returnKeyType = UIReturnKeyDone;
    _invitationCode.placeholder = NSLocalizedString(@"Please enter an invitation code (optional)", nil);
    [self.baseView addSubview:_invitationCode];
    
    //注册按钮
    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _registerButton.frame = CGRectMake(20, 295, kScreenWidth-40, 40);
    [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [self setButtonType:0 andButton:_registerButton];
    _registerButton.layer.cornerRadius = 4;
    _registerButton.layer.masksToBounds = YES;
    [self.baseView addSubview:_registerButton];
    
    //协议label
    UILabel *agreementLabel = [[UILabel alloc] init];
    agreementLabel.frame = CGRectMake(0, 350, kScreenWidth, 20);
    agreementLabel.text = NSLocalizedString(@"Click to register and that means you agree with this agreement", nil);
    agreementLabel.textColor = [UIColor lightGrayColor];
    agreementLabel.font = [UIFont systemFontOfSize:12];
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    agreementLabel.adjustsFontSizeToFitWidth = YES;
    [self.baseView addSubview:agreementLabel];
    
    //协议
    _agreementButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _agreementButton.frame = CGRectMake((kScreenWidth-120)/2, 375, 120, 20);
    [_agreementButton setTitle:NSLocalizedString(@"《User Agreement》", nil) forState:UIControlStateNormal];
    [_agreementButton setTitleColor:UIColorFromRGB(52, 52, 52) forState:UIControlStateNormal];
    _agreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_agreementButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:_agreementButton];
}

#pragma mark - Action

- (void)hideKeyborad {

    [_mobileNo resignFirstResponder];
    [_verificationText resignFirstResponder];
    [_password resignFirstResponder];
    [_pwdAgain resignFirstResponder];
    [_invitationCode resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)button {
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = NSLocalizedString(@"User Agreement", nil);
    
//    NSString *userAgreement=[Tool getCache:@"UserAgreement"];
//    if (userAgreement.length>0)
//    {
//        [webViewController loadUrl:userAgreement];
//    }
//    else
//    {
        [webViewController loadUrl:kURL(kE2EUrlYongHuXieYi)];
//    }
    
    
    [self presentViewController:navi animated:YES completion:nil];
}

//检测手机号是否已注册
- (void)requstForCheckMobileNo {
    
    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text} andUrl:kURL(kUrlCheckMobileNo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (10000 == result) {  //手机号没注册过，获取验证码
                
                [self requstForVerificationNum];
                
                _checkMobileNo.text = @"";
            }else {     //手机号已注册
                
                _checkMobileNo.text = NSLocalizedString(@"Registered", nil);
            }
        }else {
            
            _checkMobileNo.text = NSLocalizedString(@"No internet connection available", nil);
        }
    }];
}

//获取指定手机号的验证码
- (void)requstForVerificationNum {

    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text} andUrl:kURL(kUrlDynamicPwsGen) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (10000 == result) {
                
                NSLog(@"获取到验证码");
                _checkMobileNo.text = NSLocalizedString(@"Sent", nil);
                [_verificationButton setTime:60];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

//跳转事件
- (void)registerButtonClick {

    if ([self isSamePassword]) {
        
        [self requstForRegister];
    }else {
    
        [self showInfo:NSLocalizedString(@"Entered passwords differ", nil)];
    }
    
}

- (void)requstForRegister {

    [self showIndeterminate:@""];
    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text,@"code":_verificationText.text,@"password":_password.text,@"invitationCode":_invitationCode.text,@"cityCode":[Tool getCache:@"firstLocalCityCode"]} andUrl:kURL(kUrlRegister) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        [self hide];
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                NSLog(@"注册成功");
                //自动登录
                [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text,@"password":_password.text,@"deviceId":[SDCUUID getUUID]} andUrl:kURL(kUrlLogin) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    [self hide];
                    if (success) {
                        
                        if (JMCodeSuccess == result) {
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [UserData userData].authToken = kIsNSString(response[@"authToken"])?response[@"authToken"]:@"";
                            [UserData userData].mobileNo = _mobileNo.text;
                            [MiPushSDK setAccount:[UserData userData].mobileNo];
                            
                            PostNotification(@"presentDriverLicence");
                            
                        }else if(result == 10014)
                        {
                            [self callService];
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
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }
    }];
}

- (void)callService
{
    NSString *message = [NSString stringWithFormat:@"您的帐号已与其他设备绑定，如有疑问请拨打客服电话：\n%@",serviceTelephoneDes];
    UIAlertController *alertController = [UIAlertController showAlertInViewController:self withTitle:@"联系客服" message:message cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil
                                                                             tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                                                 if (buttonIndex == 1) {
                                                                                     NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
                                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                                                 }
                                                                             }];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:serviceTelephoneDes].location, [[noteStr string] rangeOfString:serviceTelephoneDes].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromSixteenRGB(0x0096ed) range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:UIBoldFontFromSize(16) range:redRange];
    
    [alertController setValue:noteStr forKey:@"attributedMessage"];
}

//设置button的状态
- (void)setButtonType:(NSInteger)btnType andButton:(UIButton *)button {

    if (0 == btnType) {
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(210, 210, 210);
        button.enabled = NO;
    }else {
    
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(236, 105, 65);
        button.enabled = YES;
    }
}

//正则表达式判断是否是手机号
-(BOOL)isMobileNumber:(NSString *)mobileNumber{
    
    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$";
    NSPredicate *registerMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if ([registerMobile evaluateWithObject:mobileNumber] == YES)
        return YES;
    else
        return NO;
}

//判断密码和第二次输入密码是否一致
- (BOOL)isSamePassword {

    if ([_password.text isEqualToString:_pwdAgain.text]) {
        
        return YES;
    }else {
        
        return NO;
    }
}

#pragma mark - UITextField代理方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_mobileNo resignFirstResponder];
    [_verificationText resignFirstResponder];
    [_password resignFirstResponder];
    [_pwdAgain resignFirstResponder];
    [_invitationCode resignFirstResponder];
}

- (void)textFieldDidChange {

    if (mobileNoLength == _mobileNo.text.length && _verificationButton.buttonUsableStatus) {
        
        [self setButtonType:1 andButton:_verificationButton];
//        _mobileNO.enabled = NO;
    }else {
    
        [self setButtonType:0 andButton:_verificationButton];
        _checkMobileNo.text = @"";
    }
    
//    if (4 == _verificationText.text.length) {
//        
//        _verificationText.enabled = NO;
//    }else {
//    
//        ;
//    }
    
    if (_verificationText.text.length != 0 && _mobileNo.text.length != 0 && _password.text.length != 0 && _pwdAgain.text.length != 0) {
        
        [self setButtonType:1 andButton:_registerButton];
    }else {
    
        [self setButtonType:0 andButton:_registerButton];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == _mobileNo) {
        
        if (range.location == 11) {
            
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _password || textField == _pwdAgain || textField == _invitationCode) {
        
        NSTimeInterval animationDuration = 0.3f;
        [UIView beginAnimations:@"resizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.baseView.frame = CGRectMake(0, -23, kScreenWidth, kScreenHeight-64);
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"resizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.baseView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TimeButtonDelegate

- (void)updateTimeButtonStatus {

    if (_mobileNo.text.length == mobileNoLength && _verificationButton.buttonUsableStatus) {
        
        [self setButtonType:1 andButton:_verificationButton];
    }
}

@end
