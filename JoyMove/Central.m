//
//  Central.m
//  JoyMove
//
//  Created by ethen on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "Central.h"
#import "BluetoothPacket.h"
#import "PeripheralName.h"
#import "Macro.h"

@interface Central (){
    
    CBCentralManager    *_centralManager;
    CBPeripheral        *_activePeripheral;
    NSTimer             *_connectTimer;
    NSArray             *_characteristicArray;
    BluetoothPacket     *_packet;
    NSString            *_peripheralName;
    
    NSInteger _order;   //预设命令，连接成功后自动发送该命令一次
}

@end

@implementation Central

//static NSString * const kSerview_UUID           = @"FFE0";
//static NSString * const kCharacteristic_UUID    = @"FFE1";
const int kConnectTimeout                              = 10;
const int kWriteTimeout                                = 6;
static Central *myCentral                       = nil;

#pragma mark - Interface

//连接
- (void)connect:(NSString *)authCode name:(NSString *)name order:(NSInteger)index {
    
    _order = index; //设置预设命令
    _peripheralName = name; //设置蓝牙名
    
//    //将授权码转换成peripheralName
//    _peripheralName = [PeripheralName generatingPeripheralNameWithCode:authCode];
    
    _characteristicArray = @[];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [_connectTimer invalidate];
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectTimeout target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
}

//断开
- (void)disconnect {
    
    [self stop];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidLost)]) {
        
        [self.delegate connectDidLost];
    }
    _order = -1;    //清除预设命令
}

//判断是否连接
- (BOOL)isConnected {
    
    NSLog(@"..%li", (long)_activePeripheral.state);
    return _activePeripheral&&(_activePeripheral.state==CBPeripheralStateConnected);
}

//发送数据
- (void)writeValue:(NSData *)data {
    
    NSLog(@"发送数据=%@", [data description]);
    
    [_connectTimer invalidate];
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:kWriteTimeout target:self selector:@selector(writeTimeout) userInfo:nil repeats:NO];
    
    for (CBCharacteristic *_characteristic in _characteristicArray) {
        
        [_activePeripheral writeValue:data forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark -

- (void)connectTimeout {
    
    [self stop];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidTimeover:)]) {
        
        [self.delegate connectDidTimeover:_order];
    }
    _order = -1;    //清除预设命令
}

- (void)writeTimeout {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(writeDidTimeover)]) {
        
        [self.delegate writeDidTimeover];
    }
}

- (void)stop {
    
    _peripheralName = @"";
    _activePeripheral.delegate = nil;
    _activePeripheral = nil;
    [_centralManager stopScan];
    _centralManager.delegate = nil;
    _centralManager = nil;
}

- (void)writeValue:(char *)ch characteristic:(CBCharacteristic *)characteristic {
    
    NSData *data = [[NSData alloc] initWithBytes:ch length:sizeof(ch)];
    [_activePeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)readValue:(CBCharacteristic *)characteristic {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didReadValue:)]) {
        
        [self.delegate didReadValue:characteristic.value];
    }
}

#pragma mark - 

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"centralManagerDidUpdateState");
    
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            
            [_centralManager scanForPeripheralsWithServices:nil options:0];
            break;
        default:
            
            NSLog(@"Peripheral Manager did change state.");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"find peripheral：%@（%f）<%@>", peripheral.name, kDoubleFormObject(RSSI), advertisementData);
    
    //使用advertisementData里的设备name，而不使用peripheral.name，因为peripheral.name有历史缓存，在设备名称改变后不能立即生效
    NSString *peripheralName = advertisementData[@"kCBAdvDataLocalName"];
    peripheralName = [peripheralName stringByReplacingOccurrencesOfString:@"\x01" withString:@""];  //天知道为什么字符尾部会有个\x01
    
    if ([peripheralName isEqualToString:_peripheralName]) {
        
        [_centralManager stopScan];
        _activePeripheral = peripheral;
        _activePeripheral.delegate = self;
        [_centralManager connectPeripheral:_activePeripheral options:nil];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidAbnormal:)]) {
            
            [self.delegate connectDidAbnormal:@"蓝牙模块已经找到"];
        }
    }else {
        
        ;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [_activePeripheral discoverServices:nil];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidAbnormal:)]) {
        
        [self.delegate connectDidAbnormal:@"蓝牙模块已经连接"];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    [self stop];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidFail:)]) {
        
        [self.delegate connectDidFail:_order];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    ;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        
        return;
    }
    
    for (CBService *service in peripheral.services) {

        //if ([service.UUID isEqual:[CBUUID UUIDWithString:kSerview_UUID]]) {
            
            [peripheral discoverCharacteristics:nil forService:service];
        //}
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidAbnormal:)]) {
        
        [self.delegate connectDidAbnormal:@"服务已经匹配"];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        
        return;
    }
    
    [_connectTimer invalidate];
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"characteristic.uuid-->%@", characteristic.UUID.UUIDString);
        
        //if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristic_UUID]]) {
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
  
            NSMutableArray *mutableArray = [_characteristicArray mutableCopy];
            [mutableArray addObject:characteristic];
            _characteristicArray = mutableArray;
        //}
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidAbnormal:)]) {
        
        [self.delegate connectDidAbnormal:@"特征已经匹配"];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    NSLog(@"didUpdateNotificationState");
    
    if (error) {

        NSLog(@"Error changing notification state:%@", error.localizedDescription);
        return;
    }
    
    if (characteristic.isNotifying) {

        NSLog(@"Notification began on %@", characteristic);
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(connectDidSuccess:)]) {
            
            [self.delegate connectDidSuccess:_order];
        }
        _order = -1;    //连接成功执行一次预设命令，随后清除预设命令
    }else {

        NSLog(@"Notification stopped on %@ Disconnecting", characteristic);
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"didUpdateValueForCharacteristic");
    [_connectTimer invalidate];
    
    if (characteristic.isNotifying) {
        
        [self readValue:characteristic];
    }else {
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    ;
}

@end
