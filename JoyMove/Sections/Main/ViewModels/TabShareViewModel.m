//
//  TabShareViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/20.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TabShareViewModel.h"
#import "LXRequest.h"
#import "Macro.h"
#import "MyCar.h"
#import "SVProgressHUD.h"

@implementation TabShareViewModel

- (void)sdc_initialize
{
    @weakify(self)
    [self.messageCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *array) {
        @strongify(self)
        
        [self.messageSubject sendNext:array];
    }];
    
    [self.missionCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *params) {
       @strongify(self)
        [self.missionSubject sendNext:params];
    }];
    
    [self.shareCarCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.shareCarSuccessSubject sendNext:nil];
    }];
    
    [self.unShareCarCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.unShareCarSuccessSubject sendNext:nil];
    }];
    
    [self.checkBalanceCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *response) {
        @strongify(self)
        [self.successSubject sendNext:response];
    }];
}

- (RACCommand *)messageCommand
{
    if (!_messageCommand) {
        _messageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlRewardHistory) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (result == JMCodeSuccess) {
                        [subscriber sendNext:response[@"records"]];
                        [subscriber sendCompleted];
                    }else if(result == JMCodeNoData)
                    {
                        [subscriber sendNext:@[]];
                        [subscriber sendCompleted];
                    }
                }];
                
                return nil;
            }];
        }];
    }
    
    return _messageCommand;
}

- (RACCommand *)missionCommand
{
    if (!_missionCommand) {
        _missionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{@"userPackageId":[MyCar shareIntance].retalID} andUrl:kURL(kUrlAllMission) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                        [subscriber sendNext:response];
                        [subscriber sendCompleted];
                    }
                }];
                
                return nil;
            }];
        }];
    }
    return _missionCommand;
}

- (RACCommand *)shareCarCommand
{
    if (!_shareCarCommand) {
        _shareCarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:@{@"id":[MyCar shareIntance].retalID,@"isShare":@(1)} andUrl:kURL(kUrlShareSetting) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [SVProgressHUD showSuccessWithStatus:@"请放心，其他用户使用该车，只能还车到原处" maskType:SVProgressHUDMaskTypeBlack];
                            [subscriber sendNext:response];
                        }else {
                            
                            NSString *message = response[@"errMsg"];
                            message = message&&message.length?message:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
                            [subscriber sendError:nil];
                        }
                    }else {
                        [SVProgressHUD showErrorWithStatus:JMMessageNetworkError maskType:SVProgressHUDMaskTypeBlack];
                        [subscriber sendError:nil];
                    }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _shareCarCommand;
}

- (RACCommand *)unShareCarCommand
{
    if (!_unShareCarCommand) {
        _unShareCarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:@{@"id":[MyCar shareIntance].retalID,@"isShare":@(0)} andUrl:kURL(kUrlShareSetting) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        if (result == JMCodeSuccess) {
                            
                            [subscriber sendNext:nil];
                        }else {
                            
                            NSString *message = response[@"errMsg"];
                            message = message&&message.length?message:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
                            [subscriber sendError:nil];
                        }
                    }else {
                        [SVProgressHUD showErrorWithStatus:JMMessageNetworkError maskType:SVProgressHUDMaskTypeBlack];
                        [subscriber sendError:nil];
                    }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _unShareCarCommand;
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

- (RACSubject *)shareCarSuccessSubject
{
    if (!_shareCarSuccessSubject) {
        _shareCarSuccessSubject = [[RACSubject alloc] init];
    }
    return _shareCarSuccessSubject;
}

- (RACSubject *)unShareCarSuccessSubject
{
    if (!_unShareCarSuccessSubject) {
        _unShareCarSuccessSubject = [[RACSubject alloc] init];
    }
    return _unShareCarSuccessSubject;
}


- (RACSubject *)messageSubject
{
    if (!_messageSubject) {
        _messageSubject = [[RACSubject alloc] init];
    }
    return _messageSubject;
}

- (RACSubject *)missionSubject
{
    if (!_missionSubject) {
        _missionSubject = [[RACSubject alloc] init];
    }
    return _missionSubject;
}
@end
