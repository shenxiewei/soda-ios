//
//  DepositData.h
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"

@interface DepositData : NSObject

@property(nonatomic,assign)double balance;
@property(nonatomic,assign)DeopositStatus status;
@property(nonatomic,copy) NSString *refundID;

+ (DepositData *)shareIntance;

@end
