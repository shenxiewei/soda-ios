//
//  Peripheral.h
//  JoyMove
//
//  Created by ethen on 15/4/3.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol PeripheralDelegate <NSObject>

- (void)connectDidSuccess:(CBCentral *)central;
- (void)connectDidLost;

@end

@interface Peripheral : NSObject<CBPeripheralManagerDelegate>

@property (nonatomic, assign) id<PeripheralDelegate>    delegate;
@property (nonatomic, strong) CBPeripheralManager       *manager;
@property (nonatomic, strong) CBMutableCharacteristic   *customCharacteristic;     //特征
@property (nonatomic, strong) CBMutableService          *customService;            //服务
@property (nonatomic, strong) CBCentral                 *targetCentral;

+ (Peripheral *)peripheral;
- (void)connect;
- (void)disconnect:(BOOL)noBackcall;
- (BOOL)setNotif:(NSString *)message;
+ (BOOL)isConnected;

@end
