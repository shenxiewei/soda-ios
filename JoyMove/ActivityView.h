//
//  ActivityView.h
//  JoyMove
//
//  Created by cty on 15/11/24.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView

@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) NSString *html5URL;
@property (nonatomic,strong) NSString *detailsTitle;
@property (nonatomic,strong) UIButton *pushAcvitityButton;
@property (nonatomic,strong) UIImageView *backImage;


- (void)requestActivityImage:(NSString *)cityCode;
-(void)initUI;



//移除view
@property (nonatomic,copy) void(^CloseActivityButtonClick)();

//进入活动详情block
@property (nonatomic,copy) void(^pushActivityController)();

//请求失败弹出登录页
@property (nonatomic,copy) void(^pushLoginViewController)();

@end
