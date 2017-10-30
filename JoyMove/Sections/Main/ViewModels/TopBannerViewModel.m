//
//  TopBannerViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "TopBannerViewModel.h"
#import "MyCar.h"
#import "Macro.h"
#import "LXRequest.h"
#import "SVProgressHUD.h"

@implementation TopBannerViewModel

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
    
    [self.refreshRentStatusCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *data) {
        @strongify(self);
        [self.refreshSubject sendNext:data];
    }];
}

- (RACCommand *)refreshRentStatusCommand
{
    if (!_refreshRentStatusCommand) {
        _refreshRentStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlUserPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        if (result == JMCodeSuccess) {
                            NSArray *array = response[@"list"];
                            NSDictionary *temp = array[0];
                            [subscriber sendNext:temp];
                        }else
                        {
                            NSString *message = response[@"errMsg"];
                            message = message&&message.length?message:JMMessageNoErrMsg;
                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
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
    return _refreshRentStatusCommand;
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

- (RACSubject *)refreshSubject
{
    if (!_refreshSubject) {
        _refreshSubject = [[RACSubject alloc] init];
    }
    return _refreshSubject;
}

- (RACSubject *)tapSubject
{
    if (!_tapSubject) {
        _tapSubject = [[RACSubject alloc] init];
    }
    return _tapSubject;
}
@end
