//
//  支付二次封装
//  PayDemo
//
//  Created by Tsy on 16/7/11.
//  Copyright © 2016年 Tsy. All rights reserved.
//

#import "PayApi.h"

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#define kWechatAPPID @"wx22ee5da19c49b166"

@interface PayApi()<WXApiDelegate>

@property (nonatomic, copy) void(^WXPaySuccess)();
@property (nonatomic, copy) void(^WXPayError)(NSInteger err_code);
@property (nonatomic, copy) void(^WXLoginSuccess)(NSDictionary *params);
@property (nonatomic, copy) void(^WXLoginFailed)();

@end

@implementation PayApi

static id _instance;

+ (instancetype)sharedApi {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PayApi alloc] init];
    });
    
    return _instance;
}

//回调处理
- (BOOL) handleOpenURL:(NSURL *) url{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

//支付宝支付
- (void)alipayWithPayParam:(NSString *)pay_param
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSInteger))failBlock {
    
    //获取App Scheme
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
//    NSDictionary *infoData = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSArray *array = [infoData objectForKey:@"CFBundleURLTypes"];
//    
//    NSString *appScheme = [NSMutableString string];
//    for (NSDictionary *dict in array) {
//        if ([dict[@"CFBundleURLName"] isEqualToString:@"alipay"]) {
//            appScheme = dict[@"CFBundleURLSchemes"];
////            NSString * appSchemeStr = dict[@"CFBundleURLSchemes"];
////            for (NSString *str in appSchemeStr) {
////                appScheme = str;
////            }
//        }
//    }
//    
//    if (appScheme == nil) {
//        failBlock(ALIPAYERROR_SCHEME);
//        return;
//    }

    
    
    [[AlipaySDK defaultService] payOrder:pay_param fromScheme:@"Soda" callback:^(NSDictionary *resultDic) {
        NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
        switch (resultCode) {
            case 9000:     //支付成功
                successBlock();
                break;
            
            case 6001:     //支付取消
                failBlock(ALIPAYCANCEL_PAY);
                break;
                
            default:        //支付失败
                failBlock(ALIPAYERROR_PAY);
                break;
        }
    }];
}

//微信支付
- (void)wxPayWithPayParam:(NSDictionary *)pay_param
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSInteger))failBlock {
    self.WXPaySuccess = successBlock;
    self.WXPayError = failBlock;
    
    NSString *appid = pay_param[@"appid"];
    NSString *partnerid = pay_param[@"partnerid"];
    NSString *prepayid = pay_param[@"prepayid"];
    NSString *package = pay_param[@"package"];
    NSString *noncestr = pay_param[@"noncestr"];
    NSString *timestamp = pay_param[@"timestamp"];
    NSString *sign = pay_param[@"sign"];
    
//    if(error != nil) {
//        failBlock(WXERROR_PAYPARAM);
//        return ;
//    }
    
    [WXApi registerApp:appid];
    
    if(![WXApi isWXAppInstalled]) {
        failBlock(WXERROR_NOTINSTALL);
        return ;
    }
    
    //发起微信支付
    PayReq* req   = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.prepayId  = prepayid;
    req.nonceStr  = noncestr;
    req.timeStamp = timestamp.intValue;
    req.package   = package;
    req.sign      = sign;
    [WXApi sendReq:req];
}

- (void)wxLoginSuccess:(void (^)(NSDictionary *))successBlock
               failure:(void (^)(NSInteger))failBlock
{
    
    self.WXLoginSuccess = successBlock;
    self.WXLoginFailed = failBlock;
    
    [WXApi registerApp:kWechatAPPID];
    
    if(![WXApi isWXAppInstalled]) {
        failBlock(WXERROR_NOTINSTALL);
        return ;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

#pragma mark - 微信回调

- (void)onResp:(BaseResp *)resp{
    NSLog(@"onResp");
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
         NSDictionary *dic = @{@"errCode":[NSNumber numberWithInt:response.errCode]};
        
        //兼容以前的微信支付
        if (dic) {
            //把微信支付回调的数据进行广播
            PostNotificationAllParameter(@"wxPayResult", nil, dic);
        }
        if (!self.WXPaySuccess) {
            return;
        }
        //兼容以前的微信支付
        
        switch (response.errCode) {
            case WXSuccess:
                self.WXPaySuccess();
                break;
                
            case WXErrCodeUserCancel:   //用户点击取消并返回
                self.WXPayError(WXCANCEL_PAY);
                break;

            default:        //剩余都是支付失败
                self.WXPayError(WXERROR_PAY);
                break;
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        if (authResp.code) {
            NSDictionary *dic = @{@"code": authResp.code};
            self.WXLoginSuccess(dic);
        }
    }
}


@end
