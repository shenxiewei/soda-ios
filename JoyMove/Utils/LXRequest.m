//
//  LXRequest.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "LXRequest.h"
#import "AFNetworking.h"
#import "UserData.h"
#import "Macro.h"
#import "sys/utsname.h"
#import "AppDelegate.h"
#import "SDCUUID.h"

#import "SVProgressHUD.h"

@implementation LXRequest

+ (void)requestWithJsonDic:(NSDictionary *)jsonDic andUrl:(NSString *)strUrl completeHandle:(void (^)(BOOL, NSDictionary *, NSInteger))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;

    NSMutableDictionary *dic = [jsonDic mutableCopy];
    if (!dic[@"mobileNo"]) {
        
        [dic setObject:[UserData userData].mobileNo forKey:@"mobileNo"];
    }
    if (!dic[@"authToken"]) {
        
        [dic setObject:[UserData userData].authToken forKey:@"authToken"];
    }
    NSLog(@"请求链接=%@ \n 请求参数=%@", strUrl, dic);
    
    // 上传各种信息
    NSString *type = @"ios";
    [manager.requestSerializer setValue:type forHTTPHeaderField:@"phoneType"];
    // app版本
    NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:appCurVersion forHTTPHeaderField:@"appVersion"];
    // 手机型号
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *phoneModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"phoneModel"];
    //手机系统版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [manager.requestSerializer setValue:systemVersion forHTTPHeaderField:@"systemVersion"];

    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *responseData = [[NSData alloc] initWithData:operation.responseData];
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *resultString = response[@"result"];
        NSInteger result = resultString ? [resultString integerValue] : -1;
        if (block) {
            
            if (response) {
               block(YES, response, result);
            }else {
                
                NSLog(@"response=nil");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            
            block(NO, nil, -1);
            
            NSLog(@"网络异常，或服务器未返回数据---%@", error);
        }
    }];
    dic = nil;
}
    
//json数据请求
//+ (void)requestWithJsonDic:(NSDictionary *)jsonDic andUrl:(NSString *)strUrl completeHandle:(void (^)(BOOL, NSDictionary *, NSInteger))block {
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSMutableDictionary *dic = [jsonDic mutableCopy];
//    if (!dic[@"mobileNo"]) {
//        
//        [dic setObject:[UserData userData].mobileNo forKey:@"mobileNo"];
//    }
//    if (!dic[@"authToken"]) {
//        
//        [dic setObject:[UserData userData].authToken forKey:@"authToken"];
//    }
//    
//    NSLog(@"请求链接=%@ \n 请求参数=%@", strUrl, dic);
//    
//    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSData *responseData = [[NSData alloc] initWithData:operation.responseData];
//        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
//        NSString *resultString = response[@"result"];
//        NSInteger result = resultString ? [resultString integerValue] : -1;
//        if (block) {
//            
//            if (response) {
//                
//                block(YES, response, result);
//
//                NSLog(@"response=%@", responseObject);
//            }else {
//
//                NSLog(@"response=nil");
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (block) {
//            
//            block(NO, nil, -1);
//
//            NSLog(@"网络异常，或服务器未返回数据");
//        }
//    }];
//    dic = nil;
//}

+ (NSDictionary *)jsonToDictionary:(NSString *)string {      //json串 -> dictionary
    
    if ([string isKindOfClass:[NSString class]] &&
        string.length) {
        
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            
            NSLog(@"解析失败的内容=%@", string);
            
            return nil;
        }
        
        NSLog(@"解析完成的内容=%@", dic);
        
        return dic;
    }
    
    return nil;
}
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

+ (NSData *)dictionaryToJson: (NSDictionary *)dictionary {     //dictionary -> json串 -> data
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        
        NSLog(@"packaging error=%@", error.userInfo);
        
        return nil;
    }
    
    return data;
}

@end
