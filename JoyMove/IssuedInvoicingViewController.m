//
//  IssuedInvoicingViewController.m
//  JoyMove
//
//  Created by cty on 16/4/20.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "IssuedInvoicingViewController.h"
#import "AddressPickView.h"
#import "Macro.h"
#import "UIViewExt.h"
#import "LXRequest.h"
#import "UserData.h"


@interface IssuedInvoicingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    UITextView *_companyTextView;
    UITextView *_companyTaxNoTextView;
    UITextView *_addressDetailedText;
    
    UITextField *_nameTextField;
    UITextField *_phoneTextField;
    
    UIButton *_submitButton;
    
    UILabel *_addressDetailedLabel;
    
    NSString *_provinceString;
    NSString *_cityString;
    NSString *_townString;
    
    BOOL _isFrist;
    
}
@end

@implementation IssuedInvoicingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromSixteenRGB(0xf0f0f0);
    
    self.title=NSLocalizedString(@"issue invoice", nil);
    
    _isFrist=NO;
    
    [self initUI];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UI
-(void)initUI
{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+20, kScreenWidth, 299+45) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapClick:)];
    [_tableView addGestureRecognizer:tap];
    
    _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame=CGRectMake(10, 410+45, kScreenWidth-20, 40);
    _submitButton.backgroundColor=UIColorFromSixteenRGB(0xf67a62);
    [_submitButton setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [_submitButton.layer setMasksToBounds:YES];
    [_submitButton.layer setCornerRadius:4.0];
    _submitButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _submitButton.titleLabel.textColor=[UIColor whiteColor];
    [_submitButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    
    [self setNavBackButtonStyle:BVTagBack];
    
}

#pragma mark - delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section)
    {
        return 2;
    }
    else
    {
        return 4;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_companyTextView resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_addressDetailedText resignFirstResponder];
    
    _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIdentifier=@"UITableViewCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell)
    {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellIdentifier];
    }
    else
    {
        
    }
    
    if (indexPath.section==0 && indexPath.row == 0)
    {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineLabel.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabel];
        
        UILabel *faPiaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 65, 25)];
        faPiaoLabel.font=[UIFont systemFontOfSize:16];
        faPiaoLabel.adjustsFontSizeToFitWidth = YES;
        faPiaoLabel.textColor=UIColorFromSixteenRGB(0x272727);
        faPiaoLabel.text=NSLocalizedString(@"the title of invoice", nil);
        [cell.contentView addSubview:faPiaoLabel];
        
        _companyTextView=[[UITextView alloc]initWithFrame:CGRectMake(faPiaoLabel.frame.origin.x+faPiaoLabel.frame.size.width+12, 5, 225.0/320*kScreenWidth, 25)];
        _companyTextView.tag=1;
        _companyTextView.text=NSLocalizedString(@"please enter the complete company name or your real name", nil);
        _companyTextView.textColor=UIColorFromSixteenRGB(0xcbcbcb);
        _companyTextView.font=[UIFont systemFontOfSize:16];
        _companyTextView.delegate=self;
        [cell.contentView addSubview:_companyTextView];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        UILabel *faPiaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 65, 25)];
        faPiaoLabel.font=[UIFont systemFontOfSize:16];
        faPiaoLabel.adjustsFontSizeToFitWidth = YES;
        faPiaoLabel.textColor=UIColorFromSixteenRGB(0x272727);
        faPiaoLabel.text=NSLocalizedString(@"the title of invoice tax no", nil);
        [cell.contentView addSubview:faPiaoLabel];
        
        _companyTaxNoTextView=[[UITextView alloc]initWithFrame:CGRectMake(faPiaoLabel.frame.origin.x+faPiaoLabel.frame.size.width+10, 5, 225.0/320*kScreenWidth, 35)];
        _companyTaxNoTextView.tag=3;
        _companyTaxNoTextView.text=NSLocalizedString(@"请输入税号", nil);
        _companyTaxNoTextView.textColor=UIColorFromSixteenRGB(0xcbcbcb);
        _companyTaxNoTextView.font=[UIFont systemFontOfSize:16];
        _companyTaxNoTextView.delegate=self;
        [cell.contentView addSubview:_companyTaxNoTextView];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
    }
    
    else if (indexPath.section==1 && indexPath.row==0)
    {
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 85, 25)];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.textColor=UIColorFromSixteenRGB(0x272727);
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.text=NSLocalizedString(@"name of addressee", nil);
        [cell.contentView addSubview:nameLabel];
        
        _nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, 10, 205.0/320*kScreenWidth, 25)];
        _nameTextField.textColor=UIColorFromSixteenRGB(0x272727);
        _nameTextField.font=[UIFont systemFontOfSize:16];
        _nameTextField.delegate=self;
        [cell.contentView addSubview:_nameTextField];
        
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineLabel.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabel];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
    }
    
    else if (indexPath.section==1 && indexPath.row==1)
    {
        UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 85, 25)];
        phoneLabel.font=[UIFont systemFontOfSize:16];
        phoneLabel.textColor=UIColorFromSixteenRGB(0x272727);
        phoneLabel.text=NSLocalizedString(@"phone number of addressee", nil);
        phoneLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:phoneLabel];
        
        _phoneTextField=[[UITextField alloc]initWithFrame:CGRectMake(phoneLabel.frame.origin.x+phoneLabel.frame.size.width+10, 10, 205.0/320*kScreenWidth, 25)];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.textColor=UIColorFromSixteenRGB(0x272727);
        _phoneTextField.font=[UIFont systemFontOfSize:16];
        _phoneTextField.delegate=self;
        [cell.contentView addSubview:_phoneTextField];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
    }
    
    else if (indexPath.section==1 && indexPath.row==2)
    {
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 65, 25)];
        addressLabel.font=[UIFont systemFontOfSize:16];
        addressLabel.adjustsFontSizeToFitWidth = YES;
        addressLabel.textColor=UIColorFromSixteenRGB(0x272727);
        addressLabel.text=NSLocalizedString(@"locate area", nil);
        [cell.contentView addSubview:addressLabel];
        
        UIButton *clickButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [clickButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        clickButton.frame=CGRectMake(0, 0, kScreenWidth, 45);
        clickButton.backgroundColor=[UIColor clearColor];
        clickButton.tag=10000;
        [cell.contentView addSubview:clickButton];
        
        _addressDetailedLabel=[[UILabel alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x+addressLabel.frame.size.width+10, 10, 225.0/320*kScreenWidth, 25)];
        _addressDetailedLabel.adjustsFontSizeToFitWidth=YES;
        _addressDetailedLabel.font=[UIFont systemFontOfSize:16];
        _addressDetailedLabel.textColor=UIColorFromSixteenRGB(0x272727);
        [cell.contentView addSubview:_addressDetailedLabel];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
    }
    else
    {
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 65, 25)];
        addressLabel.font=[UIFont systemFontOfSize:16];
        addressLabel.adjustsFontSizeToFitWidth = YES;
        addressLabel.textColor=UIColorFromSixteenRGB(0x272727);
        addressLabel.text=NSLocalizedString(@"detail address information", nil);
        [cell.contentView addSubview:addressLabel];
        
        _addressDetailedText=[[UITextView alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x+addressLabel.frame.size.width+12, 5, 225.0/320*kScreenWidth, 25)];
        _addressDetailedText.tag = 2;
        _addressDetailedText.text=NSLocalizedString(@"enter detail address information", nil);
        _addressDetailedText.textColor=UIColorFromSixteenRGB(0xcbcbcb);
        _addressDetailedText.font=[UIFont systemFontOfSize:16];
        _addressDetailedText.delegate=self;
        _addressDetailedText.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:_addressDetailedText];
        
        UILabel *lineLabelSecond=[[UILabel alloc]initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        lineLabelSecond.backgroundColor=UIColorFromSixteenRGB(0xcccccc);
        [cell.contentView addSubview:lineLabelSecond];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag==1 || textView.tag == 3)
    {
        if ([textView.text isEqualToString:NSLocalizedString(@"please enter the complete company name or your real name", nil)] ||
            [textView.text isEqualToString:NSLocalizedString(@"请输入税号", nil)])
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
            textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
            textView.text=@"";
        }
        else
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
        }
        
        if (kIphone5 || kIphone4)
        {
            _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
        }
        
    }
    else
    {
        if ([textView.text isEqualToString:NSLocalizedString(@"enter detail address information", nil)])
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
            textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
            textView.text=@"";
        }
        else
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
        }
        
        if (kIphone5 || kIphone4)
        {
            _tableView.frame=CGRectMake(0, -100, kScreenWidth, 299+45);
        }
        
        
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==1 || textView.tag == 3)
    {
        if ([textView.text isEqualToString:NSLocalizedString(@"please enter the complete company name or your real name", nil)] ||
            [textView.text isEqualToString:NSLocalizedString(@"请输入税号", nil)])
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
            textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
            textView.text=@"";
        }
        else
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
             //textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
        }
    }
    else
    {
        if ([textView.text isEqualToString:NSLocalizedString(@"enter detail address information", nil)])
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
            textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
            textView.text=@"";
        }
        else
        {
            textView.textColor=UIColorFromSixteenRGB(0x272727);
            textView.frame=CGRectMake(10+65+12, 12, 225.0/320*kScreenWidth, 25);
        }
    }
   
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_nameTextField && (kIphone4 || kIphone5))
    {
        _tableView.frame=CGRectMake(0, 64, kScreenWidth, 299+45);
    }
    else if (textField==_phoneTextField && (kIphone4 || kIphone5))
    {
        _tableView.frame=CGRectMake(0, 10, kScreenWidth, 299+45);
    }
    else
    {
        _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    
    _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
    
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
        
        return NO;
    }
    return YES;

}

#pragma mark - action

- (void)tongzhi:(NSNotification *)text
{
    _addressDetailedLabel.text=text.userInfo[@"textOne"];
}

-(void)tapClick:(UITapGestureRecognizer *)sender
{
    [_companyTextView resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_addressDetailedText resignFirstResponder];
    [_companyTaxNoTextView resignFirstResponder];
    
    _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
}

-(void)buttonClick:(UIButton *)sender
{
    
    [_companyTextView resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_addressDetailedText resignFirstResponder];
    [_companyTaxNoTextView resignFirstResponder];
    _tableView.frame=CGRectMake(0, 64+20, kScreenWidth, 299+45);
    
    if (sender.tag==10000)
    {
        AddressPickView *addressPickView = [AddressPickView shareInstance];
        [self.view addSubview:addressPickView];
        
        if ( _isFrist==NO)
        {
            if (kAboveIOS9)
            {
                if ([UserData userData].cityName.length>0)
                {
                    _addressDetailedLabel.text=[UserData userData].cityName;
                    _provinceString=[UserData userData].provinceString;
                    _cityString=[UserData userData].cityString;
                    _townString=[UserData userData].townString;
                }
                else
                {
                    _addressDetailedLabel.text=NSLocalizedString(@"Beijing  Beijing  Chaoyang District", nil);
                    _provinceString=NSLocalizedString(@"Beijing", nil);
                    _cityString=NSLocalizedString(@"Beijing", nil);
                    _townString=NSLocalizedString(@"Chaoyang District", nil);
                    _isFrist=YES;
                }
            }
            else
            {
                if ([UserData userData].cityName.length>0)
                {
                    _addressDetailedLabel.text=[UserData userData].cityName;
                    _provinceString=[UserData userData].provinceString;
                    _cityString=[UserData userData].cityString;
                    _townString=[UserData userData].townString;
                    
                }
                else
                {
                    _addressDetailedLabel.text=NSLocalizedString(@"Beijing  Beijing  Chaoyang District", nil);
                    _provinceString=NSLocalizedString(@"Beijing", nil);
                    _cityString=NSLocalizedString(@"Beijing", nil);
                    _townString=NSLocalizedString(@"Chaoyang District", nil);
                }
                
            }
            _isFrist=YES;
        }
       
        
        addressPickView.block = ^(NSString *province,NSString *city,NSString *town)
        {
            _addressDetailedLabel.text=[NSString stringWithFormat:@"%@  %@  %@",province,city,town] ;
            _provinceString=province;
            _cityString=city;
            _townString=town;
            [UserData userData].cityName=_addressDetailedLabel.text;
            [UserData userData].provinceString=province;
            [UserData userData].cityString=city;
            [UserData userData].townString=town;
        };
    }
    else
    {
        [self requestIssuedInvoicing];
    }
}

#pragma mark - request

-(void)requestIssuedInvoicing
{
    if ([_companyTextView.text isEqualToString:NSLocalizedString(@"please enter the complete company name or your real name", nil)] || _companyTextView.text.length==0)
    {
        [self showError:NSLocalizedString(@"please enter the title of invoice", nil)];
    }
    else if (_nameTextField.text.length==0)
    {
        [self showError:NSLocalizedString(@"please enter the name of addressee", nil)];
    }
    else if (_phoneTextField.text.length==0)
    {
        [self showError:NSLocalizedString(@"please enter the phone number of addressee", nil)];
    }
    else if (_addressDetailedLabel.text.length==0)
    {
        [self showError:NSLocalizedString(@"select location", nil)];
    }
    else if (_addressDetailedText.text.length==0 || [_addressDetailedText.text isEqualToString:NSLocalizedString(@"enter detail address information", nil)])
    {
        [self showError:NSLocalizedString(@"enter detail address information", nil)];
    }
    else
    {
        
        if (_orderIds.count>0)
        {
            NSDictionary *dic= @{@"invoiceTitle":_companyTextView.text,
                                 @"receiver":_nameTextField.text,
                                 @"receiverMobile":_phoneTextField.text,
                                 
                                 @"taxIDNum":_companyTaxNoTextView.text,
                                     @"province":_provinceString,@"city":_cityString,@"district":_townString,@"address":_addressDetailedText.text,@"count":_count,@"orderIds":_orderIds};
            
            [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlIssuedInvoicing) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result)
             {
                 if (success)
                 {
                     if (result==10000)
                     {
                         [self showSuccess:response[@"errMsg"]];
                         if (self.popViewController)
                         {
                             self.popViewController();
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                         
                     }
                     else if (result==12000)
                     {
                         [self createNoNetWorkViewWithReloadBlock:^{
                             
                         }];
                     }
                     else
                     {
                         [self showError:response[@"errMsg"]];
                     }
                 }
                 else
                 {
                     [self showError:NSLocalizedString(@"no internet connection available", nil)];
                 }
                 
                 
             }];

        }
        else
        {
            [self showError:NSLocalizedString(@"please select at least one invoice", nil)];
        }
        
    }
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

@end
