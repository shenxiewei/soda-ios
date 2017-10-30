//
//  LXRequest.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/6.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXRequest : NSObject

+ (void)requestWithJsonDic:(NSDictionary *)jsonDic andUrl:(NSString *)strUrl completeHandle:(void(^)(BOOL success, NSDictionary *response, NSInteger result))block;
+ (NSDictionary *)jsonToDictionary:(NSString *)string;
+ (NSData *)dictionaryToJson: (NSDictionary *)dictionary;

@end
