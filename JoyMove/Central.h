//
//  Central.h
//  JoyMove
//
//  Created by ethen on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol CentralDelegate <NSObject>

- (void)connectDidSuccess:(NSInteger)index;
- (void)connectDidFail:(NSInteger)index;
- (void)connectDidLost;
- (void)connectDidTimeover:(NSInteger)index;
- (void)writeDidTimeover;
- (void)didReadValue:(NSData *)data;
- (void)connectDidAbnormal:(NSString *)string;

@end

@interface Central : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) id<CentralDelegate> delegate;

- (void)connect:(NSString *)authCode name:(NSString *)name order:(NSInteger)index;
- (void)disconnect;
- (BOOL)isConnected;
- (void)writeValue:(NSData *)data;

@end
