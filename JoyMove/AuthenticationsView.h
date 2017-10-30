//
//  AuthenticationsView.h
//  JoyMove
//
//  Created by 刘欣 on 15/4/21.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//<认证浮窗>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AVButtonTag) {
    
    PhoneBindTag = 301,
    IdentifyTag,
    DriverTag,
    CashTag
};

@protocol AuthenticationDelegate <NSObject>

- (void)pushAuthentication:(AVButtonTag)tag;

@end

@interface AuthenticationsView : UIView

@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,assign)id <AuthenticationDelegate> authenticationDelegate;

- (void)initUIWithDictionary:(NSDictionary *)dic;
- (void)show;
- (void)hide;

@end
