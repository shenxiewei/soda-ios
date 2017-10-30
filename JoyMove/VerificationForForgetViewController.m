//
//  VerificationForForgetViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/25.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
// <忘记密码 获取验证码>

#import "VerificationForForgetViewController.h"
#import "ForgetPasswordViewController.h"

@interface VerificationForForgetViewController ()<UITextFieldDelegate>
{
    UITextField *_mobileNo;
}
@end

@implementation VerificationForForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    self.title = NSLocalizedString(@"reset password", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    
    //手机号输入
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(0, 74, kScreenWidth, 50);
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.frame = CGRectMake(20, 10, 60, 30);
    mobileLabel.text = NSLocalizedString(@"Phone number", nil);
    mobileLabel.adjustsFontSizeToFitWidth = YES;
    mobileLabel.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:mobileLabel];
    
    _mobileNo = [[UITextField alloc] init];
    _mobileNo.frame = CGRectMake(100, 10, kScreenWidth-100-20, 30);
    _mobileNo.delegate = self;
    _mobileNo.keyboardType = UIKeyboardTypeNumberPad;
    _mobileNo.placeholder = NSLocalizedString(@"Please enter your phone number", nil);
    _mobileNo.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:_mobileNo];
    
    UITextView *noteTextView = [[UITextView alloc] init];
    noteTextView.frame = CGRectMake(20, 128, kScreenWidth-40, 50);
    noteTextView.font = [UIFont systemFontOfSize:12];
    noteTextView.text = NSLocalizedString(@"you will get  a massage after entering your phone number。", nil);
    noteTextView.editable = NO;
    noteTextView.backgroundColor = UIColorFromRGB(242, 242, 242);
    noteTextView.textColor = [UIColor lightGrayColor];
    [self.view addSubview:noteTextView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame = CGRectMake(0, 0, 60, 44);
    [nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextButton setTitleColor:UIColorFromRGB(255, 107, 108) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:nextButton];
}

#pragma mark - Action
- (void)nextButtonAction {

    [self requestForcheckMobileNo];
}

#pragma mark - Request 

- (void)requestForcheckMobileNo {

    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text} andUrl:kURL(kUrlCheckMobileNo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            //当10003说明手机号已经存在 
            if (10003 == result)
            {
                [self requstForVerificationNo];
                ForgetPasswordViewController *forgetViewController = [[ForgetPasswordViewController alloc] init];
                forgetViewController.mobileNo = _mobileNo.text;
                [self.navigationController pushViewController:forgetViewController animated:YES];
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

- (void)requstForVerificationNo {

    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text} andUrl:kURL(kUrlDynamicPwsGen) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
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


#pragma mark - UItextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_mobileNo resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == _mobileNo) {
        
        if (range.location == 11) {
            
            return NO;
        }
    }
    return YES;
}

@end
