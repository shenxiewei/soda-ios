//
//  ReturnCellViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/14.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "ReturnCellViewModel.h"
#import "LXRequest.h"
#import "Macro.h"
#import "SVProgressHUD.h"

@implementation ReturnCellViewModel
- (void)sdc_initialize
{
    @weakify(self)
    [self.returnCommand.executionSignals.switchToLatest subscribeNext:^(id data) {
        @strongify(self)
        [self.parkInfoSuccessSubject sendNext:nil];
    }];
}

- (RACCommand *)returnCommand
{
    if (!_returnCommand) {
        _returnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
                [LXRequest requestWithJsonDic:params andUrl:kURL(kE2EUrlUpdateParkInfo) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                     [SVProgressHUD dismiss];
                    if (success) {
                        if (result == JMCodeSuccess) {
                            [subscriber sendNext:nil];
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
    return _returnCommand;
}

- (RACSubject *)parkInfoSuccessSubject
{
    if (!_parkInfoSuccessSubject) {
        _parkInfoSuccessSubject = [[RACSubject alloc] init];
    }
    return _parkInfoSuccessSubject;
}
@end
