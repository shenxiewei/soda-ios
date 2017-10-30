//
//  SwitchViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/27.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SwitchViewModel.h"
#import "MyCar.h"
#import "Macro.h"
#import "LXRequest.h"
#import "SVProgressHUD.h"

@implementation SwitchViewModel

- (void)sdc_initialize
{
    @weakify(self)
    [self.shareCarCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.shareCarSuccessSubject sendNext:nil];
    }];
    
    [self.unShareCarCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        [self.unShareCarSuccessSubject sendNext:nil];
    }];
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


@end
