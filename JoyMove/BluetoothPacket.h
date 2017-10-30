//
//  BluetoothPacket.h
//  BluetoothFuturemove
//
//  Created by ethen on 15/5/14.
//  Copyright (c) 2015年 ez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothPacket : NSObject

//将指令和授权码转换成待发送的蓝牙包，根据硬件需求已分包
+ (NSArray *)order:(unsigned char)order authCode:(unsigned char *)code;

@end
