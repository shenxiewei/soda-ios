//
//  BluetoothPacket.m
//  BluetoothFuturemove
//
//  Created by ethen on 15/5/14.
//  Copyright (c) 2015年 ez. All rights reserved.
//

#import "BluetoothPacket.h"
#include "stdio.h"

@implementation BluetoothPacket

+ (NSArray *)order:(unsigned char)order authCode:(unsigned char *)code {
    
    //起始符
    unsigned char a = 0x24;
    unsigned char b = 0x24;
    
    //命令单元
    unsigned char c = order;
    unsigned char d = 0xfe;
    
    //不加密
    unsigned char f = 0x00;
    unsigned char g = 0x01;
    
    NSArray *array;
    if (0x01==c) {
        
        unsigned char ch1[] = {c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x02, 0x00, 0x78};
        unsigned parity = [BluetoothPacket parity:ch1 length:sizeof(ch1)];
        unsigned char re[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x02, 0x00, 0x78, parity, 0x23};
        NSData *data = [[NSData alloc] initWithBytes:re length:sizeof(re)];
        array = @[data];
    }else if (0x02==c) {
        
        unsigned char ch1[] = {c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x02, 0x00, 0x00};
        unsigned parity = [BluetoothPacket parity:ch1 length:sizeof(ch1)];
        unsigned char re[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x02, 0x00, 0x00, parity, 0x23};
        NSData *data = [[NSData alloc] initWithBytes:re length:sizeof(re)];
        array = @[data];
    }else if (0x03==c) {
        
        unsigned char ch1[] = {c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05};
        unsigned parity = [BluetoothPacket parity:ch1 length:sizeof(ch1)];
//        unsigned char re1[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x09};
//        unsigned char re2[] = {0x00, 0x03, 0x00, 0x00, 0x00, 0x05, parity, 0x00};
//        NSData *data1 = [[NSData alloc] initWithBytes:re1 length:sizeof(re1)];
//        NSData *data2 = [[NSData alloc] initWithBytes:re2 length:sizeof(re2)];
//        array = @[data1, data2];
        unsigned char re3[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05, parity, 0x23};
        NSData *data3 = [[NSData alloc] initWithBytes:re3 length:sizeof(re3)];
        array = @[data3];
    }else if (0x04==c) {
        
        unsigned char ch1[] = {c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x64, 0x00, 0x01, 0x00, 0x00, 0x00, 0x64};
        unsigned parity = [BluetoothPacket parity:ch1 length:sizeof(ch1)];
//        unsigned char re1[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x64};
//        unsigned char re2[] = {0x00, 0x03, 0x00, 0x00, 0x00, 0x05, parity, 0x00};
//        NSData *data1 = [[NSData alloc] initWithBytes:re1 length:sizeof(re1)];
//        NSData *data2 = [[NSData alloc] initWithBytes:re2 length:sizeof(re2)];
//        array = @[data1, data2];
        unsigned char re3[] = {a, b, c, d, code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7], code[8], code[9], code[10], code[11], code[12], code[13], code[14], code[15], f, g, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x64, 0x00, 0x01, 0x00, 0x00, 0x00, 0x64, parity, 0x23};
        NSData *data3 = [[NSData alloc] initWithBytes:re3 length:sizeof(re3)];
        array = @[data3];
    }else {
        
        array = @[];
    }
    
    return array;
}

+ (unsigned char)parity:(unsigned char *)data length:(long)length {
    
    unsigned char result = 0;
    for (int i=0; i<length; ++i) {
        
        result ^= data[i];
    }
    
    return result;
}

@end
