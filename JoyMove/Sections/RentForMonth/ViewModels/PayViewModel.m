//
//  PayViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/17.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "PayViewModel.h"
#import "LXRequest.h"
#import "Macro.h"
#import "SVProgressHUD.h"

#import "PayApi.h"
#import "Alipay.h"

@interface PayViewModel()

@property(nonatomic, strong)RACCommand *alipayCommand;
@property(nonatomic, strong)RACCommand *wxpayCommand;

@end

@implementation PayViewModel

- (void)sdc_initialize
{
    @weakify(self)
    [self.balanceCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        
        [self.balanceSubject sendNext:nil];
    }];
    
    [self.checkPackageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *response) {
       @strongify(self)
        [self.allPackageSubject sendNext:response];
    }];
    
    [self.purchasePackageCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.paySuccessSubject sendNext:nil];
    }];
    
    [self.alipayCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.paySuccessSubject sendNext:nil];
    }];
    
    [self.wxpayCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.paySuccessSubject sendNext:nil];
    }];
}

- (RACCommand *)checkPackageCommand
{
    if (!_checkPackageCommand) {
        _checkPackageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlRentalPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        if (result == JMCodeSuccess) {
                            NSArray *array = response[@"list"];
                            [subscriber sendNext:array[0]];
                        }else if (result == JMCodeNeedLogin)
                        {
                            NSError *error = [[NSError alloc] initWithDomain:@"" code:result userInfo:nil];
                            [subscriber sendError:error];
                            [SVProgressHUD showErrorWithStatus:@"请重新登录" maskType:SVProgressHUDMaskTypeBlack];
                        }else
                        {
                            
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:JMMessageNetworkError maskType:SVProgressHUDMaskTypeBlack];
                    }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _checkPackageCommand;
}

- (RACCommand *)purchasePackageCommand
{
    if (!_purchasePackageCommand) {
        _purchasePackageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [SVProgressHUD showWithStatus:@"正在支付" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:params andUrl:kURL(kUrlPayPackage) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                     [SVProgressHUD dismiss];
                    if (success) {
                        
                        if (JMCodeSuccess==result) {
                            
                            NSString *paydic = response[@"pay_code"];
                            if (paydic) {
                                if ([params[@"type"] integerValue] == 1) {//支付宝
                                    [subscriber sendCompleted];
                                    NSString *payString = response[@"pay_code"];
                                    [self.alipayCommand execute:payString];
                                }else//微信
                                {
                                    [subscriber sendCompleted];
                                    NSString *payString = response[@"pay_code"];
                                    [self.wxpayCommand execute:payString];
                                }
                                
                            }
                            else if([params[@"type"] integerValue] == 6)//余额支付成功
                            {
                                [SVProgressHUD showSuccessWithStatus:@"支付成功" maskType:SVProgressHUDMaskTypeBlack];
                                [subscriber sendNext:nil];
                                [subscriber sendCompleted];
                            }
                            
                        
                        }else {
                            [SVProgressHUD dismiss];
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                             [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else {
                         [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:JMMessageNoErrMsg maskType:SVProgressHUDMaskTypeBlack];
                    }
                     [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _purchasePackageCommand;
}


- (RACCommand *)balanceCommand
{
    if (!_balanceCommand) {
        _balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlAccountCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [UserData share].balance = [response[@"balance"] doubleValue];
                            [subscriber sendNext:nil];
                        }else if (result == JMCodeNeedLogin)
                        {
                            NSError *error = [[NSError alloc] initWithDomain:@"" code:result userInfo:nil];
                            [subscriber sendError:error];
                             [SVProgressHUD showErrorWithStatus:@"请重新登录" maskType:SVProgressHUDMaskTypeBlack];
                        }else
                        {
                            
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:JMMessageNetworkError maskType:SVProgressHUDMaskTypeBlack];
                    }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _balanceCommand;
}

- (RACSubject *)balanceSubject
{
    if (!_balanceSubject) {
        _balanceSubject = [[RACSubject alloc] init];
    }
    return _balanceSubject;
}

- (RACSubject *)allPackageSubject
{
    if (!_allPackageSubject) {
        _allPackageSubject = [[RACSubject alloc] init];
    }
    return _allPackageSubject;
}


- (RACSubject *)paySuccessSubject
{
    if (!_paySuccessSubject) {
        _paySuccessSubject = [[RACSubject alloc] init];
    }
    return _paySuccessSubject;
}

#pragma mark -

- (RACCommand *)alipayCommand
{
    if (!_alipayCommand) {
        _alipayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *pay_code) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[PayApi sharedApi] alipayWithPayParam:pay_code success:^{
                    [SVProgressHUD showSuccessWithStatus:@"支付成功" maskType:SVProgressHUDMaskTypeBlack];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(PayErrorCode err_code) {
                    NSError *tempError = [[NSError alloc] initWithDomain:@"" code:err_code userInfo:nil];
                    [subscriber sendError:tempError];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _alipayCommand;
}

- (RACCommand *)wxpayCommand
{
    if (!_wxpayCommand) {
        _wxpayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *pay_code) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                NSData *data = [pay_code dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                [[PayApi sharedApi] wxPayWithPayParam:tempDict success:^{
                    [SVProgressHUD showSuccessWithStatus:@"支付成功" maskType:SVProgressHUDMaskTypeBlack];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(PayErrorCode err_code) {
                    NSError *tempError = [[NSError alloc] initWithDomain:@"" code:err_code userInfo:nil];
                    [subscriber sendError:tempError];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _wxpayCommand;
}
@end
