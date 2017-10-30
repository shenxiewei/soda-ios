//
//  BaseViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXRequest.h"
#import "UserData.h"
#import "Macro.h"
#import "UserData.h"
#import "ColorMacro.h"

typedef void (^PushLoginBlock)();

typedef NS_ENUM(NSInteger, BaseViewTag) {
    
    BVTagBack = 100,  /**< 返回 */
    BVTagCancel,      /**< 取消 */
};

@interface BaseViewController : UIViewController
{
    __weak BaseViewController *weakSelf;
}

@property(nonatomic,strong)UIView *baseView;

//弹出登录页的block
-(void)createNoNetWorkViewWithReloadBlock:(PushLoginBlock)reloadData;
//获取用户登录状态,未登录时弹出登录页
- (BOOL)isLogin;
//导航条返回按钮
- (void)setNavBackButtonTitle:(NSString *)title;
//导航条按钮样式 返回－BVTagBack 取消－BVTagCancel
- (void)setNavBackButtonStyle:(BaseViewTag)style;
- (void)setNavRightButton:(UIButton *)button;
//导航按钮事件
- (void)navButtonClicked:(UIButton *)button;
- (void)loginViewControllerNil;


//hud
- (void)showIndeterminate:(NSString *)text;
- (void)showSuccess:(NSString *)text;
- (void)showError:(NSString *)text;
- (void)showInfo:(NSString *)text;
- (void)showProgress:(float)progress text:(NSString *)text;
- (void)hide;

@end
