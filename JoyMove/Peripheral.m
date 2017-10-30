//
//  Peripheral.m
//  JoyMove
//
//  Created by ethen on 15/4/3.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "Peripheral.h"

@interface Peripheral () {
    
    NSTimer *_connectTimer;
    NSData *_data;
    NSInteger *_i;
}

@end

@implementation Peripheral

static NSString * const kServiceUUID            = @"00001101-0000-1000-8000-00805F9B34FB";
static NSString * const kCharacteristicUUID     = @"FFA28CDE-6525-4489-801C-1C060CAC9767";
static NSString * const kLocalName              = @"JOYMove";

static Peripheral *myPeripheral     = nil;
const int kConnectTimeout           = 100;

+ (Peripheral *)peripheral {
    
    if (!myPeripheral) {
        
        myPeripheral = [[Peripheral alloc] init];
    }
    
    return myPeripheral;
}

//建立连接
- (void)connect {
    
    //[self disconnect:NO];
    
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    //开启超时timer
    [_connectTimer invalidate];
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectTimeout target:self selector:@selector(disconnect:) userInfo:nil repeats:NO];
}

//断开连接或连接超时
- (void)disconnect:(BOOL)noBackcall {
    
    _customCharacteristic = nil;
    _customService = nil;
    
    [_manager stopAdvertising];
    [_manager removeAllServices];
    _manager.delegate = nil;
    _manager = nil;
    
    if (!noBackcall) {
        
        if (myPeripheral.delegate && [myPeripheral.delegate respondsToSelector:@selector(connectDidLost)]) {
            
            [myPeripheral.delegate connectDidLost];
        }
    }
}

//发布消息
- (BOOL)setNotifWithString:(NSString *)message {

    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [_manager updateValue:data forCharacteristic:_customCharacteristic onSubscribedCentrals:@[_targetCentral]];
    
    return YES;
}

//发布消息
- (BOOL)setNotifWithData:(NSData *)data {
    
    [_manager updateValue:data forCharacteristic:_customCharacteristic onSubscribedCentrals:@[_targetCentral]];
    
    return YES;
}

#pragma mark -

//创建特征,将特征添加到服务上,添加服务
- (void)setupService {
    
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    _customCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite|CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    //_customCharacteristic.descriptors = @[@"911"];
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    _customService = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    [_customService setCharacteristics:@[_customCharacteristic]];
    
    [_manager addService:_customService];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            
            [self setupService];
            
            break;
            
        default:
            
            NSLog(@"Peripheral Manager did change state.");
            break;
    }
}

//服务已经添加
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    
    //广播服务
    if (!error) {
        
        [_manager startAdvertising:@{CBAdvertisementDataLocalNameKey:kLocalName,
                                               CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:kServiceUUID]]}];
    }
}

//广播已经开始
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
    //已经广播服务
    if (!error) {
        
        ;
    }
}

//广播的服务已经被订阅
//central订阅了characteristic的值，当更新值的时候peripheral会调用【updateValue: forCharacteristic: onSubscribedCentrals:(NSArray*)centrals】去为数组里面的centrals更新对应characteristic的值，在更新过后peripheral为每一个central走一遍改代理方法
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
    _targetCentral = central;
    
    NSLog(@"广播的服务已经被订阅");
}

//广播的服务已经被退订
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    
    NSLog(@"广播的服务已经被退订");

    _targetCentral = nil;
    
    if (myPeripheral.delegate && [myPeripheral.delegate respondsToSelector:@selector(connectDidLost)]) {
        
        [myPeripheral.delegate connectDidLost];
    }
}

//读的请求已经被收到
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    
    NSLog(@"读的请求已经被收到");
    NSLog(@"peripheral=%@", peripheral);
    
    [self setNotifWithString:[NSString stringWithFormat:@"%i", _i++]];
}

//写的请求已经被收到
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    
    NSLog(@"写的请求已经被收到");
    NSLog(@"peripheral=%@", peripheral);
    
    CBATTRequest *request = requests[0];
    _data = request.value;
    
    NSLog(@"对方请求write value=%@", _data);
}

//peripheral再次准备好发送Characteristic值的更新时候调用
//当updateValue: forCharacteristic:onSubscribedCentrals:方法调用因为底层用于传输Characteristic值更新的队列满了而更新失败的时候，实现这个委托再次发送改值
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    
    NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
}

@end
