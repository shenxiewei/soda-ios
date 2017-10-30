//
//  MissionWebViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/23.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MissionWebViewModel.h"
#import "Macro.h"
#import "SVProgressHUD.h"

@implementation MissionWebViewModel

- (void)sdc_initialize
{

}

- (RACCommand *)completeTaskCommand
{
    if (!_completeTaskCommand) {
        _completeTaskCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                 [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:input andUrl:kURL(kUrlCompleteTask) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                     [SVProgressHUD dismiss];
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [subscriber sendNext:response];
                        }else
                        {
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD showErrorWithStatus:JMMessageNoErrMsg maskType:SVProgressHUDMaskTypeBlack];
                     }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _completeTaskCommand;
}

- (RACCommand *)getRewardCommand
{
    if (!_getRewardCommand) {
        _getRewardCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:input andUrl:kURL(kUrlGetReward) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    [SVProgressHUD dismiss];
                    
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [subscriber sendNext:response];
                        }else
                        {
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else
                    {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:JMMessageNoErrMsg maskType:SVProgressHUDMaskTypeBlack];
                    }
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _getRewardCommand;
}

- (RACCommand *)getOneTaskCommand
{
    if (!_getOneTaskCommand) {
        _getOneTaskCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:input andUrl:kURL(kUrlAllMission) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    if (success) {
                
                        if (result == JMCodeSuccess) {
                            [subscriber sendNext:response];
                        }else
                        {
                            NSString *errMsg = response[@"errMsg"];
                            errMsg = errMsg&&errMsg.length?errMsg:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD showErrorWithStatus:JMMessageNoErrMsg maskType:SVProgressHUDMaskTypeBlack];
                     }
                    
                        [subscriber sendCompleted];
                    }];
                
                return nil;
            }];
        }];
    }
    return _getOneTaskCommand;
}

- (RACSubject *)completeTaskSubject
{
    if (!_completeTaskSubject) {
        _completeTaskSubject = [[RACSubject alloc] init];
    }
    return _completeTaskSubject;
}

- (RACSubject *)getRewardSubject
{
    if (!_getRewardSubject) {
        _getRewardSubject = [[RACSubject alloc] init];
    }
    return _getRewardSubject;
}

- (RACSubject *)getOneTaskSubject
{
    if (!_getRewardSubject) {
        _getRewardSubject = [[RACSubject alloc] init];
    }
    return _getOneTaskSubject;
}
@end
