//
//  CreditCardViewController.h
//  JoyMove
//
//  Created by 刘欣 on 15/8/7.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"

@protocol CreditCardDelegate <NSObject>

- (void)didBindCreditCard;

@end

@interface CreditCardViewController : BaseViewController

@property(nonatomic,assign)id <CreditCardDelegate> creditCardDelegate;

@property(nonatomic,assign) BOOL isPresentView;

@end
