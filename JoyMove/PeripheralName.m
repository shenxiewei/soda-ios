//
//  PeripheralName.m
//  BluetoothFuturemove
//
//  Created by ethen on 15/5/27.
//  Copyright (c) 2015年 ez. All rights reserved.
//

#import "PeripheralName.h"

@implementation PeripheralName

#define prefix  @"FM-"
#define codeLength 6
/*
蓝牙名称由公司简写、间隔符和设备名称组成，总长度为9个字节；
公司简写固定为”FM“ ，2个字节；
间隔符固定为”-“，中划线，1个字节；
设备名称,6个字节，根据随机授权码进行转换
设备名称的来源：
通过接收到的授权码进行转换后得到；
转换方法：
设备名称的第1字节为 授权码的第2字节；
设备名称的第2字节为 授权码的第4字节；
设备名称的第3字节为 授权码的第6字节；
设备名称的第4字节为 授权码的第1字节；
设备名称的第5字节为 授权码的第3字节；
设备名称的第6字节为 授权码的第5字节；

例如：
授权码为”ABCDEF“
转换后为”BDFACE“
最终蓝牙广播名称为”FM-BDFACE“
*/

+ (NSString *)generatingPeripheralNameWithCode:(NSString *)code {
    
    if (!code||code.length!=codeLength) {
        
        return @"";
    }
    
    NSMutableString *peripheralName = [@"" mutableCopy];
    [peripheralName appendString:prefix];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(1, 1)]];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(3, 1)]];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(5, 1)]];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(0, 1)]];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(2, 1)]];
    [peripheralName appendString:[code substringWithRange:NSMakeRange(4, 1)]];
    
    return peripheralName;
}
@end
