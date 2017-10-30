//
//  DriveViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/19.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "DriveViewController.h"
#import "LXRequest.h"
#import "PickerViewController.h"
#import "MyPicker.h"
#import "UIView+TZExtension.h"
#import "ShowPictureViewController.h"

typedef NS_ENUM(NSInteger, DriverCardTag) {
    
    LeftDriverCard = 300,
    RightDriverCard,
    PersonImgTag
};

@interface DriveViewController () <UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,MyPickerDelegate,PickerDelegate>
{
    NSMutableDictionary *_dic;
    UITextField *_driveNo;
    UITextField *_userName;
    UITextField *_limitTime;
    
    UIImageView *_leftDriveView;
    UIImageView *_rightDriveView;
    // 个人照片
    UIImageView *_personImageView;
    
    DriverCardTag _driverCardTag;
    NSString *_dataStr; //base64 图片存储
    UIButton *_certificateButton;
    UIDatePicker *_datePicker;
    UIButton *_selectButton;
    BOOL _isCertificateRuleSelect;
}
@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dic = [[NSMutableDictionary alloc] init];
    [self initUI];
    [self initDatePicker];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self hideKeyborad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initDatePicker {

    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 162);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"];
    [self.view addSubview:_datePicker];
}

- (void)initUI {

    if (self.isPresentView) {
       
        [self setNavBackButtonStyle: BVTagCancel];
    }else {
        
        [self setNavBackButtonStyle: BVTagBack];
    }
    
    self.title = NSLocalizedString(@"license authentication", nil);
    self.view.backgroundColor = UIColorFromSixteenRGB(0xf0f0f0);
    // 消除scrollView自动下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.baseView removeFromSuperview];
    UIScrollView *baseScrollView = [[UIScrollView alloc] init];
    baseScrollView.backgroundColor = [UIColor clearColor];
    baseScrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    baseScrollView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
    [baseScrollView addGestureRecognizer:tap];
    [self.view addSubview:baseScrollView];
    
    //真实姓名
    UIView *nameWhiteView = [[UIView alloc] init];
    nameWhiteView.frame = CGRectMake(0, 15, kScreenWidth, 40);
    nameWhiteView.backgroundColor = [UIColor whiteColor];
    [baseScrollView addSubview:nameWhiteView];
    UIView *lineViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineViewOne.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [nameWhiteView addSubview:lineViewOne];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(20, 5, 80, 30);
    nameLabel.text = NSLocalizedString(@"Name", nil);
    nameLabel.textColor = UIColorFromRGB(100, 100, 100);
    nameLabel.font = [UIFont systemFontOfSize:15];
    [nameWhiteView addSubview:nameLabel];
    
    _userName = [[UITextField alloc] init];
    _userName.frame = CGRectMake(120, 5, kScreenWidth-120-20, 30);
    _userName.placeholder = NSLocalizedString(@"Please enter your real name", nil);
    _userName.adjustsFontSizeToFitWidth = YES;
    _userName.font = [UIFont systemFontOfSize:12];
    _userName.delegate = self;
    _userName.returnKeyType = UIReturnKeyDone;
    [nameWhiteView addSubview:_userName];
    
    //驾驶证号
    UIView *numberWhiteView = [[UIView alloc] init];
    numberWhiteView.frame = CGRectMake(0, 55, kScreenWidth, 40);
    numberWhiteView.backgroundColor = [UIColor whiteColor];
    UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineViewTwo.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    UIView *lineViewThree = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    lineViewThree.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [numberWhiteView addSubview:lineViewTwo];
    [numberWhiteView addSubview:lineViewThree];
    [baseScrollView addSubview:numberWhiteView];
    
    
    UILabel *driveLabel = [[UILabel alloc] init];
    driveLabel.frame = CGRectMake(20, 5, 80, 30);
    driveLabel.text = NSLocalizedString(@"license number", nil);
    driveLabel.adjustsFontSizeToFitWidth = YES;
    driveLabel.textColor = UIColorFromRGB(100, 100, 100);
    driveLabel.font = [UIFont systemFontOfSize:15];
    [numberWhiteView addSubview:driveLabel];
    
    _driveNo = [[UITextField alloc] init];
    _driveNo.frame = CGRectMake(120, 5, kScreenWidth-120-20, 30);
    _driveNo.placeholder = NSLocalizedString(@"Please enter your license number", nil);
    _driveNo.adjustsFontSizeToFitWidth = YES;
    _driveNo.font = [UIFont systemFontOfSize:12];
    _driveNo.delegate = self;
    _driveNo.returnKeyType = UIReturnKeyDone;
    [numberWhiteView addSubview:_driveNo];
    
    //驾驶证过期时间
    UIView *timeWhiteView = [[UIView alloc] init];
    timeWhiteView.frame = CGRectMake(0, 95, kScreenWidth, 40);
    timeWhiteView.backgroundColor = [UIColor whiteColor];
    [baseScrollView addSubview:timeWhiteView];
    UIView *lineViewFour = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    lineViewFour.backgroundColor = UIColorFromSixteenRGB(0xe2e2e2);
    [timeWhiteView addSubview:lineViewFour];
    
    UILabel *limitTimeLabel = [[UILabel alloc] init];
    limitTimeLabel.frame = CGRectMake(20, 5, 80, 30);
    limitTimeLabel.text = NSLocalizedString(@"Expiry date", nil);
    limitTimeLabel.textColor = UIColorFromRGB(100, 100, 100);
    limitTimeLabel.font = [UIFont systemFontOfSize:15];
    [timeWhiteView addSubview:limitTimeLabel];
    
    _limitTime = [[UITextField alloc] init];
    _limitTime.frame = CGRectMake(120, 5, kScreenWidth-120-20, 30);
    _limitTime.placeholder = NSLocalizedString(@"Please enter the expiry date of your driving license", nil);
    _limitTime.adjustsFontSizeToFitWidth = YES;
    _limitTime.font = [UIFont systemFontOfSize:12];
    _limitTime.delegate = self;
    _limitTime.returnKeyType = UIReturnKeyDone;
    [timeWhiteView addSubview:_limitTime];
    
    //驾驶证正页UI
    _leftDriveView = [[UIImageView alloc] init];
    CGFloat IDBackImageW = 166.5 / 375 * kScreenWidth;
    CGFloat IDBackImageH = 113.5 / 375 * kScreenWidth;
    _leftDriveView.frame = CGRectMake((kScreenWidth - 2 * IDBackImageW - 9) / 2, 155, IDBackImageW, IDBackImageH);
    _leftDriveView.userInteractionEnabled = YES;
    _leftDriveView.contentMode = UIViewContentModeScaleToFill;
    _leftDriveView.image = UIImageName(@"licence");
    // 增加点击查看大图
    UIButton *leftCheckBtn = [[UIButton alloc] init];
    leftCheckBtn.frame = CGRectMake(0, 0, IDBackImageW, IDBackImageH);
    leftCheckBtn.tag = LeftDriverCard;
    [leftCheckBtn addTarget:self action:@selector(clickCheckPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_leftDriveView addSubview:leftCheckBtn];
    [baseScrollView addSubview:_leftDriveView];
    
    // 驾驶证副页UI
    _rightDriveView = [[UIImageView alloc] init];
    _rightDriveView.frame = CGRectMake(CGRectGetMaxX(_leftDriveView.frame) + 9, 155, IDBackImageW, IDBackImageH);
    _rightDriveView.userInteractionEnabled = YES;
    _rightDriveView.contentMode = UIViewContentModeScaleToFill;
    _rightDriveView.image = UIImageName(@"licenceBack");
    // 增加点击查看大图
    UIButton *rightCheckBtn = [[UIButton alloc] init];
    rightCheckBtn.frame = CGRectMake(0, 0, IDBackImageW, IDBackImageH);
    rightCheckBtn.tag = RightDriverCard;
    [rightCheckBtn addTarget:self action:@selector(clickCheckPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_rightDriveView addSubview:rightCheckBtn];
    [baseScrollView addSubview:_rightDriveView];
    
    // 正页button点击
    UIButton *leftDriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftDriveButton.frame = CGRectMake((kScreenWidth - 217) * 0.5, CGRectGetMaxY(_leftDriveView.frame) + 30, 217, 41);
    
    leftDriveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    leftDriveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [leftDriveButton setBackgroundImage:[UIImage imageNamed:@"licenceBtn"] forState:UIControlStateNormal];
    [leftDriveButton setTitle:NSLocalizedString(@"Please take the main sheet of your driving license", nil) forState:UIControlStateNormal];
    [leftDriveButton setTitleColor:UIColorFromRGB(233, 96, 78) forState:UIControlStateNormal];
    
    [leftDriveButton addTarget:self action:@selector(pickerDriveLicenseImage:) forControlEvents:UIControlEventTouchUpInside];
    leftDriveButton.tag = LeftDriverCard;
    [baseScrollView addSubview:leftDriveButton];
    // 副页button点击
    UIButton *rightDriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightDriveButton.frame = CGRectMake((kScreenWidth - 217) * 0.5, CGRectGetMaxY(leftDriveButton.frame) + 15, 217, 41);
    
    rightDriveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    rightDriveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightDriveButton setBackgroundImage:[UIImage imageNamed:@"licenceBtn"] forState:UIControlStateNormal];
    [rightDriveButton setTitle:NSLocalizedString(@"Please take the second sheet of your driving license", nil) forState:UIControlStateNormal];
    [rightDriveButton setTitleColor:UIColorFromRGB(233, 96, 78) forState:UIControlStateNormal];
    
    [rightDriveButton addTarget:self action:@selector(pickerDriveLicenseImage:) forControlEvents:UIControlEventTouchUpInside];
    rightDriveButton.tag = RightDriverCard;
    [baseScrollView addSubview:rightDriveButton];
    
    // 个人照片
    CGFloat personImageWH = 164.0 / 375 * kScreenWidth;
    _personImageView = [[UIImageView alloc] init];
    _personImageView.frame = CGRectMake((kScreenWidth - personImageWH) * 0.5, CGRectGetMaxY(rightDriveButton.frame) + 45, personImageWH, personImageWH);
    _personImageView.userInteractionEnabled = YES;
    _personImageView.contentMode = UIViewContentModeScaleAspectFill;
    _personImageView.clipsToBounds = YES;
    _personImageView.image = UIImageName(@"personImg");
    // 增加点击查看大图
    UIButton *personCheckBtn = [[UIButton alloc] init];
    personCheckBtn.frame = CGRectMake(0, 0, personImageWH, personImageWH);
    personCheckBtn.tag = PersonImgTag;
    [personCheckBtn addTarget:self action:@selector(clickCheckPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_personImageView addSubview:personCheckBtn];
    [baseScrollView addSubview:_personImageView];
    //照片btn
    UIButton *personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    personButton.frame = CGRectMake((kScreenWidth - 217) * 0.5, CGRectGetMaxY(_personImageView.frame) + 24, 217, 41);
    
    personButton.titleLabel.font = [UIFont systemFontOfSize:16];
    personButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [personButton setBackgroundImage:[UIImage imageNamed:@"licenceBtn"] forState:UIControlStateNormal];
    [personButton setTitle:NSLocalizedString(@"Please take your own picture", nil) forState:UIControlStateNormal];
    [personButton setTitleColor:UIColorFromRGB(233, 96, 78) forState:UIControlStateNormal];
    
    [personButton addTarget:self action:@selector(pickerDriveLicenseImage:) forControlEvents:UIControlEventTouchUpInside];
    personButton.tag = PersonImgTag;
    [baseScrollView addSubview:personButton];
    // 提示label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake((kScreenWidth - 240) * 0.5, CGRectGetMaxY(personButton.frame), 240, 30);
    tipLabel.textColor = UIColorFromSixteenRGB(0x868686);
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.adjustsFontSizeToFitWidth=YES;
    tipLabel.text = NSLocalizedString(@"(Please take your own picture for comparison and auditing license information)", nil);
    [baseScrollView addSubview:tipLabel];
    
    //请确保本人年满20周岁，且驾驶证有效期超过
    UIImage *ruleSelectImg = UIImageName(@"certificateRule_sel");
    CGFloat imgWidth = ruleSelectImg.size.width;
    UILabel *agreeLabel = [[UILabel alloc] init];
    agreeLabel.frame = CGRectMake(27 + imgWidth + 5, CGRectGetMaxY(tipLabel.frame) + 28, kScreenWidth - 54 - imgWidth - 5, 30);
    agreeLabel.textColor = UIColorFromSixteenRGB(0x1a5a5a5);
    agreeLabel.font = [UIFont systemFontOfSize:12];
    agreeLabel.adjustsFontSizeToFitWidth=YES;
    agreeLabel.text = NSLocalizedString(@"Please upload your driving license. Your age shall be at least 20 years old. Your driving license valided for more than one month before rent(Users not in mainland of China reqested for more than two months)", nil);
    agreeLabel.numberOfLines = 0;
    [baseScrollView addSubview:agreeLabel];

    //勾选框
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 14, 44, 44);
    [_selectButton setImage:ruleSelectImg forState:UIControlStateNormal];
    _isCertificateRuleSelect = YES;
    [_selectButton addTarget:self action:@selector(certificateRuleSelect) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:_selectButton];
    
    //认证按钮
    UIImage *certificateButtonImg = UIImageName(@"creditBar");
    CGFloat buttonImgHeight = certificateButtonImg.size.height;
    _certificateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _certificateButton.frame = CGRectMake(20, CGRectGetMaxY(agreeLabel.frame) + 15, kScreenWidth - 40, buttonImgHeight);
    NSString *localStr = NSLocalizedString(@"Submit", nil);
    [_certificateButton setTitle:localStr forState:UIControlStateNormal];
    _certificateButton.titleLabel.font = UIFontFromSize(18);
    [_certificateButton setBackgroundImage:certificateButtonImg forState:UIControlStateNormal];
    [_certificateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certificateButton addTarget:self action:@selector(certificateDriveLicense) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:_certificateButton];
    // 调整content
    baseScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_certificateButton.frame) + 110);
    
    // 白底
    UIView *WhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, CGRectGetMaxY(_certificateButton.frame) + kScreenHeight)];
    WhiteView.backgroundColor = [UIColor whiteColor];
    [baseScrollView insertSubview:WhiteView atIndex:0];
}

#pragma mark - Action
// 查看大图
- (void)clickCheckPhoto:(UIButton *)sender
{
    if ([_dic[@"image"] length] && sender.tag == LeftDriverCard) {
        
        ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
        showPic.isFromFront = NO;
        [self.navigationController pushViewController:showPic animated:YES];
        showPic.image = _leftDriveView.image;
    }else if ([_dic[@"image_back"] length] && sender.tag == RightDriverCard){
        
        ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
        showPic.isFromFront = NO;
        [self.navigationController pushViewController:showPic animated:YES];
        showPic.image = _rightDriveView.image;
    }else if ([_dic[@"photo"] length] && sender.tag == PersonImgTag){
        
        ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
        showPic.isFromFront = YES;
        [self.navigationController pushViewController:showPic animated:YES];
        showPic.image = _personImageView.image;
    }else{
        
    }
}


//取消键盘
- (void)hideKeyborad {

    [_userName resignFirstResponder];
    [_driveNo resignFirstResponder];
    [self hideDatePicker];
}

- (void)dismissView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerDriveLicenseImage:(UIButton *)sender {

    //记录点击哪个button 用于相机回调添加图片
    if (sender.tag == LeftDriverCard) {
        
        _driverCardTag = LeftDriverCard;
    }else if (sender.tag == RightDriverCard){
        
        _driverCardTag = RightDriverCard;
    }else {
        
        _driverCardTag = PersonImgTag;
    }
    
    if ([self isPushPicker]) {
        // 如果有图片弹出actionSheet
        if ([_dic[@"image"] length] && sender.tag == LeftDriverCard) {
            
            [self clickImageActionSheet];
        }else if ([_dic[@"image_back"] length] && sender.tag == RightDriverCard){
            
            [self clickImageActionSheet];
        }else if ([_dic[@"photo"] length] && sender.tag == PersonImgTag){
            
            [self clickImageActionSheet];
        }else{
        
            
            if (sender.tag == LeftDriverCard || sender.tag == RightDriverCard) {
                
                MyPicker *myPicker = [[MyPicker alloc] init];
                myPicker.myPickerDelegate = self;
                [self presentViewController:myPicker animated:YES completion:nil];
            }else {
               
                PickerViewController *pickerViewController = [[PickerViewController alloc] init];
                pickerViewController.pickerDelegate = self;
                pickerViewController.isShowAlert = NO;
                pickerViewController.source = UIImagePickerControllerSourceTypeCamera;
                [pickerViewController initUIWithStyle:PickerStyleNone];
                [self presentViewController:pickerViewController animated:YES completion:nil];
                
            }
            
        }
    }else {

        [self hideKeyborad];
    }
}

- (BOOL)isPushPicker {

    if (_driveNo.isFirstResponder || _datePicker.frame.origin.y < kScreenHeight) {
        
        return NO;
    }else {
    
        return YES;
    }
}

// 拍照后点击图片 弹出actionSheet，重拍or查看大图
- (void)clickImageActionSheet
{
    UIActionSheet *moreActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"View the photo", nil), NSLocalizedString(@"Retake", nil), nil];
    [moreActionSheet showInView:self.view];
    moreActionSheet.tag = 2;
}

- (void)certificateDriveLicense {
    
    if (_userName.text.length == 0) {
        
        [self showInfo:NSLocalizedString(@"Please enter your real name", nil)];
    }else if (_driveNo.text.length == 0){
        
        [self showInfo:NSLocalizedString(@"Please enter your license number", nil)];
    }
    else if (_limitTime.text.length == 0){
    
        [self showInfo:NSLocalizedString(@"Please enter the expiry date of your driving license" , nil)];
    }else if ([_dic[@"image"] length] == 0){
    
        [self showInfo:NSLocalizedString(@"Please take the main sheet of your driving license", nil)];
    }else if ([_dic[@"image_back"] length] == 0){
        
        [self showInfo:NSLocalizedString(@"Please take the second sheet of your driving license", nil)];
    }else if ([_dic[@"photo"] length] == 0){
        
        [self showInfo:NSLocalizedString(@"Please upload your photos", nil)];
    }else if (!_isCertificateRuleSelect){
        
        [self showInfo:NSLocalizedString(@"You did not agree the policy for user authentication of soda", nil)];
    }else {
    
        //if ([self isIdentificationNo:_driveNo.text]) {//iPhone4s不支持？导致clash
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure to submit? The information can not be changed after submitting for certification", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
            actionSheet.tag = 1;
//        }else {
//        
//            [self showInfo:@"驾驶证号格式不正确"];
//        }
    }
}

//UIDatePicker的触发事件
- (void)datePickerValueChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    _limitTime.text = dateString;
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

#pragma mark - MyPickerDelegate
// 自拍回调
- (void)didSelectedImage:(UIImage *)image {
    
    UIImage *newImage = [[UIImage alloc] init];

    newImage = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];

    [self handlePickerImageWithImage:newImage];

}

- (void)captureStillImageDidFinish:(UIImage *)image {
    
    UIImage *newImage = [[UIImage alloc] init];
    
    newImage = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
  
    [self handlePickerImageWithImage:newImage];
}

- (void)handlePickerImageWithImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, .5f);
    NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (LeftDriverCard == _driverCardTag) {
        
        _leftDriveView.image = image;
        [_dic setValue:dataStr forKey:@"image"];
    }else if (RightDriverCard == _driverCardTag){
        
        _rightDriveView.image = image;
        [_dic setValue:dataStr forKey:@"image_back"];
    }else{
        
        _personImageView.image = image;
        [_dic setValue:dataStr forKey:@"photo"];
    }
}

#pragma mark - requst
//认证
- (void)requstForCertificateDriveLicense:(NSDictionary *)dic {

    [self showIndeterminate:@""];
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlDriveLicense) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                [self hide];
                
                NSString *title = NSLocalizedString(@"Submit Success", nil);
                NSString *message = NSLocalizedString(@"Please pay attention. Soda will finish the process of validation in 1 hour", nil);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
                [alert show];
                
                [self.driverDelegate didUploadDriverLicense];
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

#pragma mark - UIActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
    
        if(0 == buttonIndex) {
            NSString *expireTime = [NSString stringWithFormat:@"%.f",[self dateFromeString]];
            [_dic setObject:_userName.text forKey:@"name"];
            [_dic setObject:_driveNo.text forKey:@"driverNumber"];
            [_dic setObject:expireTime forKey:@"expireTime"];
            [self requstForCertificateDriveLicense:_dic];
        }else {
            ;
        }
    }else{
        
        if (buttonIndex == 0) {
            
            ShowPictureViewController *showPic = [[ShowPictureViewController alloc] init];
            [self.navigationController pushViewController:showPic animated:YES];
            
            if (LeftDriverCard == _driverCardTag) {
                showPic.isFromFront = NO;
                showPic.image = _leftDriveView.image;
            }else if(RightDriverCard == _driverCardTag){
                showPic.isFromFront = NO;
                showPic.image = _rightDriveView.image;
            }else{
                showPic.isFromFront = YES;
                showPic.image = _personImageView.image;
            }
            
        }else if (buttonIndex == 1){
            if (_driverCardTag == LeftDriverCard ||  _driverCardTag == RightDriverCard) {
                MyPicker *myPicker = [[MyPicker alloc] init];
                myPicker.myPickerDelegate = self;
                [self presentViewController:myPicker animated:YES completion:nil];
            }else{
                
                PickerViewController *pickerViewController = [[PickerViewController alloc] init];
                pickerViewController.pickerDelegate = self;
                pickerViewController.isShowAlert = NO;
                pickerViewController.source = UIImagePickerControllerSourceTypeCamera;
                [pickerViewController initUIWithStyle:PickerStyleNone];
                [self presentViewController:pickerViewController animated:YES completion:nil];
            }
        }else{
            
        }
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (range.location == 18 && textField == _driveNo) {
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if ([textField isEqual:_limitTime]) {
        
        [_driveNo resignFirstResponder];
        [self showDatePicker];
        return NO;
    }else {
    
        [self hideDatePicker];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Others
//弹出时间选择器
- (void)showDatePicker {

    [UIView animateWithDuration:0.4f animations:^{
        
        _datePicker.frame = CGRectMake(0, kScreenHeight-162, kScreenWidth, 162);
    } completion:^(BOOL finished) {
        ;
    }];
}

//隐藏时间选择器
- (void)hideDatePicker {

    [UIView animateWithDuration:0.4f animations:^{
        
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 162);
    } completion:^(BOOL finished) {
        ;
    }];
}

//验证
- (BOOL)isIdentificationNo:(NSString *)driveNo {

    NSString *number = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identificationNo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [identificationNo evaluateWithObject:driveNo];
}

//date转换成时间戳格式
- (NSTimeInterval)dateFromeString {
    
    NSTimeInterval time = [_datePicker.date timeIntervalSince1970]*1000;
    return time;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (self.isPresentView) {
        
        [self dismissView];
    }else {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
