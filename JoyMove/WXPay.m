//
//  WXPay.m
//  JoyMove
//
//  Created by 刘欣 on 15/5/7.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "WXPay.h"

@implementation WXPay

+ (void)pay:(NSDictionary *)payDic{

    if (![WXApi isWXAppInstalled]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"尚未检测到相关客户端，建议你选择其他付款方式" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSString *stamp  = [payDic objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [payDic objectForKey:@"appid"];
    req.partnerId           = [payDic objectForKey:@"partnerid"];
    req.prepayId            = [payDic objectForKey:@"prepayid"];
    req.nonceStr            = [payDic objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [payDic objectForKey:@"package"];
    req.sign                = [payDic objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}


@end
