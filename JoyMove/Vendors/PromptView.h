//
//  PromptView.h
//  JoyMove
//
//  Created by 刘欣 on 15/8/14.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PromptViewStyle) {
    
    ValidDatePromptViewTag = 1000,
    CVV2PromptViewTag,
    RentSuccessPromptViewTag,
    TerminateRentPromptViewTag,
    //还车失败
    ReturnCarFailureTag,
    //一键租车失败
    AKeyRentCarFailureTag
};

@protocol PromptViewDelegate <NSObject>

- (void)promptView:(PromptViewStyle)promptViewStyle clicked:(NSInteger)tag;

@end

@interface PromptView : UIView

/** 租车成功动态引导图1 */
@property (nonatomic, copy) NSString *icon_td_nor;
/** 租车成功动态引导图2 */
@property (nonatomic, copy) NSString *icon_td_pre;

/** 租车引导动态图导图3*/
@property (nonatomic, copy) NSString *icon_td_tips;
//carID
@property (copy,nonatomic) NSString *carID;
//回调还车失败button的点击事件
@property (copy,nonatomic) void (^pushController)();
//回调一键租车失败button点击事件
@property (copy,nonatomic) void (^pushAllCarController)();
//催我建站回调页面
@property (nonatomic,copy) void(^UrgeSiteButtonClick)();
//催我建站回调页面
@property (nonatomic,copy) void(^pushLoginViewController)();

@property (nonatomic,assign)id <PromptViewDelegate> promptViewDelegate;

- (instancetype)initWithPromptViewStyle:(PromptViewStyle)promptViewStyle;

@end
