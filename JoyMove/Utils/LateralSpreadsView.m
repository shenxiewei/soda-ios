//
//  LateralSpreadsView.m
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "LateralSpreadsView.h"
#import "Macro.h"
#import "UserData.h"
#import "LXRequest.h"
#import "UtilsMacro.h"
#import "UserData.h"
#import "Label.h"

@interface LateralSpreadsView ()<UITableViewDelegate, UITableViewDataSource>{
    
    UIView          *_mainView;
    UITableView     *_tableView;
    UIView          *_backgroundView;
    
    UIImageView     *_header;
    UIImageView     *_userImageView;
    UILabel         *_mobileNoLabel;
    
    NSArray         *_nameArray;
    NSArray         *_imageArray;
}
@end
    
@implementation LateralSpreadsView

typedef NS_ENUM(NSInteger, LateralSpreadsUserStatusViewTag) {
    
    LSUserStatusViewTagHook = 200,          /**< 通过认证的对勾 */
    
    LSUserStatusViewTagNoPassLabel,         /**< 未通过认证的label */
};

typedef NS_ENUM(NSInteger, LateralSpreadsCellViewTag) {
    
    LSCellViewTagLabel = 100,
    LSCellViewTagImageView,
};

#define LateralWidth                       (kScreenWidth*3.2f/4.f)

const float LateralShowDuration            = .25f;
const float LateralHideDuration            = .25f;
const float LateralBackgroundViewAplha     = .4f;
const float LateralHeaderHeight            = 151.f;
const float LateralCellHeight              = 50.f;

- (void)initUI {
    
    _nameArray = @[@"Trips", @"Wallet",@"My Car", @"Recent Events",@"Gift for invitation", @"Settings"];
    _imageArray = @[@"LateralHistory", @"LateralMoney",@"mycar", @"LateralNotif", @"LateralShare", @"LateralSetup"];
    self.alpha = 0.99;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    self.userInteractionEnabled = NO;
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.frame = self.bounds;
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backgroundView];
    _backgroundView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backgroundView addGestureRecognizer:tap];
    
    _mainView = [[UIView alloc] init];
    _mainView.frame = CGRectMake(-LateralWidth, 0, LateralWidth, kScreenHeight);
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    _mainView.userInteractionEnabled = YES;
    _mainView.alpha = 0.99;
    
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LateralWidth, LateralHeaderHeight)];
    _header.backgroundColor = [UIColor clearColor];
    _header.image = [UIImage imageNamed:@"LateralBack"];
    _header.tag = LSVTagUserInfo;
    [_mainView addSubview:_header];
    _header.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
    [_header addGestureRecognizer:tap2];
    
    //用户头像
    UIImageView *board = [[UIImageView alloc] init];
    board.frame = CGRectMake(31, 42, 68, 68);
    board.image = UIImageName(@"LateralUserBoard");
    [_mainView addSubview:board];
    
    _userImageView = [[UIImageView alloc] init];
    _userImageView.frame = CGRectMake(35.5, 46.5, 59, 59);
    _userImageView.backgroundColor = UIColorFromRGB(200, 200, 200);
    _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width/2;
    [_mainView addSubview:_userImageView];
    
    //手机号
    _mobileNoLabel = [[UILabel alloc] init];
    _mobileNoLabel.frame = CGRectMake(112, 48, kScreenWidth*2/3-10, 30);
    _mobileNoLabel.textColor = [UIColor whiteColor];
    _mobileNoLabel.font = UIFontFromSize(15);
    [_mainView addSubview:_mobileNoLabel];
    
    //4认证相关
    [self initUserStatus];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, LateralHeaderHeight + 30, LateralWidth, kScreenHeight-LateralHeaderHeight-30);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.alpha = 9.5;
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 27)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_mainView addSubview:_tableView];
    
    // 箭头
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.frame = CGRectMake(LateralWidth - 32, 71, 7, 11.5);
    arrowImg.image = [UIImage imageNamed:@"LateralArrow"];
    [_mainView addSubview:arrowImg];
    
}

- (void)initUserStatus {
    
    //认证标志
    UIButton *imageView = [[UIButton alloc] init];
    imageView.frame = CGRectMake(112, 82, 38.5, 15.5);
    imageView.tag = LSUserStatusViewTagHook;
    imageView.titleLabel.font = [UIFont systemFontOfSize:10];
    imageView.titleLabel.adjustsFontSizeToFitWidth = YES;
    imageView.userInteractionEnabled = NO;
    [_mainView addSubview:imageView];
    
    //不可租用提示文字
    Label *noPassLabel = [[Label alloc] initWithFrame:CGRectMake(154, 82, LateralWidth - 154, 40)];
    noPassLabel.tag = LSUserStatusViewTagNoPassLabel;
    noPassLabel.font = UIFontFromSize(12);
    noPassLabel.adjustsFontSizeToFitWidth = YES;
    noPassLabel.numberOfLines = 2;
    noPassLabel.verticalAlignment = VerticalAlignmentTop;
    [_mainView addSubview:noPassLabel];
    noPassLabel.hidden = YES;
    noPassLabel.textColor = [UIColor whiteColor];
}

- (void)update {
    if ([UserData userData].mobileNo.length>10)
    {
        NSString *tel = [[UserData userData].mobileNo stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _mobileNoLabel.text = tel;
    }
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:kUrlHeader] placeholderImage:[UIImage imageNamed:@"LateralHeader"]];
}

- (void)updateUserStatus:(NSDictionary *)dic {
    
    NSInteger result = [dic[@"result"] integerValue];
    if (JMCodeSuccess==result) {
        
        NSInteger id5AuthState          =  IntegerFormObject(dic[@"id5AuthState"]);
        NSInteger driverLicAuthState    =  IntegerFormObject(dic[@"driverLicAuthState"]);
        
        BOOL isPass = (1 == id5AuthState && 1 == driverLicAuthState);
        
        //update UI
        UIButton *hookImageView      = (UIButton *)[_mainView viewWithTag:LSUserStatusViewTagHook];
        
        UILabel *noPassLabel = (UILabel *)[_mainView viewWithTag:LSUserStatusViewTagNoPassLabel];
        if (1 != id5AuthState && 1 == driverLicAuthState) {
            
            noPassLabel.text = NSLocalizedString(@"Unauthorized Credit card", nil);
        }else if (1 == id5AuthState && 1 != driverLicAuthState) {
        
            noPassLabel.text = NSLocalizedString(@"Unauthorized Driving license", nil);
            
        }else if (1 != id5AuthState && 1 != driverLicAuthState) {
        
            noPassLabel.text = @"驾照审核未通过\n未认证信用卡";
        }else {
        
            ;
        }
        
        

        if (isPass) {
            
            [hookImageView setBackgroundImage:[UIImage imageNamed:@"LateralBadgeYes"] forState:UIControlStateNormal];
            [hookImageView setTitle:NSLocalizedString(@"Authenticated", nil) forState:UIControlStateNormal];
            [hookImageView setTitleColor:UIColorFromRGB(241, 81, 61) forState:UIControlStateNormal];
        }else{
            
            [hookImageView setBackgroundImage:[UIImage imageNamed:@"LateralBadgeNo"] forState:UIControlStateNormal];
            [hookImageView setTitle:NSLocalizedString(@"Unauthorized", nil) forState:UIControlStateNormal];
            [hookImageView setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        }
        
        noPassLabel.hidden              = isPass;
    }
}

- (void)show {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self update];
    [UIView animateWithDuration:LateralShowDuration animations:^{
        
        _backgroundView.alpha = LateralBackgroundViewAplha;
        _mainView.frame = CGRectMake(0, 0, LateralWidth, kScreenHeight);
        
    } completion:^(BOOL finished) {
        
        _mainView.userInteractionEnabled = YES;
        _backgroundView.userInteractionEnabled = YES;
        _header.userInteractionEnabled = YES;
        _tableView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didShow)]) {
            
            [self.delegate didShow];
        }
    }];
}

- (void)hide {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:LateralHideDuration animations:^{
        
        _backgroundView.alpha = 0;
        _mainView.frame = CGRectMake(-LateralWidth, 0, LateralWidth, kScreenHeight);
        
    } completion:^(BOOL finished) {
        
        _mainView.userInteractionEnabled = NO;
        _backgroundView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didHide)]) {
            
            [self.delegate didHide];
        }
    }];
}

- (BOOL)isShow {
    
    return self.userInteractionEnabled;
}

#pragma mark - Action

- (void)buttonClicked:(id)sender {
    
    NSInteger tag;
    if ([sender isKindOfClass:[UIButton class]]) {
        
        tag = ((UIButton *)sender).tag;
    }else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        
        tag = ((UIGestureRecognizer *)sender).view.tag;
    }else {
        
        return;     //error
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedIndex:)]) {
        
        [self.delegate clickedIndex:tag];
    }
}

//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)rec {
    
    CGPoint point = [rec translationInView:self];
    
    //跟随手势滑动
    if (_mainView.frame.origin.x+point.x<=0) {   //向右滑动，不超出极限
        
        _mainView.center = CGPointMake(_mainView.center.x+point.x, _mainView.center.y);
        _backgroundView.alpha = (1-(-(_mainView.frame.origin.x+point.x))/LateralWidth)*LateralBackgroundViewAplha;
    }
    
    [rec setTranslation:CGPointMake(0, 0) inView:self];
    
    //手势结束后修正位置
    if (rec.state==UIGestureRecognizerStateEnded) {
        
        if ([self isShow]) {
            
            if (_mainView.frame.origin.x<-20) {
                
                [self hide];
            }else {
                
                [self show];
            }
        }else {
            
            if (_mainView.frame.origin.x>-LateralWidth+20) {
                
                [self show];
            }else {
                
                [self hide];
            }
        }
    }
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LateralCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, (LateralCellHeight-16)/2, 16, 16)];
        imageView.tag = LSCellViewTagImageView;
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(31+16+19, 0, 200, LateralCellHeight)];
        label.tag = LSCellViewTagLabel;
        label.font = UIFontFromSize(15);
        label.textColor = UIColorFromRGB(39, 39, 39);
        [cell.contentView addSubview:label];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:LSCellViewTagLabel];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:LSCellViewTagImageView];
    
    NSString *nameString = _nameArray[indexPath.row];
    label.text = NSLocalizedString(nameString, nil);
    imageView.image = UIImageName(_imageArray[indexPath.row]);
    
    if (indexPath.row==1)
    {
        UILabel *integralLabel=[[UILabel alloc]initWithFrame:CGRectMake(LateralWidth-126, 0, 100, 50)];
        integralLabel.font=UIFontFromSize(11);
        integralLabel.textAlignment=NSTextAlignmentRight;
        integralLabel.adjustsFontSizeToFitWidth = YES;
        integralLabel.text= NSLocalizedString(@"Coupons, points, invoice", nil);
        integralLabel.textColor=UIColorFromRGB(93, 93, 93);
        [cell.contentView addSubview:integralLabel];
    }else if (indexPath.row == 4){
        UILabel *helpLabel=[[UILabel alloc]initWithFrame:CGRectMake(LateralWidth-56, 0, 30, 50)];
        helpLabel.font=UIFontFromSize(11);
        helpLabel.textAlignment=NSTextAlignmentRight;
        helpLabel.text= NSLocalizedString(@"Help", nil);
        helpLabel.textColor=UIColorFromRGB(93, 93, 93);
        [cell.contentView addSubview:helpLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedIndex:)]) {
        
        [self.delegate clickedIndex:indexPath.row];
    }
}

@end
