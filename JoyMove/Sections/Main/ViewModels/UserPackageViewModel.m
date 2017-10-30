//
//  UserPackageViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/10/13.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "UserPackageViewModel.h"
#import "Macro.h"

@implementation UserPackageViewModel

- (RACCommand *)checkPackageCommand
{
    if (!_checkPackageCommand) {
        _checkPackageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlUserPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                
                    if (success) {
                        
                        switch (result) {
                            case JMCodeSuccess:
                            {
                                NSArray *array = response[@"list"];
                                if (array) {
                                    
                                }
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }];
                return nil;
            }];
        }];
    }
    return _checkPackageCommand;
}

@end
