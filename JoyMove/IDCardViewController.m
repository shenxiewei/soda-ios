//
//  IDCardViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/6/9.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "IDCardViewController.h"
#import "PickerViewController.h"
#import "WebViewController.h"
#import "MyPicker.h"

typedef NS_ENUM(NSInteger, IDCardTag) {
    
    IDCardObverseTag = 301,
    IDCardReverseTag
};

@interface IDCardViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,WebViewDelegate,MyPickerDelegate,PickerDelegate>
{
    UIImageView *_headerView;
    UIImageView *_idObverseView;
    UIImageView *_idReverseView;
    UIButton *_certificateButton;
    NSMutableDictionary *_dic;
    IDCardTag _idCardTag;
    UIButton *_selectButton;
    NSString *_name;
    NSString *_id;
    NSString *_idCard;
    BOOL _isCertificateRuleSelect;
}
@end

@implementation IDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"身份认证";
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
    UIScrollView *baseScrollView = [[UIScrollView alloc] init];
    baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    baseScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:baseScrollView];
    
    //头像上传
    UIImage *headerImg = UIImageName(@"header_ID");
    _headerView = [[UIImageView alloc] init];
    CGFloat height = kScreenWidth*600/800;
    CGFloat headerWidth = headerImg.size.width;
    CGFloat headerHeight = headerImg.size.height;
    _headerView.frame = CGRectMake(0, 10, kScreenWidth, height);
    _headerView.userInteractionEnabled = YES;
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.contentMode = UIViewContentModeScaleAspectFit;
    _headerView.image = headerImg;
    [baseScrollView addSubview:_headerView];
    
    //头像上传标签
    UIImage *headerPromptImg = [UIImage imageNamed:@"headerPrompt_ID"];
    UIImageView *headerPromptView = [[UIImageView alloc] init];
    headerPromptView.frame = CGRectMake(kScreenWidth-headerPromptImg.size.width, height-headerPromptImg.size.height, headerPromptImg.size.width, headerPromptImg.size.height);
    headerPromptView.image = headerPromptImg;
    [_headerView addSubview:headerPromptView];
    
    //头像Button
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = CGRectMake(0, 0, headerWidth, headerHeight);
    [headerButton addTarget:self action:@selector(getUserHeader) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:headerButton];
    
    //身份证正面
    UIImage *obverseImg = UIImageName(@"IDObverse");
    _idObverseView = [[UIImageView alloc] init];
    _idObverseView.frame = CGRectMake(0, 10+height+24, kScreenWidth, height);
    _idObverseView.backgroundColor = [UIColor whiteColor];
    _idObverseView.userInteractionEnabled = YES;
    _idObverseView.contentMode = UIViewContentModeScaleToFill;
    _idObverseView.image = obverseImg;
    [baseScrollView addSubview:_idObverseView];
    
    float with = _idObverseView.frame.size.width;
    
    //正面标签提示
    UIImage *obversePromptImg = [UIImage imageNamed:@"idCardObverse"];
    UIImageView *obversePromptView = [[UIImageView alloc] init];
    obversePromptView.frame = CGRectMake(with-obversePromptImg.size.width, height-obversePromptImg.size.height, obversePromptImg.size.width, obversePromptImg.size.height);
    obversePromptView.image = obversePromptImg;
    [_idObverseView addSubview:obversePromptView];
    
    //身份证正面button
    UIButton *obverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    obverseButton.frame = CGRectMake(0, 0, with, height);
    obverseButton.tag = IDCardObverseTag;
    [obverseButton addTarget:self action:@selector(idCardPickerImage:) forControlEvents:UIControlEventTouchUpInside];
    [_idObverseView addSubview:obverseButton];
    
    //身份证反面
    UIImage *reverseImg = UIImageName(@"IDReverse");
    _idReverseView = [[UIImageView alloc] init];
    _idReverseView.frame = CGRectMake(0, height*2+10+24*2, kScreenWidth, height);
    _idReverseView.backgroundColor = [UIColor whiteColor];
    _idReverseView.userInteractionEnabled = YES;
    _idReverseView.contentMode = UIViewContentModeScaleToFill;
    _idReverseView.image = reverseImg;
    [baseScrollView addSubview:_idReverseView];
    
    //正面标签提示
    UIImage *reversePromptImg = [UIImage imageNamed:@"idCardReverse"];
    UIImageView *reversePromptView = [[UIImageView alloc] init];
    reversePromptView.frame = CGRectMake(with-obversePromptImg.size.width, height-obversePromptImg.size.height, obversePromptImg.size.width, obversePromptImg.size.height);
    reversePromptView.image = reversePromptImg;
    [_idReverseView addSubview:reversePromptView];
    
    //身份证正面button
    UIButton *reverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reverseButton.frame = CGRectMake(0, 0, with, height);
    reverseButton.tag = IDCardReverseTag;
    [reverseButton addTarget:self action:@selector(idCardPickerImage:) forControlEvents:UIControlEventTouchUpInside];
    [_idReverseView addSubview:reverseButton];
    
    UIImage *driveRuleImg = UIImageName(@"certificateRule_sel");
    CGFloat imgWidth = driveRuleImg.size.width;
    
    //soda对用户的审核标准
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(10+imgWidth+5, height*3+10+24*2+15, 130, 20);
    label1.textColor = UIColorFromRGB(185, 184, 184);
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"soda对用户的审核标准";
    [baseScrollView addSubview:label1];
    
    //了解更多
    UIButton *learnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    learnButton.frame = CGRectMake(10+imgWidth+5+110, height*3+10+24*2+15, 80, 20);
    [learnButton setTitle:@"了解更多" forState:UIControlStateNormal];
    [learnButton setTitleColor:UIColorFromRGB(225, 108, 86) forState:UIControlStateNormal];
    learnButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [learnButton addTarget:self action:@selector(learnMoreClick) forControlEvents:UIControlEventTouchUpInside];//点击事件
    [baseScrollView addSubview:learnButton];
    
    //平台车辆须有本人租赁，不可代租、外借或运营
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(10, height*3+10+24*2+15+20, kScreenWidth, 20);
    label2.textColor = UIColorFromRGB(185, 184, 184);
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"平台车辆须有本人租赁，不可代租、外借或运营";
    [baseScrollView addSubview:label2];
    
    //请上传本人身份证，审核成功不可更改
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(10, height*3+10+24*2+15+20+20, kScreenWidth, 20);
    label3.textColor = UIColorFromRGB(185, 184, 184);
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"请上传本人身份证，审核成功不可更改";
    [baseScrollView addSubview:label3];
    
    //提示内容
    //勾选框
    _isCertificateRuleSelect = YES;
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(0, height*3+10+24*2+3, 44, 44);
    [_selectButton setImage:driveRuleImg forState:UIControlStateNormal];
    _isCertificateRuleSelect = YES;
    [_selectButton addTarget:self action:@selector(certificateRuleSelect) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:_selectButton];
    
    //认证提交
    UIImage *certificateButtonImg = UIImageName(@"uploadButton");
    CGFloat buttonImgHeight = certificateButtonImg.size.height;
    _certificateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _certificateButton.frame = CGRectMake(6, height*3+10+24*2+15+20+20+20+35, kScreenWidth-12, buttonImgHeight);
    [_certificateButton setBackgroundImage:certificateButtonImg forState:UIControlStateNormal];
    [_certificateButton setTitle:@"提交" forState:UIControlStateNormal];
    _certificateButton.titleLabel.font = UIFontFromSize(18);
    [_certificateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certificateButton addTarget:self action:@selector(certificateID) forControlEvents:UIControlEventTouchUpInside];
    //    _certificateButton.backgroundColor = UIColorFromRGB(255, 107, 108);
    [baseScrollView addSubview:_certificateButton];
    
    baseScrollView.contentSize = CGSizeMake(kScreenWidth, height*3+10+24*2+15+20+20+20+35+buttonImgHeight+20);
}

#pragma mark - Action

- (void)getUserHeader {

    PickerViewController *pickerViewController = [[PickerViewController alloc] init];
    pickerViewController.pickerDelegate = self;
    pickerViewController.isShowAlert = YES;
    pickerViewController.source = UIImagePickerControllerSourceTypeCamera;
    [pickerViewController initUIWithStyle:PickerStyleNone];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void)idCardPickerImage:(UIButton *)sender{
    
    //记录点击哪个button 用于相机回调添加图片
    if (sender.tag == IDCardObverseTag) {
        
        _idCardTag = IDCardObverseTag;
    }else {
        
        _idCardTag = IDCardReverseTag;
    }
    
    MyPicker *myPicker = [[MyPicker alloc] init];
    myPicker.myPickerDelegate = self;
    [self presentViewController:myPicker animated:YES completion:nil];
}

- (void)certificateID {
    if ([_dic[@"id_card"] length] == 0) {
        
        [self showInfo:@"请上传真实头像"];
    }else if ([_dic[@"id_card"] length] == 0){
        
        [self showInfo:@"请上传身份证正面"];
    }else if ([_dic[@"id_card_back"] length] == 0){
        
        [self showInfo:@"请上传身份证反面"];
    }else if (!_isCertificateRuleSelect) {
        
        [self showInfo:@"你未同意soda对用户的审核标准"];
    }else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"信息认证提交后不可更改，您是否确认提交？" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
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
//OCR
- (void)requstForOCR {

    [self showIndeterminate:@""];
    NSLog(@"length == %lu",(unsigned long)_idCard.length);
    NSDictionary *dic = @{@"id_card":_idCard};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlOCR) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                _name = response[@"name"];
                _id = response[@"id"];
                NSString *message;
                NSString *title;
                if ([_name isEqualToString:@"--未识别成功--"] || [_id isEqualToString:@"--未识别成功--"]) {
                    title = @"请重新拍照";
                    message = @"未能识别到你的身份信息，请按提示正确拍照";
                }else {
                    title = @"请核实信息";
                    message = [NSString stringWithFormat:@"姓名：%@\n身份证号：%@\n请确认以上信息是否正确",_name,_id];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"撤销" otherButtonTitles:@"提交", nil];
                [alert show];
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

//认证
- (void)requstForCertificateDriveLicense:(NSDictionary *)dic {
    
    [self showIndeterminate:@"正在提交"];
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlIDCard) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                NSString *message = @"Soda苏打将在1小时内进行审核，请稍候查看审核结果。";
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交成功" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [self showError:message];
            }
        }
        else if (result==12000)
        {
            [self createNoNetWorkViewWithReloadBlock:^{
                
            }];
        }
        else {
            
            [self showError:JMMessageNetworkError];
        }
    }];
}

#pragma mark - UIPickerViewControllerDelegate

- (void)didSelectedImage:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, .5f);
    NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_dic setObject:dataStr forKey:@"header"];
    _headerView.backgroundColor = [UIColor clearColor];
    _headerView.image = image;
}

#pragma mark - MyPickerDelegate

- (void)captureStillImageDidFinish:(UIImage *)image {

    [self handlePickerImageWithImage:image];
}

- (void)handlePickerImageWithImage:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, .5f);
    NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (IDCardObverseTag == _idCardTag) {
        
        _idObverseView.image = image;
        [_dic setValue:dataStr forKey:@"id_card"];
        
        //用于OCR(图片被压缩)
        NSData *idData = UIImageJPEGRepresentation(image, .5f);
        _idCard = [idData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    }else {
        
        _idReverseView.image = image;
        [_dic setValue:dataStr forKey:@"id_card_back"];
    }
    
}

#pragma mark - UIActionSheet代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(0 == buttonIndex) {
        
        [self requstForOCR];
    }else {
                ;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (1 == buttonIndex && ![_name isEqualToString:@"--未识别成功--"] && ![_id isEqualToString:@"--未识别成功--"]) {
        
        [_dic setObject:_name forKey:@"name"];
        [_dic setObject:_id forKey:@"id"];
        [self requstForCertificateDriveLicense:_dic];
    }else {
    
        ;
    }
}

@end
