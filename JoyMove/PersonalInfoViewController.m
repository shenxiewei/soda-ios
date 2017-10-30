//
//  PersonalInfoViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/13.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PickerViewController.h"
#import "ModifyPasswordViewController.h"
#import "ModifyPhoneViewController.h"
#import "DriveViewController.h"
#import "RealNameViewController.h"
#import "IDCardViewController.h"
#import "MyPicker.h"
#import "UserGuideView.h"
#import "CreditCardViewController.h"
#import "MyInfoViewController.h"
#import "MiPushSDK.h"

typedef NS_ENUM(NSInteger, PersonalInfoTag){

    PhoneCellTag = 2001,
    DriveCellTag,
    IdentifyCellTag,
    IDCardCellTag,
    DepositCellTag,
    GenderTag,
    ISVTag,
    XXXTag,
};

typedef NS_ENUM(NSInteger, PersonalSheetTag) {
    
    PersonalSheetTagHeader = 100,
    PersonalSheetTagLogout,
    PersonalSheetTagFace,
    PersonalSheetTagVoiceprint,
};

/*天元测试 声纹识别不用了，防止警告暂时把代理方法删除了,还有UIPickView的DataSource*/
//@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,PickerDelegate,DriverDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ISVDelegate,FaceVerifyDelegate,TutorialDelegate,UserGuideDelegate,CreditCardDelegate> {
@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,PickerDelegate,DriverDelegate,UITextFieldDelegate,UIPickerViewDelegate,UserGuideDelegate,CreditCardDelegate> {

    UITableView *_infoTableView;
    NSArray *_titleArray;
    
    UIImageView *_headerView;                        //头像
    
    //认证状态
    UILabel *_driveLicenceLabel;
    UILabel *_creditCardLabel;
    UILabel *_phoneLabel;
    NSInteger _driverLicAuthState;
    NSInteger _id5AuthState;
    
    UIButton *_cancelButton;
    UIButton *_certificationImage;
}

@property (nonatomic,strong) UILabel *mobileNoLabel;


@end

typedef NS_ENUM(NSInteger, PersonInfoTag) {

    PITagMale = 200,  /**< 男性 */
    PITagFemale       /**< 女性 */
    
};

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"我的信息";
    
    [self initArray];
//    [self setNavBackButtonStyle:BVTagBack];
    [self customNavigation];
//    [self initUI];
    [self loadInfo];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_infoTableView reloadData];
    
    if (self.showUserGuide) {
        
        self.showUserGuide = NO;
        
//        //用户未认证，弹出用户向导模板
//        UserGuideView *view = [[UserGuideView alloc] initWithFrame:self.view.bounds];
//        view.delegate = self;
//        [view initUIWithType:UGTypeAllCertification];
//        [self.navigationController.view addSubview:view];
//        [view show];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
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

    [self initListInfoUI];
}

- (void)initListInfoUI {
    
    //基本信息显示
//    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
//    _infoTableView.delegate = self;
//    _infoTableView.dataSource = self;
//    _infoTableView.userInteractionEnabled = YES;
//    _infoTableView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
//    _infoTableView.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:_infoTableView];
//    _infoTableView.tableFooterView = [[UIView alloc] init];
    
    //上半部分UI
    //头像父视图
//    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextFieldEdit)];
//    UIView *headerBackView = [[UIView alloc] init];
////    [headerBackView addGestureRecognizer:touchGesture];
//    headerBackView.frame = CGRectMake(0, 0, kScreenWidth, 150);
//    headerBackView.userInteractionEnabled = YES;
//    headerBackView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
//    _infoTableView.tableHeaderView =  headerBackView;
//    
//    //头像
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyHeaderImage)];
//    UIImage *headerImg = [UIImage imageNamed:@"headerCover"];
//    _headerView = [[UIImageView alloc]init];
//    [_headerView addGestureRecognizer:gesture];
//    _headerView.userInteractionEnabled = YES;
//    _headerView.contentMode = UIViewContentModeScaleAspectFill;
//    _headerView.frame = CGRectMake((kScreenWidth-185/2)/2, 16, 185/2, 185/2);
//    _headerView.image = headerImg;
//    _headerView.layer.cornerRadius = 185/4;
//    _headerView.layer.masksToBounds = YES;
//    [headerBackView addSubview:_headerView];
    
    //退出按钮
//    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    quitButton.frame = CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40);
//    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    quitButton.titleLabel.font = UIFontFromSize(14);
//    [quitButton setTitleColor:UIColorFromRGB(120, 120, 120) forState:UIControlStateNormal];
//    [quitButton setBackgroundColor:[UIColor whiteColor]];
//    [quitButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:quitButton];
}

//自定义导航栏
-(void)customNavigation
{
    UIImageView *redImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
//    redImage.image=[UIImage imageNamed:@""];
    redImage.backgroundColor=UIColorFromSixteenRGB(0xf46954);
    [self.view addSubview:redImage];
    
    UIImageView *whiteImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth, 143)];
    whiteImage.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whiteImage];
    
    UIImageView *whiteBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 26, 9, 15)];
    whiteBackImage.image=[UIImage imageNamed:@"whiteBackButton"];
    [self.view addSubview:whiteBackImage];
    
    
    _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.backgroundColor=[UIColor clearColor];
    [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.frame=CGRectMake(12, 25, 35, 35);
    [self.view addSubview:_cancelButton];
    
    
    UIImageView *roundImage=[[UIImageView alloc]init];
    roundImage.frame=CGRectMake((kScreenWidth-185/2)/2, 66, 185/2+4, 185/2+4);
    roundImage.backgroundColor=[UIColor whiteColor];
    roundImage.layer.masksToBounds = YES; //没这句话它圆不起来
    roundImage.layer.cornerRadius = 48.0; //设置图片圆角的尺度
    roundImage.userInteractionEnabled=YES;
    [self.view addSubview:roundImage];
    
    //头像
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyHeaderImage)];
    UIImage *headerImg = [UIImage imageNamed:@"headerCover"];
    _headerView = [[UIImageView alloc]init];
    [_headerView addGestureRecognizer:gesture];
    _headerView.userInteractionEnabled = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
//    _headerView.frame = CGRectMake((kScreenWidth-185/2)/2, 66, 185/2, 185/2);
    _headerView.frame = CGRectMake(2, 2, 185/2, 185/2);
    _headerView.image = headerImg;
    _headerView.layer.cornerRadius = 185/4;
    _headerView.layer.masksToBounds = YES;
    [roundImage addSubview:_headerView];
    
    _mobileNoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 175, kScreenWidth, 15)];
    if ([UserData userData].mobileNo.length>4)
    {
        NSString *tel = [[UserData userData].mobileNo stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _mobileNoLabel.text = tel;
    }
    _mobileNoLabel.textAlignment=NSTextAlignmentCenter;
    _mobileNoLabel.font=[UIFont systemFontOfSize:18];
    _mobileNoLabel.textColor=UIColorFromSixteenRGB(0x141414);
    [self.view addSubview:_mobileNoLabel];
    
    _certificationImage=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 47) * 0.5, 200, 47, 20)];
    _certificationImage.contentMode= UIViewContentModeCenter;
    _certificationImage.titleLabel.font = [UIFont systemFontOfSize:11];
    _certificationImage.titleLabel.adjustsFontSizeToFitWidth = YES;
    _certificationImage.userInteractionEnabled = NO;
//    _certificationImage.backgroundColor=[UIColor blackColor];
   
    [self.view addSubview:_certificationImage];
    
    [self initTableView];
}

-(void)initTableView
{
    //基本信息显示
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 253, kScreenWidth, kScreenHeight-253-50) style:UITableViewStyleGrouped];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.userInteractionEnabled = YES;
    _infoTableView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
    _infoTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_infoTableView];
    _infoTableView.tableFooterView = [[UIView alloc] init];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    quitButton.frame = CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40);
    NSString *localStr = NSLocalizedString(@"logout", nil);
    [quitButton setTitle:localStr forState:UIControlStateNormal];
    quitButton.titleLabel.font = UIFontFromSize(14);
    [quitButton setTitleColor:UIColorFromRGB(120, 120, 120) forState:UIControlStateNormal];
    [quitButton setBackgroundColor:[UIColor whiteColor]];
    [quitButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
}

#pragma mark - loadData

- (void)initArray {

    _driverLicAuthState = 0;
    _id5AuthState = 0;
    
    _titleArray = @[@"license authentication",@"Personal Information"];
}

- (void)loadInfo {

    [self loadHeaderIcon];
    [self requestCheckUserState];
}

- (void)loadHeaderIcon {
    
    NSLog(@"kUrlHeader == %@",kUrlHeader);

    [_headerView sd_setImageWithURL:[NSURL URLWithString:kUrlHeader] placeholderImage:[UIImage imageNamed:@"headerCover"]];
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (0 == section) {
        
        return 1;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cellName";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    NSString *localStr = [_titleArray objectAtIndex:indexPath.section];
    cell.textLabel.text = NSLocalizedString(localStr, nil);
    cell.textLabel.font = UIFontFromSize(15);
    cell.textLabel.textColor = UIColorFromRGB(120, 120, 120);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if (0 == indexPath.section) {
//        
//        if (!_creditCardLabel) {
//            
//            _creditCardLabel = [[UILabel alloc] init];
//            _creditCardLabel.frame = CGRectMake(kScreenWidth-95, 0, 60, 45);
//            _creditCardLabel.textColor = UIColorFromSixteenRGB(0x272727);
//            _creditCardLabel.font = UIFontFromSize(12);
//            _creditCardLabel.textAlignment = NSTextAlignmentRight;
//        }
//        if (_id5AuthState) {
//            
//            _creditCardLabel.text = @"已认证";
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }else {
//        
//            _creditCardLabel.text = @"未认证";
//        }
//        cell.imageView.image = UIImageName(@"creditCardImage");
//        [cell.contentView addSubview:_creditCardLabel];
//    }else
    if (0 == indexPath.section) {
    
        if (!_driveLicenceLabel) {
    
            _driveLicenceLabel = [[UILabel alloc] init];
            _driveLicenceLabel.frame = CGRectMake(kScreenWidth-95, 0, 60, 45);
            _driveLicenceLabel.textColor = UIColorFromSixteenRGB(0x272727);
            _driveLicenceLabel.adjustsFontSizeToFitWidth = YES;
            _driveLicenceLabel.font = UIFontFromSize(12);
            _driveLicenceLabel.textAlignment = NSTextAlignmentRight;
        }
        if (0 == _driverLicAuthState) {//未认证

            _driveLicenceLabel.text = NSLocalizedString(@"Unauthorized", nil);
        }else if (1 == _driverLicAuthState) {//认证通过

            cell.accessoryType = UITableViewCellAccessoryNone;
            _driveLicenceLabel.text = NSLocalizedString(@"Authenticated", nil);
        }else if (2 == _driverLicAuthState) {//认证中

            cell.accessoryType = UITableViewCellAccessoryNone;
            _driveLicenceLabel.text = NSLocalizedString(@"Authenticating", nil);
        }else {//认证失败
        
            _driveLicenceLabel.text = NSLocalizedString(@"Authentication failed", nil);
        }
        cell.imageView.image = UIImageName(@"driverLicenceImage");
        [cell.contentView addSubview:_driveLicenceLabel];
    }else {
    
        cell.imageView.image = UIImageName(@"myInfoImage");
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate 
//cell选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (0 == indexPath.section) {
//        
//        if (1 != _id5AuthState) {
//            
//            CreditCardViewController *creditCardViewController = [[CreditCardViewController alloc] init];
//            creditCardViewController.isPresentView = NO;
//            creditCardViewController.creditCardDelegate = self;
//            [self.navigationController pushViewController:creditCardViewController animated:YES];
//        }
//    }else
    if (0 == indexPath.section) {
        
        if (1 != _driverLicAuthState && 2 != _driverLicAuthState) {
        
            DriveViewController *driveViewController = [[DriveViewController alloc] init];
            driveViewController.driverDelegate = self;
            driveViewController.isPresentView = NO;
            [self.navigationController pushViewController:driveViewController animated:YES];
        }

    }else {
        
        MyInfoViewController *myInfoViewController = [[MyInfoViewController alloc] init];
        [self.navigationController pushViewController:myInfoViewController animated:YES];
    }
}

#pragma mark - Action

-(void)buttonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//修改头像事件
- (void)modifyHeaderImage {
    
    PickerViewController *pickerViewController = [[PickerViewController alloc] init];
    pickerViewController.pickerDelegate = self;
    pickerViewController.isShowAlert = NO;
    pickerViewController.source = UIImagePickerControllerSourceTypeCamera;
    [pickerViewController initUIWithStyle:PickerStyleNone];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void)logout {
    
    NSString *title = [NSString stringWithFormat:@"%@%@?",NSLocalizedString(@"Do you really want to logout", nil), [UserData userData].mobileNo];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Logout", nil) otherButtonTitles:nil, nil];
    actionSheet.tag = PersonalSheetTagLogout;
    [actionSheet showInView:self.navigationController.view];
}

#pragma mark - Requst

- (void)requstForModifyHeader:(NSDictionary *)dic {
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(kUrlUploadHeader) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            /*天元测试 上传成功没有给用户通知事件*/
            if (JMCodeSuccess == result) {
                
                NSLog(@"上传成功");
                
                //清除头像缓存
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else {
                
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Upload failed", nil) message:NSLocalizedString(@"No internet connection available", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [aler show];
            }
        }else {
            
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Upload failed", nil) message:NSLocalizedString(@"No internet connection available", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [aler show];
        }
    }];
}

- (void)requestCheckUserState {
    
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlCheckUserState) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                
                _driverLicAuthState = IntegerFormObject(response[@"driverLicAuthState"]);
                _id5AuthState = IntegerFormObject(response[@"id5AuthState"]);
                
                if (_id5AuthState && 1 == _driverLicAuthState)
                {
                    [_certificationImage setBackgroundImage:[UIImage imageNamed:@"certificationNoImage"] forState:UIControlStateNormal];
                    [_certificationImage setTitle:NSLocalizedString(@"Authenticated", nil) forState:UIControlStateNormal];
                    [_certificationImage setTitleColor:UIColorFromRGB(115, 115, 115) forState:UIControlStateNormal];
                }
                else
                {
                    [_certificationImage setBackgroundImage:[UIImage imageNamed:@"certificationYesImage"] forState:UIControlStateNormal];
                    [_certificationImage setTitle:NSLocalizedString(@"Unauthorized", nil) forState:UIControlStateNormal];
                    [_certificationImage setTitleColor:UIColorFromRGB(241, 81, 61) forState:UIControlStateNormal];
                }
                
                [_infoTableView reloadData];
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                
                ;
            }
        }else {
            
            ;
        }
    }];
}

#pragma mark - UIActionSheet代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (!buttonIndex) {
            
        if ([OrderData isDirty]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can not Quit", nil) message:NSLocalizedString(@"Your order has not been paid", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            [UserData logout];
            [MiPushSDK unsetAccount:[UserData userData].mobileNo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIPickerViewControllerDelegate

- (void)didSelectedImage:(UIImage *)image {

    NSData *data = UIImageJPEGRepresentation(image, .5f);
    NSString *dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic = @{@"image":dataStr};
    [self requstForModifyHeader:dic];
    _headerView.image = image;
}

#pragma mark - DriverViewDelegate

- (void)didUploadDriverLicense {

    [self requestCheckUserState];
}

#pragma mark - CreditCardDelegate

- (void)didBindCreditCard {

    [self requestCheckUserState];
}

#pragma mark - UserGuideDelegate

- (void)userGuideButtonClicked {
    
    ;
}

@end
