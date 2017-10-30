//
//  MainShareViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MainShareViewModel.h"
#import "Macro.h"

@implementation MainShareViewModel
-  (void)sdc_initialize
{
    @weakify(self)
    [self.packageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *params) {
        @strongify(self);
        [self.packageSubject sendNext:params];
    }];
}

- (RACCommand *)packageCommand
{
    if (!_packageCommand) {
        _packageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlUserPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                    switch (result) {
                        case JMCodeSuccess:
                        {
                            NSArray *array = response[@"list"];
                            if (array.count > 0) {  //有套餐
                                [subscriber sendNext:array[0]];
                                [subscriber sendCompleted];
                            }else   //无套餐
                            {
                                [subscriber sendError:nil];
                            }
                        }
                        default:   //显示无套餐页面
                            [subscriber sendError:nil];
                            break;
                    }
                }];
                
                return nil;
            }];
        }];
    }
    
    return _packageCommand;
}

- (RACCommand *)balanceCommand
{
    if (!_balanceCommand) {
        _balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                
                return nil;
            }];
        }];
    }
    
    return _balanceCommand;
}

- (RACCommand *)messageCommand
{
    if (!_messageCommand) {
        _messageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                
                return nil;
            }];
        }];
    }
    
    return _messageCommand;
}


- (RACSubject *)packageSubject
{
    if (!_packageSubject) {
        _packageSubject = [[RACSubject alloc] init];
    }
    return _packageSubject;
}
@end
