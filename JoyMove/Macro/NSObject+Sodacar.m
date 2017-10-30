//
//  NSObject+Sodacar.m
//  JoyMove
//
//  Created by Soda on 2017/3/9.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "NSObject+Sodacar.h"
#import <objc/runtime.h>

@implementation NSObject (Sodacar)

//字典转模型
+ (instancetype)sdc_initWithDictionary:(NSDictionary *)dic
{
    id myObj = [[self alloc] init];
    
    unsigned int outCount;
    
    //获取类中的所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        
        //获取属性名字符串
        //model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = dic[propertyName];
        
        if (propertyValue != nil) {
            [myObj setValue:propertyValue forKey:propertyName];
        }
    }
    
    free(arrPropertys);
    
    return myObj;
}
@end
