//
//  LoginViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "VerificationForForgetViewController.h"
#import "MiPushSDK.h"
#import "WXApi.h"
#import "SDCUUID.h"
#import "UIAlertController+Blocks.h"
#import "JoyMove-Swift.h"

@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,WXApiDelegate> {
    
    UIScrollView *_scrollView;
    CGPoint _currentContentOffset;
    UITextField *_mobileNo;
    UITextField *_password;
    UIButton *_weChatlogin;
}
@end

typedef NS_ENUM(NSInteger, LoginViewTag) {

    LVTagLogin = 100,
    LVTagWeChatLogin,
    LVTagRegister,
    LVTagForget,
};

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Login", nil);
//    [self setNavBackButtonTitle:@"返回"];
    [self setNavBackButtonStyle:BVTagCancel];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([WXApi isWXAppInstalled]) {
        
        _weChatlogin.hidden = YES;
    }else{
        _weChatlogin.hidden = YES;
    }
    // 微信登陆回调code
    AddObserver(@"weChatLogin", weChatLogin:);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_mobileNo resignFirstResponder];
    [_password resignFirstResponder];
    RemoveObserver(self, @"weChatLogin");

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

    [self.baseView removeFromSuperview];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //电动车图片
    UIImage *carImg = [UIImage imageNamed:@"loginLogo"];
    UIImageView *carView = [[UIImageView alloc]init];
    carView.frame = CGRectMake((kScreenWidth-carImg.size.width)/2, 21, carImg.size.width, carImg.size.height);
    carView.image = carImg;
    [_scrollView addSubview:carView];
    
    //用户名和密码
    UIImage *whiteImg = [UIImage imageNamed:@"loginWhiteBg"];
    whiteImg = [whiteImg stretchableImageWithLeftCapWidth:100 topCapHeight:10];
    UIImageView *whiteView = [[UIImageView alloc]init];
    whiteView.frame = CGRectMake(10, 177, kScreenWidth-20, whiteImg.size.height);
    whiteView.image = whiteImg;
    whiteView.userInteractionEnabled = YES;
    [_scrollView addSubview:whiteView];
    
    _mobileNo = [[UITextField alloc]init];
    _password = [[UITextField alloc]init];
    _password.secureTextEntry = YES;
    _mobileNo.delegate = self;
    _password.delegate = self;
    NSArray *imgArr = @[@"user",@"pwd"];
    NSArray *labelArr = @[NSLocalizedString(@"Please enter your phone number", nil), NSLocalizedString(@"Please enter your password", nil)];
    NSArray *textFieldArr = @[_mobileNo,_password];
    for (int i=0; i<2; i++) {
        
        UIImage *img = [UIImage imageNamed:[imgArr objectAtIndex:i]];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(12, 16+i*46, img.size.width, img.size.height);
        imgView.image = img;
        [whiteView addSubview:imgView];
        
        UITextField *textField = [textFieldArr objectAtIndex:i];
        textField.frame = CGRectMake(48, 13+i*47, kScreenWidth-20-55, 30);
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = [labelArr objectAtIndex:i];
        if (textField == _mobileNo) {
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.returnKeyType = UIReturnKeyDone;
        [whiteView addSubview:textField];
    }
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 290, kScreenWidth-20, 40);
    loginBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
    [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    loginBtn.layer.cornerRadius = 4;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = LVTagLogin;
    [_scrollView addSubview:loginBtn];
    
    //微信登陆
    _weChatlogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _weChatlogin.frame = CGRectMake(10, CGRectGetMaxY(loginBtn.frame) + 10, 110, 30);
    [_weChatlogin setTitle:NSLocalizedString(@"微信登录", nil) forState:UIControlStateNormal];
    [_weChatlogin setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    [_weChatlogin setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _weChatlogin.titleLabel.adjustsFontSizeToFitWidth = YES;
    _weChatlogin.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_weChatlogin setImage:[UIImage imageNamed:@"weChatlogin"] forState:UIControlStateNormal];
    _weChatlogin.titleLabel.font = [UIFont systemFontOfSize:14];
    [_weChatlogin addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _weChatlogin.tag = LVTagWeChatLogin;
    [_scrollView addSubview:_weChatlogin];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetBtn.frame = CGRectMake(kScreenWidth-100, 340, 80, 30);
    [forgetBtn setTitle:NSLocalizedString(@"Forgot password?", nil) forState:UIControlStateNormal];
    forgetBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [forgetBtn setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    forgetBtn.tag = LVTagForget;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:forgetBtn];
    
    UIImage *orImg = [UIImage imageNamed:@"orImage"];
    UIView *grayLine = [[UIView alloc] init];
    grayLine.frame = CGRectMake(10, 402+orImg.size.height/2, kScreenWidth-20, 1);
    grayLine.backgroundColor = UIColorFromRGB(180, 181, 181);
    [_scrollView addSubview:grayLine];

    UIImageView *orView = [[UIImageView alloc] init];
    orView.frame = CGRectMake((kScreenWidth-orImg.size.width)/2, 402, orImg.size.width, orImg.size.height);
    orView.image = orImg;
    [_scrollView addSubview:orView];
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(10, 464, kScreenWidth-20, 40);
    registerBtn.backgroundColor = [UIColor whiteColor];
    [registerBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    registerBtn.layer.cornerRadius = 4;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = LVTagRegister;
    [_scrollView addSubview:registerBtn];
    
    CGFloat y = (464+40+50)>(kScreenHeight-64)?(464+40+50):(kScreenHeight-64+1);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, y);
}

#pragma mark - Action

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [_mobileNo resignFirstResponder];
    [_password resignFirstResponder];
}

//登录按钮事件
- (void)buttonClick:(UIButton *)sender {

    if (LVTagLogin == sender.tag) {
        
        [self requestForLogin];
    }else if (LVTagRegister == sender.tag) {
        
        RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:registerViewController animated:YES];
    }else if (sender.tag == LVTagWeChatLogin){
        
        //构造SendAuthReq结构体
        SendAuthReq* req = [[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
//        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
        
    }else {
    
        VerificationForForgetViewController *verificationForForgetViewController = [[VerificationForForgetViewController alloc] init];
        [self.navigationController pushViewController:verificationForForgetViewController animated:YES];
    }
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _currentContentOffset = _scrollView.contentOffset;
    CGFloat y = _scrollView.contentSize.height - kScreenHeight;
    
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"resizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (_currentContentOffset.y < y) {
        
        _scrollView.contentOffset = CGPointMake(0, y);
    }
    [UIView commitAnimations];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    NSTimeInterval animationDuration = 0.3f;
//    [UIView beginAnimations:@"resizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    if (_currentContentOffset.y != _scrollView.contentOffset.y) {
//        
//        _scrollView.contentOffset = _currentContentOffset;
//    }
//    [UIView commitAnimations];
//}

// 微信登陆
- (void)weChatLogin:(NSNotification *)notif
{
    NSDictionary *dic = notif.userInfo;
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlWeChatLogin) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess) {
                
                NSInteger isBound = IntegerFormObject(response[@"bound"]);
                if (isBound == 1) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [UserData userData].authToken = kIsNSString(response[@"authToken"])?response[@"authToken"]:@"";
                    [UserData userData].mobileNo = kIsNSString(response[@"mobile"])?response[@"mobile"]:@"";
                    [UserData savaData];
                    [MiPushSDK setAccount:[UserData userData].mobileNo];
                    
                }else{
                    
                    NSString *sessionId = response[@"sessionId"];
                    MobileBindingViewController *mobileBindingVC = [[MobileBindingViewController alloc] init];
                    mobileBindingVC.sessionId = sessionId;
                    [self.navigationController pushViewController:mobileBindingVC animated:YES];
                    
                }
            }else if(result == 10014)
            {
                [self callService];
            }
            else if (result == JMCodeNeedLogin){
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }else {
                
                NSString *errMsg = response[@"errMsg"];
                errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                [self showError:errMsg];
            }
        }else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (_password == textField) {
        
        [self requestForLogin];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - request
//登录请求
- (void)requestForLogin {

    if (_mobileNo.text.length == 0) {
        
        [self showInfo:NSLocalizedString(@"Please enter your phone number", nil)];
        return;
    }
    if (_password.text.length == 0) {
        
        [self showInfo:NSLocalizedString(@"Please enter your password", nil)];
        return;
    }
    
    [self showIndeterminate:NSLocalizedString(@"Signing", nil)];
    [LXRequest requestWithJsonDic:@{@"mobileNo":_mobileNo.text,@"password":_password.text,@"deviceId":[SDCUUID getUUID]} andUrl:kURL(kUrlLogin) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        [self hide];
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                if (self.pushRootViewController)
                {
                    self.pushRootViewController();
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [UserData userData].authToken = kIsNSString(response[@"authToken"])?response[@"authToken"]:@"";
                [UserData userData].mobileNo = _mobileNo.text;
                [UserData savaData];
                [MiPushSDK setAccount:[UserData userData].mobileNo];
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
@end
