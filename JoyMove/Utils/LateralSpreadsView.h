//
//  LateralSpreadsView.h
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LateralSpreadsViewTag) {
    
//    LSVTagAddress,              /**< 常用地址 */
    LSVTagHistory,              /**< 我的行程 */
    LSVTagMoney,                /**< 我的钱包 */
    LSVTagMyCar,
    LSVTagNotif,                /**< 消息中心 */
//    LSVTagRanking,                /**< 用车排行 */
    LSVTagShare,                /**< 分享 */
    LSVTagSetup,                /**< 设置 */
    
    LSVTagUserInfo = 100,       /**< 用户信息 */
    LSVTagHelp,                 /**< 帮助 */
    
};

@protocol LateralSpreadsDelegate <NSObject>

- (void)clickedIndex:(LateralSpreadsViewTag)tag;
- (void)didShow;
- (void)didHide;

@end


@interface LateralSpreadsView : UIView

@property (assign, nonatomic) id<LateralSpreadsDelegate> delegate;

- (void)handlePan:(UIPanGestureRecognizer *)rec;
- (void)initUI;
- (void)update;
- (void)updateUserStatus:(NSDictionary *)dic;
- (void)show;
- (void)hide;
- (BOOL)isShow;

@end
