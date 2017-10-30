//
//  RealNameViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/4/28.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "RealNameViewController.h"
#import "WebViewController.h"

@interface RealNameViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,WebViewDelegate>
{
    UITextField *_name;
    UITextField *_id;
    UIButton *_certificateButton;
    NSMutableDictionary *_dic;
    UIButton *_selectButton;
    BOOL _isCertificateRuleSelect;
}
@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"实名认证";
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
    _dic = [[NSMutableDictionary alloc] init];
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

    [self.baseView removeFromSuperview];
    
    //姓名
    UIView *nameWhiteView = [[UIView alloc] init];
    nameWhiteView.frame = CGRectMake(0, 80, kScreenWidth, 40);
    nameWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameWhiteView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(20, 5, 80, 30);
    nameLabel.text = @"姓名";
    nameLabel.textColor = UIColorFromRGB(100, 100, 100);
    nameLabel.font = [UIFont systemFontOfSize:16];
    [nameWhiteView addSubview:nameLabel];
    
    _name = [[UITextField alloc] init];
    _name.frame = CGRectMake(120, 5, kScreenWidth-120-20, 30);
    _name.placeholder = @"输入身份证姓名";
    _name.font = [UIFont systemFontOfSize:14];
    _name.delegate = self;
    _name.returnKeyType = UIReturnKeyDone;
    [nameWhiteView addSubview:_name];
    
    //身份证号
    UIView *idWhiteView = [[UIView alloc] init];
    idWhiteView.frame = CGRectMake(0, 121, kScreenWidth, 40);
    idWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:idWhiteView];
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.frame = CGRectMake(20, 5, 80, 30);
    idLabel.text = @"身份证号";
    idLabel.textColor = UIColorFromRGB(100, 100, 100);
    idLabel.font = [UIFont systemFontOfSize:16];
    [idWhiteView addSubview:idLabel];
    
    _id = [[UITextField alloc] init];
    _id.frame = CGRectMake(120, 5, kScreenWidth-120-20, 30);
    _id.placeholder = @"输入身份证号";
    _id.font = [UIFont systemFontOfSize:14];
    _id.delegate = self;
    _id.returnKeyType = UIReturnKeyDone;
    [idWhiteView addSubview:_id];
    
    UIImage *driveRuleImg = UIImageName(@"certificateRule_sel");
    CGFloat imgWidth = driveRuleImg.size.width;
    
    //soda对用户的审核标准
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(10+imgWidth+5, 121+40+15, 130, 20);
    label1.textColor = UIColorFromRGB(185, 184, 184);
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"soda对用户的审核标准";
    [self.view addSubview:label1];
    
    //了解更多
    UIButton *learnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    learnButton.frame = CGRectMake(10+imgWidth+5+110, 121+40+15, 80, 20);
    [learnButton setTitle:@"了解更多" forState:UIControlStateNormal];
    [learnButton setTitleColor:UIColorFromRGB(225, 108, 86) forState:UIControlStateNormal];
    learnButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [learnButton addTarget:self action:@selector(learnMoreClick) forControlEvents:UIControlEventTouchUpInside];//点击事件
    [self.view addSubview:learnButton];
    
    //平台车辆须有本人租赁，不可代租、外借或运营
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(10, 121+40+15+20, kScreenWidth, 20);
    label2.textColor = UIColorFromRGB(185, 184, 184);
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"平台车辆须有本人租赁，不可代租、外借或运营";
    [self.view addSubview:label2];
    
    //提示内容
    //勾选框
    _isCertificateRuleSelect = YES;
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(0, 121+40+3, 44, 44);
    [_selectButton setImage:driveRuleImg forState:UIControlStateNormal];
    _isCertificateRuleSelect = YES;
    [_selectButton addTarget:self action:@selector(certificateRuleSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectButton];
    
    //认证提交
    UIImage *certificateButtonImg = UIImageName(@"uploadButton");
    CGFloat buttonImgHeight = certificateButtonImg.size.height;
    _certificateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _certificateButton.frame = CGRectMake(6, 121+40+15+20+20+35, kScreenWidth-12, buttonImgHeight);
    [_certificateButton setBackgroundImage:certificateButtonImg forState:UIControlStateNormal];
    [_certificateButton setTitle:@"提交" forState:UIControlStateNormal];
    _certificateButton.titleLabel.font = UIFontFromSize(18);
    [_certificateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certificateButton addTarget:self action:@selector(certificateID) forControlEvents:UIControlEventTouchUpInside];
//    _certificateButton.backgroundColor = UIColorFromRGB(255, 107, 108);
    [self.view addSubview:_certificateButton];
}

#pragma mark - Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_name resignFirstResponder];
    [_id resignFirstResponder];
}


- (void)certificateID {

    if (_name.text.length == 0) {
        
        [self showInfo:@"请输入姓名"];
    }else if (_id.text.length == 0){
        
        [self showInfo:@"请输入身份证号"];
    }else if (!_isCertificateRuleSelect) {
    
        [self showInfo:@"你未同意soda对用户的审核标准"];
    }else {
    
        if ([self isIDNo:_id.text]) {
            
            [_dic setObject:_name.text forKey:@"id_name"];
            [_dic setObject:_id.text forKey:@"id_no"];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"信息认证提交后不可更改，您是否确认提交？" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
        }else {
            
            [self showInfo:@"身份证号格式不正确"];
        }
    }
}

- (void)certificateRuleSelect {

    if (_isCertificateRuleSelect) {
        
        _isCertificateRuleSelect = NO;
    }else {
    
        _isCertificateRuleSelect = YES;
    }
    UIImage *img = _isCertificateRuleSelect?UIImageName(@"certificateRule_sel"):UIImageName(@"certificateRule_nor");
    [_selectButton setImage:img forState:UIControlStateNormal];
}

- (void)learnMoreClick {

    WebViewController *webViewController = [[WebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = @"实名认证说明";
    webViewController.delegate = self;
    [webViewController loadUrl:kURL(kE2EUrlShiMingRenZheng)];
    
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - request

//认证
- (void)requstForCertificateDriveLicense:(NSDictionary *)dic {
    
    [self showIndeterminate:@""];
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlIDCard) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                NSString *title = @"提交成功";
                NSString *message = @"Soda苏打将在1小时内进行审核，请稍候查看审核结果。";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
                [alert show];
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


#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location == 18 && [textField isEqual:_id]) {
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheet代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(0 == buttonIndex) {
        
        [self requstForCertificateDriveLicense:_dic];
    }else {
        
        ;
    }
}

# pragma mark - Others

//验证身份证号
- (BOOL)isIDNo:(NSString *)id {
    
    NSString *number = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identificationNo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [identificationNo evaluateWithObject:id];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
