//
//  DepositViewController.h
//  JoyMove
//
//  Created by Soda on 2017/3/7.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BaseViewController.h"
#import "UserData.h"

@interface DepositViewController : BaseViewController

@property(nonatomic,assign)double balance;
@property(nonatomic,assign)double defaultAmout;
@property(nonatomic,assign)DeopositStatus status;
@property(nonatomic,assign)BOOL isNeedCharge;
@property(nonatomic,assign)BOOL isPaySuccessPopToRoot;

- (id)initWithParams:(NSDictionary *)params;

@end
