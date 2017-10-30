//
//  BalanceViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "BalanceViewModel.h"

#import "Macro.h"
#import "LXRequest.h"
#import "SVProgressHUD.h"

@implementation BalanceViewModel

- (void)sdc_initialize
{
    @weakify(self)
    [self.checkBalanceCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *response) {
        @strongify(self)
        [self.successSubject sendNext:response];
    }];
}

- (RACCommand *)checkBalanceCommand
{
    if (!_checkBalanceCommand) {
        _checkBalanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlAccountCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [subscriber sendNext:response];
                        }else {
                            
                            NSString *message = response[@"errMsg"];
                            message = message&&message.length?message:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else {
                        [SVProgressHUD showErrorWithStatus:JMMessageNetworkError maskType:SVProgressHUDMaskTypeBlack];
                    }
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _checkBalanceCommand;
}

- (RACSubject *)successSubject
{
    if (!_successSubject) {
        _successSubject = [[RACSubject alloc] init];
    }
    return _successSubject;
}
@end
