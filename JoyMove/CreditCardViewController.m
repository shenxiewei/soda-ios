//
//  CreditCardViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/8/7.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "CreditCardViewController.h"
#import "Macro.h"
#import "PromptView.h"
#import "CreditCardCell.h"
#import "WebViewController.h"
#import "Tool.h"

@interface CreditCardViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PromptViewDelegate>
{
    UITableView *_tableView;
    UIButton *_selectButton;
    BOOL _isCertificateRuleSelect;
    PromptView *_promptView;
    
    UITextField *_cardname;             //信用卡用户名
    UITextField *_idcard;               //信用卡持卡人身份证号
    UITextField *_bankcardnum;          //信用卡卡号
    UITextField *_mobilephone;          //信用卡手机号
    UITextField *_cvv2;                 //信用卡cvv2
    UITextField *_expiredate;           //信用卡有效期
    NSArray *_textFieldArray;           //存储UITextField
}
@end

@implementation CreditCardViewController

const float cellHeight = 45;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUITextField];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self hideKeyborad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initUITextField {

    _cardname = [[UITextField alloc] init];
    _idcard = [[UITextField alloc] init];
    _bankcardnum = [[UITextField alloc] init];
    _expiredate = [[UITextField alloc] init];
    _cvv2 = [[UITextField alloc] init];
    _mobilephone = [[UITextField alloc] init];
    _textFieldArray = @[_cardname,_idcard,_bankcardnum,_expiredate,_cvv2,_mobilephone];
}

- (void)initUI {

    if (self.isPresentView) {
        
        [self setNavBackButtonStyle:BVTagCancel];
    }else {
    
        [self setNavBackButtonStyle:BVTagBack];
    }
    
    self.title = @"认证信用卡";
    
    [self.baseView removeFromSuperview];
    //初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
//    _tableView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+255);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = KBackgroudColor;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 130);
    footerView.backgroundColor = KBackgroudColor;
    footerView.userInteractionEnabled = YES;
    
    UIImage *driveRuleImg = UIImageName(@"certificateRule_sel");
    CGFloat imgWidth = driveRuleImg.size.width;
    CGFloat imgHeight = driveRuleImg.size.height;
    _isCertificateRuleSelect = YES;
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(10, 0, imgWidth, imgHeight);
    [_selectButton setImage:driveRuleImg forState:UIControlStateNormal];
    _isCertificateRuleSelect = YES;
    [_selectButton addTarget:self action:@selector(certificateRuleSelect) forControlEvents:UIControlEventTouchUpInside];
    _isCertificateRuleSelect = YES;
    [footerView addSubview:_selectButton];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请认证您本人的信用卡，且同意";
    label.textColor = UIColorFromSixteenRGB(0x1a5a5a5);
    label.frame = CGRectMake(10+imgWidth+5, 0, 60+95, 20);
    label.adjustsFontSizeToFitWidth=YES;
    label.font = UIFontFromSize(12);
    [footerView addSubview:label];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(10+imgWidth+5+45+5+90, 0, 160, 20);
    agreeButton.titleLabel.font = UIFontFromSize(12);
    [agreeButton setTitleColor:UIColorFromRGB(226, 123, 110) forState:UIControlStateNormal];
    [agreeButton setTitle:@"《Soda用车支付授权书》" forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(payAgreement) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:agreeButton];
    
    UIButton *creditCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    creditCardBtn.frame = CGRectMake(10, 30, kScreenWidth-20, 40);
    creditCardBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
    [creditCardBtn setTitle:@"认证信用卡" forState:UIControlStateNormal];
    creditCardBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [creditCardBtn addTarget:self action:@selector(bindCreditCard) forControlEvents:UIControlEventTouchUpInside];
    creditCardBtn.layer.cornerRadius = 4;
    creditCardBtn.layer.masksToBounds = YES;
    [creditCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:creditCardBtn];
    
    UIButton *failureCause = [UIButton buttonWithType:UIButtonTypeCustom];
    failureCause.frame = CGRectMake(10, 80, kScreenWidth-20, 20);
    failureCause.titleLabel.textAlignment=NSTextAlignmentCenter;
    [failureCause setTitle:@"绑定失败？请点击这里查看问题原因" forState:UIControlStateNormal];
    failureCause.titleLabel.font = [UIFont systemFontOfSize:13];
    [failureCause addTarget:self action:@selector(failureCauseClick:) forControlEvents:UIControlEventTouchUpInside];
    failureCause.layer.cornerRadius = 4;
    failureCause.layer.masksToBounds = YES;
    [failureCause setTitleColor:UIColorFromSixteenRGB(0xadadaf) forState:UIControlStateNormal];
    [footerView addSubview:failureCause];
    
    _tableView.tableFooterView = footerView;
}

#pragma mark - UItableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (0 == section) {
        
        return 2;
    }else if (1 == section) {
    
        return 4;
    }else {
    
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UITextField *textField;
    
    if (0 == indexPath.section) {
        
        textField = [_textFieldArray objectAtIndex:indexPath.row];
        if (0 == indexPath.row) {
            
            cell.textLabel.text = @"姓名";
        }else {
        
            cell.textLabel.text = @"身份证号";
        }
    }else if (1 == indexPath.section) {
    
        textField = [_textFieldArray objectAtIndex:indexPath.row+2];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        NSArray *titleArray = @[@"信用卡号",@"有效期",@"CVV2",@"预留手机号"];
        cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        
        if (1 == indexPath.row) {   //给有效期那栏加占位符
            
            textField.placeholder = @"如:0618";
        }
        
        if (1 == indexPath.row || 2 == indexPath.row) { //
            
            UIImage *image = [UIImage imageNamed:@"creditCardHelp"];
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
            helpButton.frame = CGRectMake(kScreenWidth-20-width, (cell.bounds.size.height-height)/2, width, height);
            [helpButton setImage:image forState:UIControlStateNormal];
            helpButton.tag = indexPath.row-1;
            [helpButton addTarget:self action:@selector(showPromptView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:helpButton];
        }
        if (3 == indexPath.row) {
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"填写在银行预留的手机号";
        }
    }else {
    
        ;
    }
    cell.textLabel.font = UIFontFromSize(14);
    textField.frame = CGRectMake(100, (cell.bounds.size.height-30)/2, kScreenWidth-100-60, 30);
    textField.font = UIFontFromSize(14);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    
    return cell;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    _tableView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+50);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    _tableView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-64);
}

#pragma mark - Action

-(void)failureCauseClick:(UIButton *)sender
{
    
}

//取消键盘事件
- (void)hideKeyborad {

    for (UITextField *textField in _textFieldArray) {
        
        [textField resignFirstResponder];
    }
}

- (void)dismissView {

    [self dismissViewControllerAnimated:YES completion:^{
        
//        PostNotification(@"presentDriverLicence");
    }];
}

- (void)showPromptView:(UIButton *)sender {

    [self hideKeyborad];
    
    PromptViewStyle style = sender.tag?CVV2PromptViewTag:ValidDatePromptViewTag;
    PromptView *promptView = [[PromptView alloc] initWithPromptViewStyle:style];
    promptView.promptViewDelegate = self;
    [self.navigationController.view addSubview:promptView];
    _promptView = promptView;
}

//是否同意用户协议
- (void)certificateRuleSelect {
    
    if (_isCertificateRuleSelect) {
        
        _isCertificateRuleSelect = NO;
    }else {
        
        _isCertificateRuleSelect = YES;
    }
    UIImage *img = _isCertificateRuleSelect?UIImageName(@"certificateRule_sel"):UIImageName(@"certificateRule_nor");
    [_selectButton setImage:img forState:UIControlStateNormal];
}

//支付授权书
- (void)payAgreement {

    NSLog(@"支付授权书");
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = @"用户协议";
//    NSString *userAgreement=[Tool getCache:@"UserAgreement"];
//    if (userAgreement.length>0)
//    {
//        [webViewController loadUrl:userAgreement];
//    }
//    else
//    {
        [webViewController loadUrl:kURL(kE2EUrlYongHuXieYi)];
//    }
    [self.navigationController pushViewController:webViewController animated:YES];
}

//绑定信用卡
- (void)bindCreditCard {

    [self checkCreditInfo];
    for (UITextField *textField in _textFieldArray) {
        
        [textField resignFirstResponder];
    }
}

- (void)checkCreditInfo {

    if (_cardname.text.length == 0) {
        
        [self showInfo:@"请输入姓名"];
    }else if (_idcard.text.length == 0){
        
        [self showInfo:@"请输入身份证号"];
        
    }else if (_bankcardnum.text.length == 0){
        
        [self showInfo:@"请输入信用卡号"];
    }else if (_expiredate.text.length == 0){
        
        [self showInfo:@"请输入有效期"];
    }else if (_cvv2.text.length == 0){
        
        [self showInfo:@"请输入CVV2"];
    }else if (_mobilephone.text.length == 0){
        
        [self showInfo:@"请输入信用卡预留的手机号"];
    }else if (!_isCertificateRuleSelect){
        
        [self showInfo:@"你未同意《Soda用车支付授权书》"];
    }else {
        
        NSDictionary *dic = @{@"cardname":_cardname.text,@"idcard":_idcard.text,@"bankcardnum":_bankcardnum.text,@"expiredate":_expiredate.text,@"cvv2":_cvv2.text,@"mobilephone":_mobilephone.text};
        [self requestForBindingCreditCard:dic];
    }
}

#pragma mark - Request

- (void)requestForBindingCreditCard:(NSDictionary *)dic {

    [self showIndeterminate:@""];
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlCreditCard) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        if (success) {
            
            [self hide];
            NSString *message = response[@"errMsg"];
            if (10000 == result)
            {
                
                [self showSuccess:message];
                
                if (self.isPresentView) {
                    
                    [self dismissView];
                }else {
                
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else if (10001 == result) {
            
                [self showError:message];
            }else {
            
                [self showError:message];
            }
        }else {
        
            [self showError:JMMessageNetworkError];
        }
    }];
}

#pragma mark - PromptViewDelegate

- (void)promptView:(PromptViewStyle)promptViewStyle clicked:(NSInteger)tag {

    [_promptView removeFromSuperview];
}

# pragma mark - Others

//验证身份证号
- (BOOL)isIDNo:(NSString *)id {
    
    NSString *number = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identificationNo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [identificationNo evaluateWithObject:id];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self hideKeyborad];
}

@end
