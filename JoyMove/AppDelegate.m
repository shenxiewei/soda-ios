//
//  AppDelegate.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AppDelegate.h"
#import "LXRequest.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ThankYouViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BillViewController.h"
#import "TimeLabel.h"
#import "Tool.h"

#import "UMMobClick/MobClick.h"

#import "PayApi.h"
#import "SVProgressHUD.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AppDelegate ()<WXApiDelegate> {
    
    ViewController *_viewController;
    TimeLabel *_feeAndMile;
}

@end

@implementation AppDelegate

BOOL isRelease;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //配置高德导航sdk的key
    [AMapServices sharedServices].apiKey = mapApiKey;
    //[SVProgressHUD setMinimumDismissTimeInterval:3.0];
    
    isRelease = release; //服务器环境切换，在config里配置即可
   
    
    _viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    //添加小米推送
    [MiPushSDK registerMiPush:self type:2 connect:YES];
     [self loadShareSDK];
//    [UIApplication sharedApplication].idleTimerDisabled = YES;  //禁用系统的自动锁屏功能
    
    
#ifdef DEBUG
    
    
    NSLog(@"debug");
    
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
    
    NSLog(@"release");
    
    //添加友盟统计
//    [MobClick startWithAppkey:@"56a1cf5ce0f55ad458001306" reportPolicy:BATCH   channelId:@""];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = @"56a1cf5ce0f55ad458001306";
    UMConfigInstance.ChannelId = @"App Store";

    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
     NSLog(@"release");
#define CLog(format, ...)
#endif
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    //register to receive notifications
    [application registerForRemoteNotifications];
}

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败.
    // 自行处理.
}

#pragma mark Local And Push Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}

#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    
}

- ( void )miPushReceiveNotification:( NSDictionary *)data
{
    // 1.当启动长连接时, 收到消息会回调此处
    // 2.[MiPushSDK handleReceiveRemoteNotification]
    //   当使用此方法后会把APNs消息导入到此
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    PostNotificationAllParameter(@"applicationEnterBackgroundOrForeground", nil, @{@"isEnterBackground":@YES});
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    PostNotificationAllParameter(@"applicationEnterBackgroundOrForeground", nil, @{@"isEnterBackground":@NO});
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;      // 移除app icon上的数字
    [[UIApplication sharedApplication] cancelAllLocalNotifications];       // 移除通知栏上的所有消息
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"isPayEnd" object:self];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2) {
//    
//    [self handleOpenURLForAlipay:url];  //处理url:若是从支付宝返回,做相应处理
//    [self handleOpenURLForWxpay:url];   //处理url:若是从微信支付返回,做相应处理
////    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
////    
////        NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
////    
////        return  isSuc;
//    
////    return [ShareSDK handleOpenURL:url
////                 sourceApplication:sourceApplication
////                        annotation:annotation
////                        wxDelegate:self];
//    
//    return YES;
//}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply NS_AVAILABLE_IOS(8_2) {
    
    NSMutableDictionary *mutableDic = [@{} mutableCopy];
    if ([userInfo.allKeys containsObject:@"avatars"]) {
        
        NSURL *url = [NSURL URLWithString:kUrlHeader];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [mutableDic setObject:data forKey:@"avatars"];
    }
    if ([userInfo.allKeys containsObject:@"unlock"]) {
        
        PostNotification(@"unlock");
    }
    if ([userInfo.allKeys containsObject:@"lock"]) {
        
        PostNotification(@"lock");
    }
    if ([userInfo.allKeys containsObject:@"pingCar"]) {
    
        PostNotification(@"pingCar");
    }
    if ([userInfo.allKeys containsObject:@"map"]) {
        
        NSArray *car = [_viewController getCarLocation];
        [mutableDic setObject:car forKey:@"carLocation"];
        NSDictionary *userLocation = [_viewController getUserLocation];
        [mutableDic setObject:userLocation forKey:@"userLocation"];
        
    }if([userInfo.allKeys containsObject:@"feeAndMile"]){
        _feeAndMile = [[TimeLabel alloc] init];
        [_feeAndMile requestForTheCostcompleteHandle:^(NSString *fee, NSString *mile) {
            [Tool setCache:@"fee" value:fee];
            [Tool setCache:@"mile" value:mile];
        }];
    }

    [mutableDic setObject:@([OrderData orderData].state) forKey:@"state"];
    [mutableDic setObject:[UserData userData].mobileNo forKey:@"mobileNo"];
    [mutableDic setObject:@([OrderData orderData].startTime) forKey:@"startTime"];
    [mutableDic setObject:@([OrderData orderData].stopTime) forKey:@"stopTime"];
    
    NSString *feeString = [Tool getCache:@"fee"];
    NSString *mileString = [Tool getCache:@"mile"];
    if(feeString.length > 0){
        [mutableDic setObject:feeString forKey:@"fee"];
    }if(mileString.length > 0){
        [mutableDic setObject:mileString forKey:@"mile"];
    }
    NSDictionary *replyInfo = mutableDic;
    reply(replyInfo);
}

#pragma mark - URL处理
/*
//处理从支付宝返回的url
- (void)handleOpenURLForAlipay:(NSURL *)url {
    
    if (url && ![[url host] compare:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = ******* %@",resultDic);
        }];
    }
//    if () {
//        <#statements#>
//    }
//    if (url && ![[url host] compare:@"safepay"]) {
//        
//        NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [query dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        
//        if (dic) {
//            
//            //把支付宝回调的数据进行广播
//            PostNotificationAllParameter(@"alipaySafepay", nil, dic);
//        }
//    }
}

//处理从微信支付返回的url
- (void)handleOpenURLForWxpay:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSDictionary *dic = @{@"errCode":[NSNumber numberWithInt:response.errCode]};
        
        if (dic) {
            
            //把微信支付回调的数据进行广播
            PostNotificationAllParameter(@"wxPayResult", nil, dic);
        }
        
        NSLog(@"%@",dic);
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
                
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        if (authResp.code) {
            NSDictionary *dic = @{@"code": authResp.code};
            //把微信登录回调的数据进行广播
            PostNotificationAllParameter(@"weChatLogin", nil, dic);
        }
        
    }
}
*/
#pragma mark - loadShareSDK

- (void)loadShareSDK {

    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                default:
                                                    break;
                                            }
                             }
                             onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                switch (platformType)
                                                {
                                                    case SSDKPlatformTypeSinaWeibo:
                                                        [appInfo SSDKSetupSinaWeiboByAppKey:@"325961663"
                                                                                  appSecret:@"79aab7db3dc1179f8681769d44cf97b"
                                                                                redirectUri:ShareRedirectUri
                                                                                   authType:SSDKAuthTypeBoth];
                                                        break;
                                                        
                                                    case SSDKPlatformTypeWechat:
                                                        [appInfo SSDKSetupWeChatByAppId:@"wx22ee5da19c49b166"
                                                                              appSecret:@"46232bb498375cdec19c62025d5ec604"];
                                                        break;
                                                        
                                                    case SSDKPlatformTypeQQ:
                                                        [appInfo SSDKSetupQQByAppId:@"1104776869"
                                                                             appKey:@"bsSiWeLUuCc3Ckb4"
                                                                           authType:SSDKAuthTypeBoth];
                                                        break;
                                                    default:
                                                        break;
                                                }
                             }];
                                            
        [WXApi registerApp:@"wx22ee5da19c49b166"];
}


//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    [self handleOpenURLForAlipay:url];  //处理url:若是从支付宝返回,做相应处理
//    [self handleOpenURLForWxpay:url];
//    return YES;
//}
//
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {

    return  [WXApi handleOpenURL:url delegate:self];

}
#pragma mark - URL处理
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[PayApi sharedApi] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[PayApi sharedApi] handleOpenURL:url];
}
@end
