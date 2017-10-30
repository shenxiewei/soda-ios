//
//  WebViewController.h
//  PetBar
//
//  Created by zhangYuan on 14-6-27.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WebViewDelegate <NSObject>

@optional
- (void)didAgreed;

@end


@interface WebViewController : BaseViewController <UIWebViewDelegate>

@property (assign, nonatomic) id<WebViewDelegate> delegate;

- (void)isActivityPush:(BOOL)isActivity;

- (void)isDepositPush;

- (BOOL)isShow;
//获取分享的活动图片
- (void)getImageURL:(NSString *)imageURL;
- (void)loadUrl:(NSString *)urlStr;
- (void)setHideAgreeButton:(BOOL)isHide;

@end
