//
//  FMShare.h
//  JoyMove
//
//  Created by 刘欣 on 15/4/7.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define kShareCompleteNotification @"kShareCompleteNotification"

@interface FMShare : NSObject
//分享活动
+(void)shareActivityURL:(NSString *)URL title:(NSString *)titleText image:(NSString *)imageURL;

+(void)shareRentForMonthActivityURL:(NSString *)URL title:(NSString *)titleText image:(NSString *)imageURL;

+(void)shareRentForMonthActivityURL:(NSString *)URL title:(NSString *)titleText content:(NSString *)contentText image:(NSString *)imageURL;
//分享邀请码
+(void)shareInviteCode:(NSString *)shareInviteCode;
//分享图片
+(void)shareImage:(NSString *)imageName;

@end
