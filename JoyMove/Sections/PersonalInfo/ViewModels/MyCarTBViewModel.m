//
//  MyCarTBViewModel.m
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MyCarTBViewModel.h"
#import "MyCar.h"

#import "SVProgressHUD.h"
#import "LXRequest.h"
#import "Macro.h"

@implementation MyCarTBViewModel
- (void)sdc_initialize
{
    self.desImgArray = @[@[@"car_num",@"car_type",@"car_rentdate",@"car_rentdate"],@[],@[]];
    NSString *effectString = [NSString timeStamp:[MyCar shareIntance].effectiveTime/1000 DateFormat:@"yyyy.MM.dd HH:mm"];
     NSString *expireString = [NSString timeStamp:[MyCar shareIntance].expireTime/1000 DateFormat:@"yyyy.MM.dd HH:mm"];
    if ([MyCar shareIntance].licenseNum) {
        self.dataArray = @[@[[MyCar shareIntance].licenseNum,[MyCar shareIntance].carType,effectString,expireString],@[@"",@"张三",[MyCar shareIntance].phoneNum],@[]];
    }
    
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        
        [self.refreshEndSubject sendNext:nil];
    }];
}


- (RACCommand *)refreshDataCommand
{
    if (!_refreshDataCommand) {
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlUserPackageCheck) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
                        if (success) {
                            if (result == JMCodeSuccess) {
                                NSArray *array = response[@"list"];
                                if (array.count > 0) {
                                    NSDictionary *temp = array[0];
                                    if (temp[@"licenseNum"]) {
                                        [[MyCar shareIntance] loadCar:temp];
                                        NSString *effectString = [NSString timeStamp:[MyCar shareIntance].effectiveTime/1000 DateFormat:@"yyyy.MM.dd HH:mm"];
                                        NSString *expireString = [NSString timeStamp:[MyCar shareIntance].expireTime/1000 DateFormat:@"yyyy.MM.dd HH:mm"];
                                        if ([MyCar shareIntance].isFree) {
                                            self.desArray = @[@[@"车牌号:",@"车型:",@"包月起始时间:",@"包月过期时间:"],@[@"车辆状态"],@[@"最后一次车辆上报位置"]];
                                            self.dataArray = @[@[[MyCar shareIntance].licenseNum,[MyCar shareIntance].carType,effectString,expireString],@[@""],@[]];
                                        }else
                                        {
                                            self.desArray = @[@[@"车牌号:",@"车型:",@"包月起始时间:",@"包月过期时间:"],@[@"车辆状态",@"当前用户姓名",@"用户手机号"],@[@"最后一次车辆上报位置"]];
                                            self.dataArray = @[@[[MyCar shareIntance].licenseNum,[MyCar shareIntance].carType,effectString,expireString],@[@"",@"张三",[MyCar shareIntance].phoneNum],@[]];
                                        }
                                    }
                                    
                                }
                                [subscriber sendNext:nil];
                            }
                            else if (result == JMCodeNoData)
                            {
                                
                            }
                            else {
                                
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
    return _refreshDataCommand;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [[RACSubject alloc] init];
    }
    return _refreshEndSubject;
}
@end
