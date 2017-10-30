//
//  SDCWebViewController.h
//  JoyMove
//
//  Created by Soda on 2017/10/12.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDCWebViewController : UIViewController

@property(nonatomic, strong) UIWebView *myWebView;

- (void)loadUrl:(NSString *)urlStr;
@end
